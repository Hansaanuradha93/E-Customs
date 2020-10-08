import UIKit
import Firebase

class RequestListVM {
    
    // MARK: Properties
    var requests = [Request]()
}


// MARK: - Methods
extension RequestListVM {
    
    func fetchRequest(completion: @escaping (Bool) -> ()) -> ListenerRegistration? {
        let reference = Firestore.firestore().collection("requests")
        
        requests.removeAll()
        
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
                    let request = Request(dictionary: change.document.data())
                    self.requests.append(request)
                }
            }
            completion(true)
        }
        return listener
    }
}
