import Firebase

final class OrderDetailsVM {
    
    // MARK: Properties
    var order: Order
    var user: User? = nil
    
    
    // MARK: Computed Properties
    var orderDesriptionCellHeight: CGFloat {
        var height: CGFloat = 0
        let charactors = order.description?.count ?? 0
        
        if charactors <= 50 {
            height = 100
        } else if charactors <= 100 {
            height = 120
        } else if charactors <= 150 {
            height = 145
        } else if charactors <= 200 {
            height = 165
        } else if charactors <= 250 {
            height = 190
        } else if charactors <= 300 {
            height = 215
        } else if charactors <= 350 {
            height = 240
        } else if charactors <= 400 {
            height = 265
        } else if charactors <= 450 {
            height = 290
        } else if charactors <= 500 {
            height = 315
        } else if charactors <= 550 {
            height = 340
        } else if charactors <= 600 {
            height = 365
        } else {
            height = 400
        }
        
        return height
    }
    
    
    // MARK: Initializers
    init(order: Order) {
        self.order = order
    }
}


// MARK: - Methods
extension OrderDetailsVM {
    
    func completeOrder(completion: @escaping (Bool, String) -> ()) {
        guard let orderID = order.orderId else { return }
        let reference = Firestore.firestore().collection("orders").document(orderID)
        let data = ["status": OrderStatusType.completed.rawValue]
                
        reference.updateData(data) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, Strings.somethingWentWrong)
                return
            }
            
            completion(true, Strings.orderCompleted)
        }
    }
    
    
    func fetchCustomerDetails(completion: @escaping (Bool) -> ()) {
        let customerUID = order.uid ?? ""
        let reference = Firestore.firestore().collection("users").document(customerUID)
        
        reference.getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let data = snapshot?.data() else {
                completion(false)
                return
            }
            
            self.user = User(dictionary: data)
            completion(true)
        }
    }
    
    
    func fetchItems(completion: @escaping (Bool) -> ()) {
        let orderId = order.orderId ?? ""
        let reference = Firestore.firestore().collection("orders").document(orderId).collection("items")
        order.items.removeAll()
        
        reference.getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(false)
                return
            }
            
            for document in documents {
                let item = Item(dictionary: document.data())
                self.order.items.append(item)
            }
            completion(true)
        }
    }
}
