import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
                
        var controller: UIViewController!
        if (Auth.auth().currentUser != nil) {
            controller = ECTabBar()
        } else {
            controller = UINavigationController(rootViewController: SignupVC())
        }
        
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
}

