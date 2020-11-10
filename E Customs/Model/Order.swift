import Firebase

struct Order {
    
    // MARK: Properties
    var orderId, uid, type, status, description, paymentMethod, shippingMethod, address, thumbnailUrl: String?
    var subtotal, proccessingFees, total : Double?
    var itemCount: Int?
    var timestamp: Timestamp?
    var items = [Item]()
    
    
    // MARK: Computed Properties
    var itemCountString: String {
        var itemCountString = ""
        if let itemCount = itemCount {
            if itemCount == 0 {
                itemCountString = Strings.noItemsYet
            } else if itemCount == 1 {
                itemCountString = "\(itemCount) Item"
            } else {
                itemCountString = "\(itemCount) Items"
            }
        }
        return itemCountString
    }
    
    var typeNumberString: String {
        if let type = type, let id = orderId {
            return "\(type) Order #\(id)"
        }
        return "Unknown order"
    }
    
    var numberString: String {
        if let id = orderId {
            return "Order #\(id)"
        }
        return "Unknown order number"
    }
    
    var statusString: String {
        if let status = status {
            return "Order \(status)"
        }
        return "Unknown order status"
    }
    
    var dateString: String {
        if let timestamp = timestamp {
            return timestamp.toString()
        }
        return ""
    }
    
   
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.orderId = dictionary["orderId"] as? String
        self.uid = dictionary["uid"] as? String
        self.status = dictionary["status"] as? String
        self.type = dictionary["type"] as? String
        self.description = dictionary["description"] as? String
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
    
    
    init(orderId: String?, uid: String?, type: String?, status: String?, description: String?, paymentMethod: String?, shippingMethod: String?, address: String?, thumbnailUrl: String?, subtotal: Double, proccessingFees: Double?, total: Double?, itemCount: Int?, timestamp: Timestamp?) {
        self.orderId = orderId
        self.uid = uid
        self.type = type
        self.status = status
        self.description = description
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
