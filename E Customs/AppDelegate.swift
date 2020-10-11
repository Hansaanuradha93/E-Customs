import UIKit
import Firebase
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Stripe.setDefaultPublishableKey(StripeKeys.publishableKey)
        fetchUserDetails()
        return true
    }
}


// MARK: - Methods
extension AppDelegate {
    
    func fetchUserDetails() {
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let data = snapshot?.data(), let stripeId = data["stripeId"] {
                UserDefaults.standard.set(stripeId, forKey: UserDefaultsKeys.stripeId)
            }
        }
    }
}

