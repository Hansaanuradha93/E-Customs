import UIKit

class OrderDetailsVC: UIViewController {
    
    // MARK: Properties
    var viewModel: OrderDetailsVM!
    
    
    // MARK: Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    convenience init(viewModel: OrderDetailsVM) {
        self.init()
        self.viewModel = viewModel
    }

    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}


// MARK: - Methods
extension OrderDetailsVC {
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = Strings.orders
        
        print(viewModel.order)
        
//        tableView.separatorStyle = .none
//        tableView.register(OrderCell.self, forCellReuseIdentifier: OrderCell.reuseID)
    }
}
