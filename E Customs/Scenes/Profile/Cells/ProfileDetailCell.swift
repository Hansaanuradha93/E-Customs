import UIKit

class ProfileDetailCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "ProfileDetailCell"
    
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension ProfileDetailCell {
    
    fileprivate func setupUI() {
        backgroundColor = .red
    }
}
