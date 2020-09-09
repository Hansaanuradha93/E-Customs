import UIKit
import Firebase

class LoginVM {
    
    // MARK: Properties
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    
    // MARK: Bindlable
    var bindalbeIsFormValid = Bindable<Bool>()
    var bindableIsLogin = Bindable<Bool>()
}


// MARK: - Methods
extension LoginVM {
    
    func performLogin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        bindableIsLogin.value = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] response, error in
            guard let self = self else { return }
            self.bindableIsLogin.value = false
            if let error = error {
                completion(error)
                return
            }
            print("Logged in successfully")
            completion(nil)
        }
    }
    
    
    func checkFormValidity() {
        let isFormValid = email?.isEmpty == false && password?.isEmpty == false && password?.count ?? 0 >= 6
        bindalbeIsFormValid.value = isFormValid
    }
}
