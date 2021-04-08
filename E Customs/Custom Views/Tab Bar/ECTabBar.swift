import UIKit
import Firebase

class ECTabBar: UITabBarController {

    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUserDetails()
    }
}


// MARK: - Private Methods
private extension ECTabBar {
    
    func fetchUserDetails() {
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let data = snapshot?.data(), let stripeId = data["stripeId"] {
                UserDefaults.standard.set(stripeId, forKey: UserDefaultsKeys.stripeId)
            } else {
                self.fetchUserDetails()
            }
        }
    }
    
    
    func createHomeNC() -> UINavigationController {
        let homeVC = HomeVC()
        homeVC.tabBarItem = UITabBarItem(title: Strings.empty, image: Asserts.house, selectedImage: Asserts.houseFill)
        return UINavigationController(rootViewController: homeVC)
    }
    
    
    func createRequestListNC() -> UINavigationController {
        let requestListVC = RequestListVC()
        requestListVC.tabBarItem = UITabBarItem(title: Strings.empty, image: Asserts.envelope, selectedImage: Asserts.envelopeFill)
        return UINavigationController(rootViewController: requestListVC)
    }
    
    
    func createBagNC() -> UINavigationController {
        let bagVC = BagVC()
        bagVC.tabBarItem = UITabBarItem(title: Strings.empty, image: Asserts.bag, selectedImage: Asserts.bagFill)
        return UINavigationController(rootViewController: bagVC)
    }
    
    
    func createProfileNC() -> UINavigationController {
        let profileVC = ProfileVC()
        profileVC.tabBarItem = UITabBarItem(title: Strings.empty, image: Asserts.person, selectedImage: Asserts.personFill)
        return UINavigationController(rootViewController: profileVC)
    }
    
    
    func setupUI() {
        UITabBar.appearance().tintColor = .black
        tabBar.barTintColor = .white
        viewControllers = [createHomeNC(), createRequestListNC(), createBagNC(), createProfileNC()]
        
        let traits = [UIFontDescriptor.TraitKey.weight: UIFont.Weight.medium]
        var descriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: Fonts.avenirNext])
        descriptor = descriptor.addingAttributes([UIFontDescriptor.AttributeName.traits: traits])
        let attributesForTitle = [NSAttributedString.Key.font: UIFont(descriptor: descriptor, size: 18)]
        let attributesForLargeTitle = [NSAttributedString.Key.font: UIFont(descriptor: descriptor, size: 28)]
        UINavigationBar.appearance().titleTextAttributes = attributesForTitle
        UINavigationBar.appearance().largeTitleTextAttributes = attributesForLargeTitle
        UINavigationBar.appearance().tintColor = .darkGray
    }
}
