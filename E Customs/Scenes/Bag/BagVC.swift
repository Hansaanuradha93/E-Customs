import UIKit
import Firebase

class BagVC: UITableViewController {
    
    // MARK: Properties
    let viewModel = BagVM()
    fileprivate var listener: ListenerRegistration?

    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        fetchItems()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent { listener?.remove() }
    }
}


// MARK: - TableView
extension BagVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 2 || section == 3 {
            return 1
        } else if section == 1 {
            return viewModel.items.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NumberOfItemsCell.reuseID, for: indexPath) as! NumberOfItemsCell
            cell.set(count: viewModel.items.count)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseID, for: indexPath) as! ItemCell
            cell.set(item: viewModel.items[indexPath.row])
            cell.removeAction =  {
                self.deleteItem(at: indexPath)
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TotalLabel.reuseID, for: indexPath) as! TotalLabel
            cell.set(subtotal: viewModel.calculateSubtotal(), tax: viewModel.calculateTax(), total: viewModel.calculateTotal())
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutButtonCell.reuseID, for: indexPath) as! CheckoutButtonCell
            return cell
        }
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        } else if indexPath.section == 1 {
            return 160
        } else if indexPath.section == 2 {
            return 160
        } else if indexPath.section == 3 {
            return 75
        }
        return 0
    }
}


// MARK: - Methods
extension BagVC {
    
    fileprivate func deleteItem(at indexPath: IndexPath) {
        let itemToDelete = viewModel.items[indexPath.row]
        print("Deleted item: \(itemToDelete)")
        viewModel.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
    
    
    fileprivate func fetchItems() {
        listener = viewModel.fetchItems { (status) in
            if status {
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
    }
    
    
    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(NumberOfItemsCell.self, forCellReuseIdentifier: NumberOfItemsCell.reuseID)
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.reuseID)
        tableView.register(TotalLabel.self, forCellReuseIdentifier: TotalLabel.reuseID)
        tableView.register(CheckoutButtonCell.self, forCellReuseIdentifier: CheckoutButtonCell.reuseID)
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        title = "BAG"
        tabBarItem.title = ""
    }
}
