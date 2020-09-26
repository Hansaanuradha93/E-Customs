import UIKit
import Firebase

class ProductDetialsVM {
    
    // MARK: Properties
    let product: Product
    
    var sizes: [String] = [] { didSet { isSizesAvailable() } }
    var selectedSize: String? { didSet { checkIsReadyToAddToBag() } }
    
    var bindableIsSizesAvailable = Bindable<Bool>()
    var bindalbeIsProductIsReady = Bindable<Bool>()
    var bindableIsSaving = Bindable<Bool>()
    
    
    // MARK: Initializers
    init(product: Product) {
        self.product = product
    }
}


// MARK: - Methods
extension ProductDetialsVM {
    
    func isSizesAvailable() {
        let isSizesAvailable = (sizes.count != 0)
        bindableIsSizesAvailable.value = isSizesAvailable
    }
    
    
    func checkIsReadyToAddToBag() {
        let isReady = selectedSize?.isEmpty == false
        bindalbeIsProductIsReady.value = isReady
    }
}


// MARK: - Firebase Methods
extension ProductDetialsVM {
    
    func addToBag(completion: @escaping (Error?) -> ()) {
        let currentUserId = Auth.auth().currentUser?.uid ?? ""
        let reference = Firestore.firestore().collection("bag").document(currentUserId).collection("items")
        let key = reference.document().documentID
    
        let documentData : [String : Any] = [
            "id" : product.id ?? "",
            "key": key,
            "name" : product.name ?? "",
            "price" : product.price ?? "",
            "thumbnail" : product.thumbnailUrl ?? "",
            "selectedSize": selectedSize ?? "0"
        ]
        
        self.bindableIsSaving.value = true
        
        reference.document(key).setData(documentData) { [weak self] error in
            guard let self = self else { return }
            self.bindableIsSaving.value = false
            
            if let error = error {
                completion(error)
                return
            }
        
            print("Product added to cart")
            completion(nil)
        }
    }
}
