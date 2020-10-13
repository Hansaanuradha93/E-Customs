import UIKit

class OrderListVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}


// MARK: - UITableView
extension OrderListVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.reuseID, for: indexPath) as! OrderCell
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}


// MARK: - Methods
extension OrderListVC {
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = Strings.orders
        
        tableView.separatorStyle = .none
        tableView.register(OrderCell.self, forCellReuseIdentifier: OrderCell.reuseID)
    }
}
