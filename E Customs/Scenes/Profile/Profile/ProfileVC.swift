import UIKit

class ProfileVC: UITableViewController {

    // MARK: Properties
    let viewModel = ProfileVM()
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUserProfile()
    }
}


// MARK: UITableView
extension ProfileVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 4
        default:
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfilePictureCell.reuseID, for: indexPath) as! ProfilePictureCell
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDetailCell.reuseID, for: indexPath) as! ProfileDetailCell
            cell.set(name: "...", value: "...")

            if let user = viewModel.user {
                if indexPath.row == 0 {
                    cell.set(name: "First Name", value: user.firstname)
                } else if indexPath.row == 1 {
                    cell.set(name: "Last Name", value: user.lastname)
                } else if indexPath.row == 2 {
                    cell.set(name: "Email", value: user.email)
                } else if indexPath.row == 3 {
                    let gender = (user.isMale ?? false) ? "Male" : "Female"
                    cell.set(name: "Gender", value: gender)
                }
            }
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.reuseID, for: indexPath) as! ButtonCell
            cell.set(buttonType: .checkOrders)
            
            cell.buttonAction = {
                let controller = OrderListVC()
                self.navigationController?.pushViewController(controller, animated: true)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 230
        case 1:
            return 70
        case 2:
            return 75
        default:
            return 0
        }
    }
}


// MARK: - Methods
extension ProfileVC {
    
    @objc fileprivate func signout() {
        signoutUser()
    }
    
    
    fileprivate func fetchUserProfile() {
        viewModel.fetchUserProfile { [weak self] status in
            guard let self = self else { return }
            if status {
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
    }
    
    
    fileprivate func signoutUser() {
        viewModel.signout { [weak self] status, message in
            guard let self = self else { return }
            if status {
                self.goToSignup()
            } else {
                self.presentAlert(title: Strings.failed, message: message, buttonTitle: Strings.ok)
            }
        }
    }
    
    
    fileprivate func goToSignup() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = UINavigationController(rootViewController: SignupVC())
    }
    
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = Strings.profile
        tabBarItem.title = Strings.empty
        
        let signoutButton = UIBarButtonItem(title: Strings.signout, style: .plain, target: self, action: #selector(signout))
        navigationItem.rightBarButtonItem = signoutButton
        
        tableView.separatorStyle = .none
        tableView.register(ProfilePictureCell.self, forCellReuseIdentifier: ProfilePictureCell.reuseID)
        tableView.register(ProfileDetailCell.self, forCellReuseIdentifier: ProfileDetailCell.reuseID)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.reuseID)
    }
}
