import UIKit

struct Asserts {
    
    // Images
    static let placeHolder = UIImage(named: "placeholder")!
    
    // System Icons
    
    // Tab Bar
    static let house = UIImage(systemName: "house")!
    static let houseFill = UIImage(systemName: "house.fill")!
    static let plus = UIImage(systemName: "plus")!
    static let document = UIImage(systemName: "doc.text")!
    static let documentFill = UIImage(systemName: "doc.text.fill")!
    static let envelope = UIImage(systemName: "envelope")!
    static let envelopeFill = UIImage(systemName: "envelope.fill")!
    
    // Bag
    static let close = UIImage(systemName: "xmark")!
}


struct Strings {
    
    // Placeholders
    static let empty = ""
    static let email = "Email"
    static let password = "Password"
    static let firstName = "First Name"
    static let lastName = "Last Name"
    
    // Alerts
    static let loginFailed = "Login Failed!"
    static let signupFailed = "Signup Failed!"
    
    // Buttons
    static let ok = "OK"
    static let login = "Log In"
    static let gotoSignup = "Go to sign up"
    static let signup = "Sign Up"
    static let gotoLogin = "Go to login"
    static let male = "Male"
    static let female = "Female"
}


struct GlobalDimensions {
    
    static let height: CGFloat = 44
    static let cornerRadius: CGFloat = 3
    static let borderWidth: CGFloat = 0.5
}
