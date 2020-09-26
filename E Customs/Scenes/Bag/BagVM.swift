import UIKit
import Firebase

class BagVM {
    
    var items = [Item]()
    
    
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
                    print(change.document.data())
                    let item = Item(dictionary: change.document.data())
                    self.items.append(item)
                }
            }
            completion(true)
        }
        return listener
    }
}
