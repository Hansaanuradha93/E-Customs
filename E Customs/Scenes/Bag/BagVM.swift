import UIKit
import Firebase

class BagVM {
    
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
    var status = "Created"
    var thumbnailUrl = ""
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
    
    func deleteAllBagItems() {
        Functions.functions().httpsCallable("recursiveDelete").call([]) { result, error in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    
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
    
    
    func saveOrderDetails(completion: @escaping (Bool, String) -> ()) {
        uid = Auth.auth().currentUser?.uid ?? ""
        let orderReference = Firestore.firestore().collection("orders")
        orderId = orderReference.document().documentID
        let orderRefarence = orderReference.document(orderId)
        
        guard let address = address, let shippingMethod = shippingMethod, let paymentMethod = paymentMethod else { return }
        let subtotoal = Double(self.subtotal) / 100
        let proccessingFees = Double(self.processingFees) / 100
        let total = Double(self.total) / 100
        
        thumbnailUrl = items.first?.thumbnailUrl ?? ""
        timestamp = Timestamp()
        
        
        let orderData: [String : Any] = [
            "orderId": orderId,
            "uid": uid,
            "status": status,
            "itemCount": numberOfItems,
            "shippingMethod": shippingMethod,
            "paymentMethod": paymentMethod,
            "address": address,
            "subtotal": subtotoal,
            "proccessingFees": proccessingFees,
            "total": total,
            "thumbnailUrl": thumbnailUrl,
            "timestamp": timestamp
        ]
        
        var itemData = [String: Any]()
        
        orderRefarence.setData(orderData) { (error) in
            if let error = error {
                print(error)
                completion(false, error.localizedDescription)
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
    
    
    func updateQuanitity(completion: @escaping (Bool, String) -> ()) {
        guard let itemId = selectedItem?.id, let currentUserId = Auth.auth().currentUser?.uid, selectedQuantity != 0 else { return }
        let reference = Firestore.firestore().collection("bag").document(currentUserId).collection("items").document(itemId)

        let quntity = ["quantity": selectedQuantity]
        reference.updateData(quntity) { error in
            if let error = error {
                print(error)
                completion(false, error.localizedDescription)
                return
            }
            completion(true, "Quantity updated successfully")
        }
    }
    
    
    func delete(_ item: Item, completion: @escaping (Bool, String) -> ()) {
        guard let itemId = item.id, let currentUserId = Auth.auth().currentUser?.uid else { return  }
        let reference = Firestore.firestore().collection("bag").document(currentUserId).collection("items").document(itemId)
        
        reference.delete { error in
            if let error = error {
                print(error)
                completion(false, error.localizedDescription)
                return
            }
            completion(true, "Item deleted successfully")
        }
    }
    
    
    func fetchItems(completion: @escaping (Bool) -> ()) -> ListenerRegistration? {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return nil }
        let reference = Firestore.firestore().collection("bag").document(currentUserId).collection("items")
        
        items.removeAll()
        
        let listener = reference.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error)
                completion(false)
                return
            }
            guard let documentChanges = querySnapshot?.documentChanges else {
                completion(false)
                return
            }
            for change in documentChanges {
                if change.type == .added {
                    let item = Item(dictionary: change.document.data())
                    self.items.append(item)
                }
            }
            completion(true)
        }
        return listener
    }
}
