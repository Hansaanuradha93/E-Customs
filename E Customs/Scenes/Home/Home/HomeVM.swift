import Firebase

final class HomeVM {
    
    // MARK: Properties
    var products = [Product]()
}


// MARK: - Methods
extension HomeVM {
    
    /// This fetches the product list from firestore
    /// - Parameter completion: Returns the status of the API call
    /// - Returns: Returns a firebase listner
    func fetchProducts(completion: @escaping (Bool) -> ()) -> ListenerRegistration? {
        let reference = Firestore.firestore().collection("products")
        products.removeAll()
        
        let listener = reference.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let documentChanges = querySnapshot?.documentChanges else {
                completion(false)
                return
            }
            
            for change in documentChanges {
                if change.type == .added {
                    let product = Product(dictionary: change.document.data())
                    self.products.append(product)
                }
            }
            
            completion(true)
        }
        
        return listener
    }
}
