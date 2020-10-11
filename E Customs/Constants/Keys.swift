import Foundation

// MARK: Stripe Keys
struct StripeKeys {
    static let publishableKey = "pk_test_Zx9wyJW7pcgyCyKX1WcGTHC500SSAmfxMG"
}


// MARK: ImagePicker Keys
struct ImagePickerKeys {
    
    struct OriginalImage {
        static let key = "UIImagePickerControllerOriginalImage"
    }

    
    struct EditedImage {
        static let key = "UIImagePickerControllerEditedImage"
    }
}


// MARK: User Defaults Key
struct UserDefaultsKeys {
    static let stripeId = "stripeId"
}
