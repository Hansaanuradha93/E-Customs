import UIKit
import Firebase

class HomeVC: UITableViewController {

    // MARK: Properties
    let viewModel = HomeVM()
    fileprivate var listener: ListenerRegistration?
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchProducts()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent { listener?.remove() }
    }
}


// MARK: - UITableView
extension HomeVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseID, for: indexPath) as! ProductCell
        cell.set(product: viewModel.products[indexPath.row])
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}


// MARK: - Methods
extension HomeVC {
    
    fileprivate func fetchProducts() {
        listener = viewModel.fetchProducts { (status) in
            if status {
                DispatchQueue.main.async { self.tableView.reloadData()}
            }
        }
    }
    
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        tableView.separatorStyle = .none
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseID)
    }
}
