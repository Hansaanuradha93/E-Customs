import Firebase

class HomeVM {
    
    // MARK: Properties
    var products = [Product]()
}


// MARK: - Methods
extension HomeVM {
    
    func fetchProducts(completion: @escaping (Bool) -> ()) -> ListenerRegistration? {
        let reference = Firestore.firestore().collection("products")
        let listener = reference.addSnapshotListener { querySnapshot, error in
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
