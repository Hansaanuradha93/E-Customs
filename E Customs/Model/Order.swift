import Firebase

struct Order {
    
    // MARK: Properties
    var orderId, uid, status, paymentMethod, shippingMethod, address, thumbnailUrl: String?
    var subtotal, proccessingFees, total : Double?
    var itemCount: Int?
    var timestamp: Timestamp?
    var items = [Item]()
    
   
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.orderId = dictionary["orderId"] as? String
        self.uid = dictionary["uid"] as? String
        self.status = dictionary["status"] as? String
        self.paymentMethod = dictionary["paymentMethod"] as? String
        self.shippingMethod = dictionary["shippingMethod"] as? String
        self.address = dictionary["address"] as? String
        self.thumbnailUrl = dictionary["thumbnailUrl"] as? String
        self.subtotal = dictionary["subtotal"] as? Double
        self.proccessingFees = dictionary["proccessingFees"] as? Double
        self.total = dictionary["total"] as? Double
        self.itemCount = dictionary["itemCount"] as? Int
        self.timestamp = dictionary["timestamp"] as? Timestamp
    }
    
    
    init(orderId: String?, uid: String?, status: String?, paymentMethod: String?, shippingMethod: String?, address: String?, thumbnailUrl: String?, subtotal: Double, proccessingFees: Double?, total: Double?, itemCount: Int?, timestamp: Timestamp?) {
        self.orderId = orderId
        self.uid = uid
        self.status = status
        self.paymentMethod = paymentMethod
        self.shippingMethod = shippingMethod
        self.address = address
        self.thumbnailUrl = thumbnailUrl
        self.subtotal = subtotal
        self.proccessingFees = proccessingFees
        self.total = total
        self.itemCount = itemCount
        self.timestamp = timestamp
    }
}
