import Foundation
import Firebase

class OrderDetailsVM {
    
    // MARK: Properties
    var order: Order
    
    
    // MARK: Initializers
    init(order: Order) {
        self.order = order
    }
}


// MARK: - Methods
extension OrderDetailsVM {
    
    func fetchItems(completion: @escaping (Bool) -> ()) {
        let orderId = order.orderId ?? ""
        let reference = Firestore.firestore().collection("orders").document(orderId).collection("items")
        order.items.removeAll()
        
        reference.getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(false)
                return
            }
            
            for document in documents {
                let item = Item(dictionary: document.data())
                self.order.items.append(item)
            }
            completion(true)
        }
    }
}
