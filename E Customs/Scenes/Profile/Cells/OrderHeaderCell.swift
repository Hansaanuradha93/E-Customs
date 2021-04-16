import UIKit
import Firebase

class OrderHeaderCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "OrderHeaderCell"
    
    private let orderNumberLabel = ECMediumLabel(textAlignment: .left, fontSize: 17, numberOfLines: 0)
    private let statusLabel = ECMediumLabel(textAlignment: .left, fontSize: 17)
    private let dateLabel = ECMediumLabel(textAlignment: .left, textColor: .gray, fontSize: 17)

    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Public Methods
extension OrderHeaderCell {
    
    func set(order: Order) {
        orderNumberLabel.text = order.typeNumberString.uppercased()
        statusLabel.text =  order.statusString.uppercased()
        dateLabel.text = order.dateString
    }
}


// MARK: - Private Methods
private extension OrderHeaderCell {
    
    func setupUI() {
        selectionStyle = .none
        let padding: CGFloat = 24
        
        let stackView = UIStackView(arrangedSubviews: [orderNumberLabel, statusLabel, dateLabel])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .leading
        
        contentView.addSubviews(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: padding, left: padding, bottom: 0, right: padding))
    }
}
