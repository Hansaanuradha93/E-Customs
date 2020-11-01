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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        if viewModel.products.count > 0 {
            cell.set(product: viewModel.products[indexPath.row])
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 445
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ProductDetailsVC(viewModel: ProductDetialsVM(product: viewModel.products[indexPath.row]))
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - Fileprivate Methods
fileprivate extension HomeVC {
    
    func fetchProducts() {
        listener = viewModel.fetchProducts { (status) in
            if status {
                self.updateUI()
            }
        }
    }
    
    
    func updateUI() {
        if self.viewModel.products.isEmpty {
            DispatchQueue.main.async { self.tableView.backgroundView = ECEmptyStateView(emptyStateType: .home) }
        } else {
            DispatchQueue.main.async { self.tableView.backgroundView = nil }
        }
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    
    func setupUI() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = Strings.home
        tabBarItem.title = Strings.empty
        
        tableView.separatorStyle = .none
        tableView.contentInset.top = 24
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseID)
    }
}
