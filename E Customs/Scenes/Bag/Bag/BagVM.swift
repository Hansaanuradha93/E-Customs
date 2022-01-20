import UIKit
import Firebase

final class BagVM {
    
    // MARK: Properties
    var items = [Item]()
    var selectedQuantity: Int = 0
    var selectedItem: Item?
    
    private let stripeCreditCardCut = 0.029
    private let flatFeeCents = 30
        
    var shippingMethod: String?
    var paymentMethod: String?
    var address: String?
    
    var orderId = ""
    var uid = ""
    var status = OrderStatusType.created.rawValue
    var thumbnailUrl = ""
    var itemCount = 0
    var subTotalDollars = 0.0
    var proccessingFeesDollars = 0.0
    var totalDollars = 0.0
    var timestamp = Timestamp()
    
    
    // MARK: Bindables
    var bindableIsMakingPayment = Bindable<Bool>()
    
    
    // MARK: Computed Properties
    var numberOfItems: Int {
        var count = 0
        for item in items {
            count += item.quantity ?? 0
        }
        return count
    }
    
    var itemCountString: String {
        var itemCountString = ""
        if numberOfItems == 0 {
            itemCountString = Strings.noItemsYet
        } else if numberOfItems == 1 {
            itemCountString = "\(numberOfItems) Item"
        } else {
            itemCountString = "\(numberOfItems) Items"
        }
        return itemCountString
    }
    
    var subtotal: Int {
        var amount = 0
        var pricePennies = 0
        var quantity = 0
        
        for item in items {
            pricePennies = Int((Double(item.price ?? "0") ?? 0) * 100)
            quantity = item.quantity ?? 0
            amount += pricePennies * quantity
        }
        
        return amount
    }
    
    var processingFees: Int {
        if subtotal == 0 {
            return 0
        }
        
        let sub = Double(subtotal)
        let fees = Int((sub * stripeCreditCardCut)) + flatFeeCents
        return fees
    }
    
    var total: Int {
        return  subtotal + processingFees
    }
}


// MARK: - Methods
extension BagVM {
    
    /// This triggers the cloud function which deletes all the items in the bag in firestore
    func deleteAllBagItems() {
        Functions.functions().httpsCallable("recursiveDelete").call([]) { result, error in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    
    /// This triggers the cloud function which makes a charge on Stripe
    /// - Parameters:
    ///   - data: Dictionary that contains payment details of the transaction
    ///   - completion: Returns the status and the error of the API call
    func makeCharge(data: [String: Any], completion: @escaping (Bool, Error?) -> ()) {
        Functions.functions().httpsCallable("makeCharge").call(data) { result, error in
            if let error = error {
                print(error)
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }
    
    
    /// This saves the order details in firestore
    /// - Parameter completion: Returns the status and the status message of the API call
    func saveOrderDetails(completion: @escaping (Bool, String) -> ()) {
        uid = Auth.auth().currentUser?.uid ?? ""
        let orderReference = Firestore.firestore().collection("orders")
        orderId = orderReference.document().documentID
        let orderRefarence = orderReference.document(orderId)
        
        guard let address = address, let shippingMethod = shippingMethod, let paymentMethod = paymentMethod else { return }
        
        subTotalDollars = Double(self.subtotal) / 100
        proccessingFeesDollars = Double(self.processingFees) / 100
        totalDollars = Double(self.total) / 100
        
        itemCount = numberOfItems
        thumbnailUrl = items.first?.thumbnailUrl ?? ""
        timestamp = Timestamp()
        
        let orderData: [String : Any] = [
            "orderId": orderId,
            "uid": uid,
            "status": status,
            "type": OrderType.item.rawValue,
            "itemCount": numberOfItems,
            "shippingMethod": shippingMethod,
            "paymentMethod": paymentMethod,
            "address": address,
            "subtotal": subTotalDollars,
            "proccessingFees": proccessingFeesDollars,
            "total": totalDollars,
            "thumbnailUrl": thumbnailUrl,
            "timestamp": timestamp
        ]
        
        var itemData = [String: Any]()
        
        orderRefarence.setData(orderData) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                completion(false, Strings.somethingWentWrong)
                return
            }
            
            for item in self.items {
                itemData = [
                    "id" : item.id ?? "",
                    "name" : item.name ?? "",
                    "description": item.description ?? "",
                    "price" : item.price ?? "",
                    "thumbnail" : item.thumbnailUrl ?? "",
                    "selectedSize": item.selectedSize ?? "0",
                    "quantity": item.quantity ?? 1
                ]
                
                let itemReference = orderRefarence.collection("items").document(item.id ?? "")
                
                itemReference.setData(itemData)
            }
            
            completion(true, "")
        }
    }
    
    
    /// This updates the item quantity in the bag in firestore
    /// - Parameter completion: Returns the status and the status message of the API call
    func updateQuanitity(completion: @escaping (Bool, String) -> ()) {
        guard let itemId = selectedItem?.id, let currentUserId = Auth.auth().currentUser?.uid, selectedQuantity != 0 else { return }
        let reference = Firestore.firestore().collection("bag").document(currentUserId).collection("items").document(itemId)

        let quntity = ["quantity": selectedQuantity]
        
        reference.updateData(quntity) { [weak self] error in
            guard let _ = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                completion(false, Strings.somethingWentWrong)
                return
            }
            
            completion(true, Strings.quantityUpdated)
        }
    }
    
    
    /// This deletes an item from the bag in firestore
    /// - Parameters:
    ///   - item: Item object to be deleted
    ///   - completion: Returns the status and the status message of the API call
    func delete(_ item: Item, completion: @escaping (Bool, String) -> ()) {
        guard let itemId = item.id, let currentUserId = Auth.auth().currentUser?.uid else { return  }
        let reference = Firestore.firestore().collection("bag").document(currentUserId).collection("items").document(itemId)
        
        reference.delete { [weak self] error in
            guard let _ = self else { return }

            if let error = error {
                print(error.localizedDescription)
                completion(false, Strings.somethingWentWrong)
                return
            }
            
            completion(true, Strings.itemDeleted)
        }
    }
    
    
    /// This fetches the items in the bag in firestore
    /// - Parameter completion: Returns the status of the API call
    /// - Returns: Returns a firebase listner
    func fetchItems(completion: @escaping (Bool) -> ()) -> ListenerRegistration? {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return nil }
        let reference = Firestore.firestore().collection("bag").document(currentUserId).collection("items")
        
        items.removeAll()
        completion(true)
        
        let listener = reference.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }

            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let documentChanges = querySnapshot?.documentChanges else {
                completion(false)
                return
            }
            
            for change in documentChanges {
                let item = Item(dictionary: change.document.data())
                
                switch change.type {
                case .added:
                    self.items.append(item)
                case .removed:
                    if let index = self.items.firstIndex(of: item) { self.items.remove(at: index) }
                case .modified:
                    print()
                }
            }
            
            completion(true)
        }
        
        return listener
    }
}
