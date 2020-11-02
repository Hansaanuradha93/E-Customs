import UIKit

class OrderDetailsVC: UITableViewController {
    
    // MARK: Properties
    var viewModel: OrderDetailsVM!
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCustomerDetails()
        fetchItems()
    }
}


// MARK: - UITableView
extension OrderDetailsVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2: return viewModel.order.items.count > 0 ? viewModel.order.items.count : 1
        case 4: return (viewModel.order.description != nil) ? 1: 0
        case 5: return viewModel.user != nil ? 1 : 0
        case 6: return  ((viewModel.order.status ?? "") == OrderStatusType.shipped.rawValue) ? 1 : 0
        default: return (viewModel.order.items.count > 0 && viewModel.user != nil) ? 1 : 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = viewModel.order
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderHeaderCell.reuseID, for: indexPath) as! OrderHeaderCell
            cell.set(order: order)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: NumberOfItemsCell.reuseID, for: indexPath) as! NumberOfItemsCell
            cell.set(count: order.itemCount ?? 0)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseID, for: indexPath) as! ItemCell
            if order.items.count > 0 {
                let item = order.items[indexPath.row]
                cell.set(item: item, itemType: .orderItem)
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentInfoCell.reuseID, for: indexPath) as! PaymentInfoCell
            let subtotal = Int((order.subtotal ?? 0) * 100)
            let proccessingFeesPennies = Int((order.proccessingFees ?? 0) * 100)
            let totalPennies = Int((order.total ?? 0) * 100)

            cell.set(subtotalPennies: subtotal, processingFeesPennies: proccessingFeesPennies, totalPennies: totalPennies, paymentMethod: order.paymentMethod ?? "", shippingMethod: order.shippingMethod ?? "")
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.reuseID, for: indexPath) as! DescriptionCell
            cell.set(description: order.description)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomerDetailsCell.reuseID, for: indexPath) as! CustomerDetailsCell
            if let user = viewModel.user, let address = viewModel.order.address {
                cell.set(user: user, address: address)
            }
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.reuseID, for: indexPath) as! ButtonCell
            cell.set(buttonType: .orderDetails)
            
            cell.buttonAction = {
                self.presentAlertAction(title: Strings.areYouSure, message: Strings.doYouWantToCompleteOrder, rightButtonTitle: Strings.yes, leftButtonTitle: Strings.no, rightButtonAction:  { (_) in
                    self.completeOrder()
                })
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 170
        case 1:
            return 70
        case 2:
            return 185
        case 3:
            return 200
        case 4:
            return viewModel.orderDesriptionCellHeight
        case 5:
            return 450
        case 6:
            return 100
        default:
            return 0
        }
    }
}


// MARK: - Fileprivate Methods
fileprivate extension OrderDetailsVC {
    
    func completeOrder() {
        viewModel.completeOrder { [weak self] status, message in
            guard let self = self else { return }
            if status {
                self.presentAlert(title: Strings.successfull, message: message, buttonTitle: Strings.ok)
                self.updateUI()
            } else {
                self.presentAlert(title: Strings.failed, message: message, buttonTitle: Strings.ok)
            }
        }
    }
    
    
    func fetchCustomerDetails() {
        viewModel.fetchCustomerDetails { [weak self] status in
            guard let self = self else { return }
            if status {
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
    }
    
    
    func fetchItems() {
        viewModel.fetchItems { [weak self] status in
            guard let self = self else { return }
            if status {
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
    }
    
    
    func updateUI() {
        viewModel.order.status = OrderStatusType.completed.rawValue
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func setupUI() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = Strings.orderDetail
                
        tableView.separatorStyle = .none
        tableView.register(OrderHeaderCell.self, forCellReuseIdentifier: OrderHeaderCell.reuseID)
        tableView.register(NumberOfItemsCell.self, forCellReuseIdentifier: NumberOfItemsCell.reuseID)
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.reuseID)
        tableView.register(PaymentInfoCell.self, forCellReuseIdentifier: PaymentInfoCell.reuseID)
        tableView.register(CustomerDetailsCell.self, forCellReuseIdentifier: CustomerDetailsCell.reuseID)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.reuseID)
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: DescriptionCell.reuseID)
    }
}
