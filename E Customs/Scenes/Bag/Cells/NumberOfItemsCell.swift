import UIKit

class NumberOfItemsCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseID = "NumberOfItemsCell"
    fileprivate let itemsCountLabel = ECRegularLabel(textAlignment: .left, fontSize: 17)
    
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Public Methods
extension NumberOfItemsCell {
    
    func set(itemCountString: String) {
        itemsCountLabel.text = itemCountString
    }
}


// MARK: - Fileprivate Methods
fileprivate extension NumberOfItemsCell {
    
    func setupUI() {
        let padding: CGFloat = 24
        selectionStyle = .none
        contentView.addSubview(itemsCountLabel)
        itemsCountLabel.fillSuperview(padding: .init(top: padding, left: padding, bottom: padding, right: padding))
    }
}
