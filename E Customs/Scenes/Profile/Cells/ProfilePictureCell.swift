import UIKit

class ProfilePictureCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "ProfilePictureCell"
    
    fileprivate let profileImage = ECImageView(image: Asserts.user, contentMode: .scaleAspectFill)
    fileprivate let separatorLine = UIView()
    
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension ProfilePictureCell {
    
    fileprivate func setupUI() {
        backgroundColor = .white
        separatorLine.backgroundColor = .lightGray

        contentView.addSubviews(profileImage, separatorLine)
        
        let dimensions: CGFloat = 150
        let paddingTop: CGFloat = 44
        profileImage.centerInSuperview(size: .init(width: dimensions, height: dimensions))
        separatorLine.anchor(top: profileImage.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: paddingTop, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0.2))
        
        profileImage.setRoundedBorder(borderColor: GlobalConstants.borderColor, borderWidth: GlobalConstants.borderWidth, radius: dimensions / 2)
    }
}
