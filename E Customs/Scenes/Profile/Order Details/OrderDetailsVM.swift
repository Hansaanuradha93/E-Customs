import Firebase

class OrderDetailsVM {
    
    // MARK: Properties
    var order: Order
    var user: User? = nil
    
    
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
                print(error)
                completion(false, error.localizedDescription)
                return
            }
            
            completion(true, "Order completed successfully")
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
