import Firebase

struct Request {
    
    // MARK: Properties
    var id, uid, sneakerName, ideaDescription, thumbnailUrl : String?
    var price: Double?
    var isApproved: Bool?
    var timestamp: Timestamp?
    
    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.id = dictionary["id"] as? String
        self.uid = dictionary["uid"] as? String
        self.sneakerName = dictionary["sneakerName"] as? String
        self.ideaDescription = dictionary["ideaDescription"] as? String
        self.thumbnailUrl = dictionary["thumbnailUrl"] as? String
        self.price = dictionary["price"] as? Double
        self.isApproved = dictionary["isApproved"] as? Bool
        self.timestamp = dictionary["timestamp"] as? Timestamp
    }
}
