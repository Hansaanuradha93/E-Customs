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
        fetchItems()
    }
}


// MARK: UITableView
extension OrderDetailsVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2: return viewModel.order.items.count
        default: return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderHeaderCell.reuseID, for: indexPath) as! OrderHeaderCell
            cell.set(order: viewModel.order)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: NumberOfItemsCell.reuseID, for: indexPath) as! NumberOfItemsCell
            cell.set(count: viewModel.order.itemCount ?? 0)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseID, for: indexPath) as! ItemCell
            let item = viewModel.order.items[indexPath.row]
            cell.set(item: item, setCloseHidden: true)
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
            return 170
        default:
            return 0
        }
    }
}


// MARK: - Methods
extension OrderDetailsVC {
    
    fileprivate func fetchItems() {
        viewModel.fetchItems { [weak self] status in
            guard let self = self else { return }
            if status {
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
    }
    
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = Strings.orderDetail
                
        tableView.separatorStyle = .none
        tableView.register(OrderHeaderCell.self, forCellReuseIdentifier: OrderHeaderCell.reuseID)
        tableView.register(NumberOfItemsCell.self, forCellReuseIdentifier: NumberOfItemsCell.reuseID)
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.reuseID)
    }
}
