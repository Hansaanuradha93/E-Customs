import UIKit
import Firebase

class RequestDetailsVM {
    
    var bindableIsApproving = Bindable<Bool>()

    
//    func updateStatus(request: Request, completion: @escaping (Bool, String) -> ()) {
//        guard let id = request.id else { return }
//        self.bindableIsApproving.value = true
//        let reference = Firestore.firestore().collection("requests").document(id)
//
//        let quntity = ["isApproved": true]
//        reference.updateData(quntity) { error in
//            self.bindableIsApproving.value = false
//            if let error = error {
//                print(error)
//                completion(false, error.localizedDescription)
//                return
//            }
//            completion(true, "Request approved successfully")
//        }
//    }
}
