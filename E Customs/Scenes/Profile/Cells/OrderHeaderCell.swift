import UIKit
import Firebase

class OrderHeaderCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "OrderHeaderCell"
    
    fileprivate let orderNumberLabel = ECMediumLabel(textAlignment: .left, fontSize: 17, numberOfLines: 0)
    fileprivate let statusLabel = ECMediumLabel(textAlignment: .left, fontSize: 17)
    fileprivate let dateLabel = ECMediumLabel(textAlignment: .left, textColor: .gray, fontSize: 17)
    fileprivate let separatorLine = UIView()

    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension OrderHeaderCell {
    
    func set(order: Order) {
        orderNumberLabel.text = "Order #" + (order.orderId ?? "").uppercased()
        statusLabel.text =  "Order " + (order.status ?? "").uppercased()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = (order.timestamp ?? Timestamp(date: Date())).dateValue()
        dateLabel.text = formatter.string(from: date)
    }
    
    
    fileprivate func setupUI() {
        selectionStyle = .none
        let padding: CGFloat = 24
        separatorLine.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [orderNumberLabel, statusLabel, dateLabel])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .leading
        
        contentView.addSubviews(stackView, separatorLine)
        
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: padding, left: padding, bottom: 0, right: padding))
        separatorLine.anchor(top: stackView.bottomAnchor, leading: stackView.leadingAnchor, bottom: nil, trailing: stackView.trailingAnchor, padding: .init(top: padding, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0.2))
    }
}
