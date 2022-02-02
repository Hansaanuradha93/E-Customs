import UIKit
import Firebase

final class LoginVM {
    
    // MARK: Properties
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    
    // MARK: Bindlable
    var bindalbeIsFormValid = Bindable<Bool>()
    var bindableIsLogin = Bindable<Bool>()
}


// MARK: - Public Methods
extension LoginVM {
    
    /// This authenticates an user on firebase auth
    /// - Parameter completion: Returns the status and the status message of the API call
    func performLogin(completion: @escaping (Bool, String) -> ()) {
        guard let email = email, let password = password else { return }
        bindableIsLogin.value = true
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] response, error in
            guard let self = self else { return }
            self.bindableIsLogin.value = false
            
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            completion(true, Strings.loggedInSuccessfully)
        }
    }
}


// MARK: - Private Methods
private extension LoginVM {
    
    /// This checks if the login form is validated
    func checkFormValidity() {
        let isFormValid = email?.isEmpty == false && password?.isEmpty == false && password?.count ?? 0 >= 6
        bindalbeIsFormValid.value = isFormValid
    }
}
