import UIKit

class OrderCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseID = "OrderCell"
    
    private let thumbnailImageView = ECImageView(contentMode: .scaleAspectFill)
    private let orderNumberLabel = ECRegularLabel(text: "Order #", textAlignment: .left, fontSize: 15)
    private let itemsCountLabel = ECRegularLabel(text: "ITEMS",textAlignment: .left, textColor: .gray, fontSize: 15)
    private let priceLabel = ECRegularLabel(text: "$", textAlignment: .left, textColor: .gray, fontSize: 15)
    private let statusLabel = ECRegularLabel(textAlignment: .left, textColor: .gray, fontSize: 15)
    private let separatorLine = UIView()

    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Public Methods
extension OrderCell {
    
    func set(order: Order, isLastOrder: Bool) {
        orderNumberLabel.text = order.numberString
        priceLabel.text = "$\(order.total ?? 0.00)"
        statusLabel.text = "\(order.status ?? "")"
        itemsCountLabel.text = order.itemCountString
        thumbnailImageView.downloadImage(from: order.thumbnailUrl ?? "")
        separatorLine.alpha = isLastOrder ? 0 : 1
    }
}


// MARK: - Private Methods
private extension OrderCell {
    
    func setupUI() {
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
