import UIKit
import Firebase

class BagVM {
    
    var items = [Item]()
    
    
    func calculateSubtotal() -> Double {
        var subtotal = 0.0
        
        for item in items {
            subtotal += Double(item.price ?? "0") ?? 0
        }
        return subtotal
    }
    
    
    func calculateTax() -> Double {
        return 0.0
    }
    
    
    func calculateTotal() -> Double {
        return calculateSubtotal() + calculateTax()
    }
    
    
    func fetchItems(completion: @escaping (Bool) -> ()) -> ListenerRegistration? {
        let currentUserId = Auth.auth().currentUser?.uid ?? ""
        let reference = Firestore.firestore().collection("bag").document(currentUserId).collection("items")
        
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
                    let item = Item(dictionary: change.document.data())
                    self.items.append(item)
                }
            }
            completion(true)
        }
        return listener
    }
}
