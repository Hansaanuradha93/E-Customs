import UIKit
import Firebase

class HomeVC: UIViewController {

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


// MARK: - Methods
extension HomeVC {
    
    fileprivate func fetchProducts() {
        listener = viewModel.fetchProducts { (status) in
            if status {
                print(self.viewModel.products)
            }
        }
    }
    
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
    }
}
