import UIKit

class ProfileVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}


// MARK: UITableView
extension ProfileVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfilePictureCell.reuseID, for: indexPath) as! ProfilePictureCell
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDetailCell.reuseID, for: indexPath) as! ProfileDetailCell
            return cell
        }
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        }
        return 100
    }
}


// MARK: - Methods
extension ProfileVC {
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = Strings.profile
        tabBarItem.title = Strings.empty
        
        tableView.separatorStyle = .none
        tableView.register(ProfilePictureCell.self, forCellReuseIdentifier: ProfilePictureCell.reuseID)
        tableView.register(ProfileDetailCell.self, forCellReuseIdentifier: ProfileDetailCell.reuseID)
    }
}
