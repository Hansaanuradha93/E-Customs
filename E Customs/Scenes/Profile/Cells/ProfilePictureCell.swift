import UIKit

class ProfilePictureCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "ProfilePictureCell"
    
    private let profileImage = Asserts.personFill.withRenderingMode(.alwaysOriginal)
    private let profileImageView = ECImageView(image: Asserts.personFill, contentMode: .scaleAspectFit)
    private let separatorLine = UIView()
    
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.style()
        self.layout()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Private Methods
private extension ProfilePictureCell {
    
    func style() {
        backgroundColor = .white
        selectionStyle = .none
        
        separatorLine.backgroundColor = .lightGray
        
        profileImageView.image = profileImageView.image?.withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = .lightGray
    }
    
    
    func layout() {
        let dimensions: CGFloat = 150

        contentView.addSubviews(profileImageView, separatorLine)
        
        profileImageView.centerHorizontallyInSuperView()
        profileImageView.centerVerticallyInSuperView(padding: -10, size: .init(width: dimensions, height: dimensions))
        
        separatorLine.anchor(top: nil, leading: leadingAnchor, bottom: contentView.bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 0.2))
    }
}
