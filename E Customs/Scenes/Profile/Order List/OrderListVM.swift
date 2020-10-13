import UIKit
import Firebase

class OrderListVM {
    
    // MARK: Properties
    var orders = [Order]()
}


// MARK: - Methods
extension OrderListVM {
    
    func fetchOrders(completion: @escaping (Bool) -> ()) -> ListenerRegistration? {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let reference = Firestore.firestore().collection("orders")
        
        orders.removeAll()
                
        let listener = reference.whereField("uid", isEqualTo: uid).addSnapshotListener { (querySnapshot, error) in
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
                    let order = Order(dictionary: change.document.data())
                    self.orders.append(order)
                }
            }
            completion(true)
        }
        return listener
    }
}
