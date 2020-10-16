import UIKit
import Firebase

class RequestListVM {
    
    // MARK: Properties
    var requests = [Request]()
    fileprivate var requestsDictionary = [String : Request]()
}


// MARK: - Methods
extension RequestListVM {
    
    func fetchRequests(completion: @escaping (Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Firestore.firestore()
        
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
                self.requestsDictionary[request.id ?? ""] = request
            }
            self.sortRequestsByTimestamp(completion: completion)
        }
    }
    
    
    fileprivate func sortRequestsByTimestamp(completion: @escaping (Bool) -> ()) {
        let values = Array(requestsDictionary.values)
        requests = values.sorted(by: { (request1, request2) -> Bool in
            guard let timestamp1 = request1.timestamp, let timestamp2 = request2.timestamp else { return false }
            return timestamp1.compare(timestamp2) == .orderedDescending
        })
        completion(true)
    }
}
