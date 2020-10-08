import Foundation

struct Request {
    
    // MARK: Properties
    var id, uid, sneakerName, ideaDescription, thumbnailUrl : String?
    var isApproved: Bool?
    
    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.id = dictionary["id"] as? String
        self.uid = dictionary["uid"] as? String
        self.sneakerName = dictionary["sneakerName"] as? String
        self.ideaDescription = dictionary["ideaDescription"] as? String
        self.thumbnailUrl = dictionary["thumbnailUrl"] as? String
        self.isApproved = dictionary["isApproved"] as? Bool
    }
}
