import UIKit

class ECTabBar: UITabBarController {

    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}


// MARK: - Private Methods
extension ECTabBar {
    
    fileprivate func createHomeNC() -> UINavigationController {
        let homeVC = HomeVC()
        homeVC.tabBarItem = UITabBarItem(title: Strings.empty, image: Asserts.house, selectedImage: Asserts.houseFill)
        return UINavigationController(rootViewController: homeVC)
    }
    
    
    fileprivate func createRequestListNC() -> UINavigationController {
        let requestListVC = RequestListVC()
        requestListVC.tabBarItem = UITabBarItem(title: Strings.empty, image: Asserts.envelope, selectedImage: Asserts.envelopeFill)
        return UINavigationController(rootViewController: requestListVC)
    }
    
    
    fileprivate func createOrderListNC() -> UINavigationController {
        let orderListVC = OrderListVC()
        orderListVC.tabBarItem = UITabBarItem(title: Strings.empty, image: Asserts.document, selectedImage: Asserts.documentFill)
        return UINavigationController(rootViewController: orderListVC)
    }
    
    
    fileprivate func createBagNC() -> UINavigationController {
        let bagVC = BagVC()
        bagVC.tabBarItem = UITabBarItem(title: Strings.empty, image: Asserts.bag, selectedImage: Asserts.bagFill)
        return UINavigationController(rootViewController: bagVC)
    }
    
    
    fileprivate func createProfileNC() -> UINavigationController {
        let profileVC = ProfileVC()
        profileVC.tabBarItem = UITabBarItem(title: Strings.empty, image: Asserts.person, selectedImage: Asserts.personFill)
        return UINavigationController(rootViewController: profileVC)
    }
    
    
    fileprivate func setupUI() {
        UITabBar.appearance().tintColor = .black
        tabBar.barTintColor = .white
//        viewControllers = [createHomeNC(), createRequestListNC(), createOrderListNC(), createBagNC(), createProfileNC()]
        viewControllers = [createProfileNC()]
        
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
