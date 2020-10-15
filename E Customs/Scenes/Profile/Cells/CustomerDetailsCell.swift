import UIKit

class CustomerDetailsCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "CustomerDetailsCell"
    
    fileprivate let titleLabel = ECMediumLabel(text: "CUSTOMER DETAILS", textAlignment: .left, fontSize: 17)
    
    fileprivate let fullnameLabel = ECMediumLabel(text: "Full Name", textAlignment: .left, fontSize: 17)
    fileprivate let fullnameValueLabel = ECRegularLabel(textAlignment: .left, fontSize: 15, numberOfLines: 0)
    
    fileprivate let emailLabel = ECMediumLabel(text: "Email", textAlignment: .left, fontSize: 17)
    fileprivate let emailValueLabel = ECRegularLabel(textAlignment: .left, fontSize: 15, numberOfLines: 0)
    
    fileprivate let genderLabel = ECMediumLabel(text: "Gender", textAlignment: .left, fontSize: 17)
    fileprivate let genderValueLabel = ECRegularLabel(textAlignment: .left, fontSize: 15)
    
    fileprivate let addressLabel = ECMediumLabel(text: "Shipping Address", textAlignment: .left, fontSize: 17)
    fileprivate let addressValueLabel = ECRegularLabel(textAlignment: .left, fontSize: 15, numberOfLines: 0)

    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension CustomerDetailsCell {
    
    func set(user: User, address: String) {
        fullnameValueLabel.text = "\(user.firstname ?? "") \(user.lastname ?? "")"
        emailValueLabel.text = "\(user.email ?? "")"
        addressValueLabel.text = address
        
        if user.isMale ?? false {
            genderValueLabel.text = Strings.male
        } else {
            genderValueLabel.text = Strings.female
        }
    }
    
    
    fileprivate func setupUI() {
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
