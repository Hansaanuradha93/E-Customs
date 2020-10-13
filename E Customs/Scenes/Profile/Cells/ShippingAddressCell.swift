import UIKit

class ShippingAddressCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "ShippingAddressCell"
    
    fileprivate let titleLabel = ECMediumLabel(text: "SHIPPING ADDRESS", textAlignment: .left, fontSize: 17)
    fileprivate let valueLabel = ECRegularLabel(textAlignment: .left, fontSize: 17, numberOfLines: 0)

    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension ShippingAddressCell {
    
    func set(address: String) {
        valueLabel.text = address
    }
    
    
    fileprivate func setupUI() {
        selectionStyle = .none
        let padding: CGFloat = 24
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .leading
        
        contentView.addSubviews(stackView)
        
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: padding, left: padding, bottom: 0, right: padding))
    }
}
