import Foundation

struct User {
    
    // MARK: Properties
    var uid, firstname, lastname, email: String?
    var isAdminUser, isMale: Bool?
    
    
    // MARK: Computed Properties
    var fullName: String {
        return "\(firstname ?? "") \(lastname ?? "")"
    }
    
    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.uid = dictionary["uid"] as? String
        self.firstname = dictionary["firstname"] as? String
        self.lastname = dictionary["lastname"] as? String
        self.email = dictionary["email"] as? String
        self.isAdminUser = dictionary["isAdminUser"] as? Bool
        self.isMale = dictionary["isMale"] as? Bool
    }
}
