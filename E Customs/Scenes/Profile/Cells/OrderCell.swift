import UIKit

class OrderCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseID = "OrderCell"
    
    fileprivate let thumbnailImageView = ECImageView(contentMode: .scaleAspectFill)
    fileprivate let orderNumberLabel = ECRegularLabel(text: "Order #", textAlignment: .left, fontSize: 15)
    fileprivate let itemsCountLabel = ECRegularLabel(text: "ITEMS",textAlignment: .left, textColor: .gray, fontSize: 15)
    fileprivate let priceLabel = ECRegularLabel(text: "$", textAlignment: .left, textColor: .gray, fontSize: 15)
    fileprivate let statusLabel = ECRegularLabel(textAlignment: .left, textColor: .gray, fontSize: 15)
    fileprivate let separatorLine = UIView()

    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension OrderCell {
    
    func set(order: Order, isLastOrder: Bool) {
        orderNumberLabel.text = "Order #\(order.orderId ?? "")"
        priceLabel.text = "$\(order.total ?? 0.00)"
        statusLabel.text = "\(order.status ?? "")"
        thumbnailImageView.downloadImage(from: order.thumbnailUrl ?? "")
        
        var itemCountString = ""
        if let itemCount = order.itemCount {
            if itemCount == 0 {
                itemCountString = Strings.noItemsYet
            } else if itemCount == 1 {
                itemCountString = "\(itemCount) Item"
            } else {
                itemCountString = "\(itemCount) Items"
            }
        }
        
        itemsCountLabel.text = itemCountString
        
        if isLastOrder {
            separatorLine.alpha = 0
        } else {
            separatorLine.alpha = 1
        }
    }
    
    
    fileprivate func setupUI() {
        selectionStyle = .none
        
        let paddingTop: CGFloat = 24
        let dimensions: CGFloat = 102
        
        let stackView = UIStackView(arrangedSubviews: [orderNumberLabel, itemsCountLabel, priceLabel, statusLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        
        separatorLine.backgroundColor = .lightGray
        
        contentView.addSubviews(thumbnailImageView, stackView, separatorLine)

        thumbnailImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: paddingTop, left: paddingTop, bottom: 0, right: 0), size: .init(width: dimensions, height: dimensions))
        stackView.anchor(top: thumbnailImageView.topAnchor, leading: thumbnailImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: paddingTop / 2, bottom: paddingTop, right: paddingTop))
        separatorLine.anchor(top: thumbnailImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: paddingTop, left: paddingTop, bottom: 0, right: paddingTop), size: .init(width: 0, height: 0.2))
    }
}
