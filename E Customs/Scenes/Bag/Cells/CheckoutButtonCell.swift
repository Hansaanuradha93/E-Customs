import UIKit

class CheckoutButtonCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "CheckoutButtonCell"
    
    fileprivate let checkoutButton = ECButton(backgroundColor: .black, titleColor: .white, radius: 2, fontSize: 16)

    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension CheckoutButtonCell {
    
    func set(buttonType: ButtonType) {
        var title = ""
        if buttonType == .checkout {
            title = Strings.checkout
        } else if buttonType == .checkOrders {
            title = Strings.checkOrders
        }
        checkoutButton.setTitle(title, for: .normal)
    }
    
    
    fileprivate func setupUI() {
        selectionStyle = .none
        let padding: CGFloat = 24
        contentView.addSubview(checkoutButton)
        
        checkoutButton.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: padding, bottom: 0, right: padding))
        checkoutButton.centerVertically(in: self, size: .init(width: 0, height: GlobalConstants.height))
    }
}
