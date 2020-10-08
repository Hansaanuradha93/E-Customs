import UIKit
import Firebase

class RequestListVM {
    
    // MARK: Properties
    var requests = [Request]()
}


// MARK: - Methods
extension RequestListVM {
    
    func fetchRequests(completion: @escaping (Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Firestore.firestore()
        requests.removeAll()
        
        reference.collection("requests").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, error) in
            if let error = error {
                print(error)
                completion(false)
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(false)
                return
            }
            for document in documents {
                let request = Request(dictionary: document.data())
                self.requests.append(request)
            }
            completion(true)
        }
    }
}
