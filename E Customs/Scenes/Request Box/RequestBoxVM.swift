import UIKit

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
    
    func checkFormValidity() {
        let isFormValid = sneakerName?.isEmpty == false && ideaDescription?.isEmpty == false
        bindalbeIsFormValid.value = isFormValid
    }
}
