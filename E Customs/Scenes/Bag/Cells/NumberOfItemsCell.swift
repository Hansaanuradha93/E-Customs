import UIKit

class NumberOfItemsCell: UITableViewCell {
    
    static let reuseID = "NumberOfItemsCell"

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    fileprivate func setupUI() {
        
    }
    
}
