import Foundation

public enum ButtonType {
    case placeOrder
    case checkOrders
    case orderDetails
}


public enum ItemType {
    case bagItem
    case orderItem
}


public enum OrderStatusType: String {
    case created = "Created"
    case shipped = "Shipped"
    case completed = "Completed"
}
