import Stripe
import FirebaseFunctions

class StripeAPI: NSObject, STPCustomerEphemeralKeyProvider {
    
    // MARK: Properties
    static let shared = StripeAPI()
    
    
    // MARK: Initializers
    private override init() {}
}


// MARK: - STPCustomerEphemeralKeyProvider
extension StripeAPI {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let customerId = UserDefaults.standard.string(forKey: UserDefaultsKeys.stripeId) ?? ""
        print(customerId)
        let data = [
            "stripe_version": apiVersion,
            "customer_id": customerId
        ]
        
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
            if let error = error {
                print(error)
                completion(nil, error)
                return
            }
            
            guard let key = result?.data as? [String: Any] else {
                completion(nil, nil)
                return
            }
            
            completion(key, nil)
        }
    }
}
