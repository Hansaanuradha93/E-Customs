import UIKit
import Firebase

class RequestBoxVM {
    
    // MARK: Properties
    var sneakerName: String? { didSet { checkFormValidity() } }
    var ideaDescription: String? { didSet { checkFormValidity() } }
    
    // MARK: Bindlable
    var bindableImage = Bindable<UIImage>()
    var bindalbeIsFormValid = Bindable<Bool>()
    var bindableIsSaving = Bindable<Bool>()
}


// MARK: - Methods
extension RequestBoxVM {
    
    func submitRequest(completion: @escaping (Bool, String) -> ()) {
        if let _ = bindableImage.value {
            saveImageToFirebase(completion: completion)
        } else {
            bindableIsSaving.value = true
            saveInfoToFirestore(imageUrl: "", completion: completion)
        }
    }
    
    
    fileprivate func saveImageToFirebase(completion: @escaping (Bool, String) -> ()) {
        guard let image = self.bindableImage.value,
        let uploadData = image.jpegData(compressionQuality: 0.75) else { return }
        self.bindableIsSaving.value = true
        let filename = UUID().uuidString
        let storageRef = Storage.storage().reference().child("images/\(filename)")
        
        storageRef.putData(uploadData, metadata: nil) { (_, error) in
            if let error = error {
                self.bindableIsSaving.value = false
                completion(false, error.localizedDescription)
                return
            }
            self.fetchImageDownloadUrl(reference: storageRef, completion: completion)
        }
    }
    
    
    fileprivate func fetchImageDownloadUrl(reference: StorageReference, completion: @escaping (Bool, String) -> ()) {
        reference.downloadURL { (url, error) in
            if let error = error {
                self.bindableIsSaving.value = false
                completion(false, error.localizedDescription)
                return
            }
            let downloadUrl = url?.absoluteString ?? ""
            self.saveInfoToFirestore(imageUrl: downloadUrl, completion: completion)
        }
    }
    
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Bool, String) -> ()) {
        let reference = Firestore.firestore().collection("requests")
        let documentId = reference.document().documentID
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        let productInfo: [String: Any] = [
            "id": documentId,
            "uid": uid,
            "sneakerName": sneakerName ?? "",
            "ideaDescription": ideaDescription ?? "",
            "thumbnailUrl": imageUrl,
            "isApproved": false
        ]
        
        reference.document(documentId).setData(productInfo) { [weak self] error in
            guard let self = self else { return }
            self.bindableIsSaving.value = false
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            completion(true, "Request submitted successfully")
        }
    }
    
    
    func checkFormValidity() {
        let isFormValid = sneakerName?.isEmpty == false && ideaDescription?.isEmpty == false
        bindalbeIsFormValid.value = isFormValid
    }
}
