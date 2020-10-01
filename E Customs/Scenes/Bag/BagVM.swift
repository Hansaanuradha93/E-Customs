import UIKit
import Firebase

class BagVM {
    
    // MARK: Properties
    var items = [Item]()
    var selectedQuantity: Int = 0
    var selectedItem: Item?
}


// MARK: - Methods
extension BagVM {
    
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
    
    
    func updateQuanitity(completion: @escaping (Bool, String) -> ()) {
        guard let itemId = selectedItem?.id, let currentUserId = Auth.auth().currentUser?.uid, selectedQuantity != 0 else { return }
        let reference = Firestore.firestore().collection("bag").document(currentUserId).collection("items").document(itemId)

        let quntity = ["quantity": selectedQuantity]
        reference.updateData(quntity) { error in
            if let error = error {
                print(error)
                completion(false, error.localizedDescription)
                return
            }
            print("Quantity updated successfully")
            completion(true, "")
        }
    }
    
    
    func delete(_ item: Item, completion: @escaping (Bool, String) -> ()) {
        guard let itemId = item.id, let currentUserId = Auth.auth().currentUser?.uid else { return  }
        let reference = Firestore.firestore().collection("bag").document(currentUserId).collection("items").document(itemId)
        
        reference.delete { error in
            if let error = error {
                print(error)
                completion(false, error.localizedDescription)
                return
            }
            print("Item deleted successfully")
            completion(true, "")
        }
    }
    
    
    func fetchItems(completion: @escaping (Bool) -> ()) -> ListenerRegistration? {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return nil }
        let reference = Firestore.firestore().collection("bag").document(currentUserId).collection("items")
        
        items.removeAll()
        
        let listener = reference.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error)
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