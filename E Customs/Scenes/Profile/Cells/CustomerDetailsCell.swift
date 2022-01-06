import UIKit

class CustomerDetailsCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "CustomerDetailsCell"
    
    private let titleLabel = ECMediumLabel(text: Strings.customerDetails, textAlignment: .left, fontSize: 17)
    
    private let fullnameLabel = ECMediumLabel(text: Strings.fullname, textAlignment: .left, fontSize: 17)
    private let fullnameValueLabel = ECRegularLabel(textAlignment: .left, fontSize: 15, numberOfLines: 0)
    
    private let emailLabel = ECMediumLabel(text: Strings.email, textAlignment: .left, fontSize: 17)
    private let emailValueLabel = ECRegularLabel(textAlignment: .left, fontSize: 15, numberOfLines: 0)
    
    private let genderLabel = ECMediumLabel(text: Strings.gender, textAlignment: .left, fontSize: 17)
    private let genderValueLabel = ECRegularLabel(textAlignment: .left, fontSize: 15)
    
    private let addressLabel = ECMediumLabel(text: Strings.shippingAddress, textAlignment: .left, fontSize: 17)
    private let addressValueLabel = ECRegularLabel(textAlignment: .left, fontSize: 15, numberOfLines: 0)

    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Public Methods
extension CustomerDetailsCell {
    
    func set(user: User, address: String) {
        fullnameValueLabel.text = user.fullName
        emailValueLabel.text = "\(user.email ?? "")"
        addressValueLabel.text = address
        genderValueLabel.text = user.gender
    }
}


// MARK: - Private Methods
private extension CustomerDetailsCell {
    
    func layout() {
        selectionStyle = .none
        
        let padding: CGFloat = 24
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, fullnameLabel, fullnameValueLabel, emailLabel, emailValueLabel, genderLabel, genderValueLabel, addressLabel, addressValueLabel])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .leading
        
        contentView.addSubviews(stackView)
        
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: padding, left: padding, bottom: 0, right: padding))
    }
}
