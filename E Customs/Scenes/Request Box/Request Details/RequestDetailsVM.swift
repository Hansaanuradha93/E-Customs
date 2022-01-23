import UIKit
import Firebase

final class RequestDetailsVM {
    
    // MARK: Properties
    var request: Request?
    
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
    var bindableIsApproving = Bindable<Bool>()
    var bindableIsMakingPayment = Bindable<Bool>()
    
    
    // MARK: Computed Properties
    var subtotal: Int = 0
    
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


// MARK: - Method
extension RequestDetailsVM {
    
    ///   /// This triggers the cloud function which makes a charge on Stripe
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
        
        itemCount = 1
        thumbnailUrl = request?.thumbnailUrl ?? ""
        timestamp = Timestamp()
        
        let orderData: [String : Any] = [
            "orderId": orderId,
            "uid": uid,
            "status": status,
            "type": OrderType.design.rawValue,
            "description": request?.ideaDescription ?? "",
            "itemCount": itemCount,
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
        
        orderRefarence.setData(orderData) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, Strings.somethingWentWrong)
                return
            }
            
            itemData = [
                "id" : self.request?.id ?? "",
                "name" : self.request?.sneakerName ?? "",
                "description": self.request?.ideaDescription ?? "",
                "price" : "\(self.request?.price ?? 0.0)",
                "thumbnail" : self.request?.thumbnailUrl ?? "",
                "selectedSize": "Not Verified",
                "quantity": self.itemCount
            ]
            let itemReference = orderRefarence.collection("items").document(self.request?.id ?? "")
            
            itemReference.setData(itemData)
            completion(true, "")
        }
    }
    
    /// This deletes a request in firestore
    func deleteRequest() {
        let requestId = request?.id ?? ""
        let reference = Firestore.firestore()
        
        reference.collection("requests").document(requestId).delete { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print(Strings.requestDeleted)
        }
    }
}
