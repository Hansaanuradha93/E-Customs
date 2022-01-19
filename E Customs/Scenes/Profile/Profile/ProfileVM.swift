import Firebase

final class ProfileVM {
    
    // MARK: Properties
    var user: User?
}


// MARK: - Methods
extension ProfileVM {
    
    /// This cleares the stripe id of the customer from user defaults
    func clearStripeCustomerData() {
        UserDefaults.standard.set("", forKey: UserDefaultsKeys.stripeId)
    }
    
    
    
    /// This fetches the profile details of the user from firestore
    /// - Parameter completion: Returns the status of the API call
    func fetchUserProfile(completion: @escaping (Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Firestore.firestore().collection("users").document(uid)
        
        reference.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let snapshotData = snapshot?.data() else {
                completion(false)
                return
            }
            
            self.user = User(dictionary: snapshotData)
            completion(true)
        }
    }
    
    
    /// This signout the user from firebase
    /// - Parameter completion: Returns the status and the status message of the API call
    func signout(completion: @escaping (Bool, String) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(true, "")
        } catch( let error) {
            print(error)
            completion(false, error.localizedDescription)
        }
    }
}
