import Foundation

struct Product {
    
    // MARK: Properties
    var id, name, price, sizes, thumbnailUrl: String?
    
    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.price = dictionary["price"] as? String
        self.sizes = dictionary["sizes"] as? String
        self.thumbnailUrl = dictionary["thumbnailUrl"] as? String
    }
}
