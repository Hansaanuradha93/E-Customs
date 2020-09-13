import UIKit

class ECTabBar: UITabBarController {

    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .black
        viewControllers = [createHomeNC(), createOrderListNC(), createRequestBoxNC()]
    }
}


// MARK: - Private Methods
extension ECTabBar {
    
    fileprivate func createHomeNC() -> UINavigationController {
        let homeVC = HomeVC()
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        return UINavigationController(rootViewController: homeVC)
    }
    
    
    fileprivate func createOrderListNC() -> UINavigationController {
        let orderListVC = OrderListVC()
        orderListVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "doc.text"), selectedImage: UIImage(systemName: "doc.text.fill"))
        return UINavigationController(rootViewController: orderListVC)
    }
    
    
    fileprivate func createRequestBoxNC() -> UINavigationController {
        let requestBoxVC = RequestBoxVC()
        requestBoxVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "envelope"), selectedImage: UIImage(systemName: "envelope.fill"))
        return UINavigationController(rootViewController: requestBoxVC)
    }
}
