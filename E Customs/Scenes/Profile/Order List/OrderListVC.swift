import UIKit
import Firebase

class OrderListVC: UITableViewController {
    
    // MARK: Properties
    let viewModel = OrderListVM()
    fileprivate var listener: ListenerRegistration?

    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOrders()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent { listener?.remove() }
    }
}


// MARK: - UITableView
extension OrderListVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orders.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.reuseID, for: indexPath) as! OrderCell
        let isLastOrder = (indexPath.row == viewModel.orders.count - 1)
        cell.set(order: viewModel.orders[indexPath.item], isLastOrder: isLastOrder)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = viewModel.orders[indexPath.row]
        let controller = OrderDetailsVC(viewModel: OrderDetailsVM(order: order))
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - Methods
extension OrderListVC {
    
    
    fileprivate func fetchOrders() {
        listener = viewModel.fetchOrders { [weak self] status in
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
        title = Strings.orders
        
        tableView.separatorStyle = .none
        tableView.register(OrderCell.self, forCellReuseIdentifier: OrderCell.reuseID)
    }
}
