import Firebase

class ProfileVM {
    
    // MARK: Properties
    var user: User?
}


// MARK: - Methods
extension ProfileVM {
    
    func fetchUserProfile(completion: @escaping (Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Firestore.firestore().collection("users").document(uid)
        
        reference.getDocument { (snapshot, error) in
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
}
