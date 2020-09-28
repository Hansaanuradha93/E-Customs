import Foundation

struct Item {
    
    // MARK: Properties
    var id, key, name, price, selectedSize, thumbnailUrl: String?
    
    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.id = dictionary["id"] as? String
        self.key = dictionary["key"] as? String
        self.name = dictionary["name"] as? String
        self.price = dictionary["price"] as? String
        self.selectedSize = dictionary["selectedSize"] as? String
        self.thumbnailUrl = dictionary["thumbnail"] as? String
    }
}

