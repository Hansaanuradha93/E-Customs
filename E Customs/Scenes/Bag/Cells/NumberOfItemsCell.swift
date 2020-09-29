import UIKit

class NumberOfItemsCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseID = "NumberOfItemsCell"
    fileprivate let itemsCountLabel = ECRegularLabel(textAlignment: .left, fontSize: 15)
    
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension NumberOfItemsCell {
    
    func set(count: Int) {
        if count > 1 {
            itemsCountLabel.text = "\(count) Items"
        } else if count == 1 {
            itemsCountLabel.text = "\(count) Item"
        } else {
            itemsCountLabel.text = "No items yet"
        }
    }
    
    
    fileprivate func setupUI() {
        let padding: CGFloat = 24
        selectionStyle = .none
        addSubview(itemsCountLabel)
        itemsCountLabel.fillSuperview(padding: .init(top: padding, left: padding, bottom: padding, right: padding))
    }
}
