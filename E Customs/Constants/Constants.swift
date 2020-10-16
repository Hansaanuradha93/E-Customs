import UIKit

// MARK: - Asserts
struct Asserts {
    
    // Tab Bar
    static let house = UIImage(systemName: "house")!
    static let houseFill = UIImage(systemName: "house.fill")!
    static let document = UIImage(systemName: "doc.text")!
    static let documentFill = UIImage(systemName: "doc.text.fill")!
    static let envelope = UIImage(systemName: "envelope")!
    static let envelopeFill = UIImage(systemName: "envelope.fill")!
    static let bag = UIImage(systemName: "bag")!
    static let bagFill = UIImage(systemName: "bag.fill")!
    static let person = UIImage(systemName: "person")!
    static let personFill = UIImage(systemName: "person.fill")!
    
    // Common
    static let placeHolder = UIImage(named: "placeholder")!
    
    // Bag
    static let close = UIImage(systemName: "xmark")!
    
    // Profile
    static let user = UIImage(named: "user")!
}


// MARK: - Strings
struct Strings {
    
    // Titles
    static let home = "HOME"
    static let detail = "DETAIL"
    static let shoppingBag = "SHOPPING BAG"
    static let requestList = "REQUEST LIST"
    static let requestBox = "REQUEST BOX"
    static let requestDetail = "REQUEST DETAIL"
    static let profile = "PROFILE"
    static let orders = "ORDERS"
    static let orderDetail = "ORDER DETAIL"
    
    // Placeholders
    static let empty = ""
    static let email = "Email"
    static let password = "Password"
    static let firstName = "First Name"
    static let lastName = "Last Name"
    static let sneakerName = "Sneaker Name"
    static let yourIdea = "Your Idea"
    
    // Alerts
    static let failed = "Failed"
    static let successfull = "Successful"
    static let somethingWentWrong = "Something Went Wrong, Please Try Again"
    static let orderPlacedSuccessfully = "Order Placed Successfully, Thank you!"
    static let areYouSure = "Are you sure?"
    static let doYouWantToCompleteOrder = "Do you want to complete the order"
    static let yes = "Yes"
    static let no = "No"
    
    // Labels
    static let size = "Size"
    static let noItemsYet = "NO ITEMS YET"
    static let notAvailable = "Not available"
    static let qty = "Qty"
    static let free = "Free"
    static let select = "Select"
    static let subtotal = "Subtotal"
    static let shipping = "Shipping"
    static let paymentMethod = "Payment Method"
    static let processingFees = "Processing Fees"
    static let total = "Total"
    static let gender = "Gender"
    static let lodingIndicatorDots = "..."
    
    // Buttons
    static let ok = "OK"
    static let done = "DONE"
    static let login = "LOG IN"
    static let gotoSignup = "Go to sign up"
    static let signup = "SIGN UP"
    static let gotoLogin = "Go to login"
    static let male = "Male"
    static let female = "Female"
    static let addToBag = "ADD TO BAG"
    static let placeOrder = "PLACE ORDER"
    static let checkOrders = "CHECK ORDERS"
    static let selectPhoto = "Select Photo"
    static let submit = "SUBMIT"
    static let approve = "APPROVE"
    static let signout = "SIGN OUT"
    static let completeOrder = "COMPLETE ORDER"
}


// MARK: - Fonts
struct Fonts {
    static let avenirNext = "Avenir Next"
}


// MARK: - GlobalConstants
struct GlobalConstants {
    static let height: CGFloat = 44
    static let cornerRadius: CGFloat = 3
    static let borderWidth: CGFloat = 0.5
    static let borderColor: UIColor = .gray
}
