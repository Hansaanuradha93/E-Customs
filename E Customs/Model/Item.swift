import Foundation

struct Item {
    
    // MARK: Properties
    var id, name, description, price, selectedSize, thumbnailUrl: String?
    var quantity: Int?
    
    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.description = dictionary["description"] as? String
        self.price = dictionary["price"] as? String
        self.selectedSize = dictionary["selectedSize"] as? String
        self.thumbnailUrl = dictionary["thumbnail"] as? String
        self.quantity = dictionary["quantity"] as? Int
    }
}

