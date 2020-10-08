import UIKit

class ProfilePictureCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "ProfilePictureCell"
    
    
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
        backgroundColor = .blue
    }
}
