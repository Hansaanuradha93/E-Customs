import UIKit

class ProfileDetailCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "ProfileDetailCell"
    
    fileprivate let nameLabel = ECMediumLabel(textAlignment: .left, fontSize: 19)
    fileprivate let valueLabel = ECRegularLabel(textAlignment: .left, fontSize: 19)
    fileprivate let separatorLine = UIView()
    
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension ProfileDetailCell {
    
    func set(name: String, value: String?) {
        nameLabel.text = name
        valueLabel.text = value ?? ""
    }
    
    
    fileprivate func setupUI() {
        backgroundColor = .white
        selectionStyle = .none
        separatorLine.backgroundColor = .lightGray
                
        contentView.addSubviews(nameLabel, valueLabel, separatorLine)
        
        let padding: CGFloat = 24
        let paddingLeft: CGFloat = 36
        nameLabel.centerVertically(in: contentView)
        nameLabel.anchor(top: nil, leading: contentView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 24, bottom: 0, right: 0), size: .init(width: 100, height: 40))
        valueLabel.centerVertically(in: contentView)
        valueLabel.anchor(top: nil, leading: nameLabel.trailingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: paddingLeft, bottom: 0, right: padding))
        separatorLine.anchor(top: nil, leading: leadingAnchor, bottom: contentView.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: padding, bottom: 0, right: 0), size: .init(width: 0, height: 0.2))

    }
}
