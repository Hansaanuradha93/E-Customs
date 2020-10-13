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


// MARK: - Methods
extension NumberOfItemsCell {
    
    func set(count: Int) {
        if count > 1 {
            itemsCountLabel.text = "\(count) ITEMS"
        } else if count == 1 {
            itemsCountLabel.text = "\(count) ITEM"
        } else {
            itemsCountLabel.text = Strings.noItemsYet
        }
    }
    
    
    fileprivate func setupUI() {
        let padding: CGFloat = 24
        selectionStyle = .none
        contentView.addSubview(itemsCountLabel)
        itemsCountLabel.fillSuperview(padding: .init(top: padding, left: padding, bottom: padding, right: padding))
    }
}
