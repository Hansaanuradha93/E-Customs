import Foundation

public enum ButtonType {
    case placeOrder
    case checkOrders
    case orderDetails
    case requestDetails
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


public enum EmptyStateType {
    case home
    case requestBox
    case shoppinBag
    case order
}
