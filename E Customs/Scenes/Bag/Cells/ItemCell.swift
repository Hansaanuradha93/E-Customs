import UIKit

class ItemCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "ItemCell"
    
    fileprivate let thumbnailImageView = ECImageView(contentMode: .scaleAspectFill)
    fileprivate let nameLabel = ECSemiBoldLabel(textAlignment: .left, fontSize: 15, numberOfLines: 2)
    fileprivate let priceLabel = ECRegularLabel(textAlignment: .left, fontSize: 12)
    fileprivate let removeButton = ECButton(title: "Remove", titleColor: .darkGray, fontSize: 12)
    
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension ItemCell {
    
    func set(item: Item) {
        thumbnailImageView.downloadImage(from: item.thumbnailUrl ?? "")
        nameLabel.text = item.name ?? ""
        priceLabel.text = "$" + "\(item.price ?? "0.00")"
    }
    
    
    fileprivate func setupUI() {
        selectionStyle = .none
        
        let paddingTop: CGFloat = 24
        let dimensions: CGFloat = 96
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, priceLabel, removeButton])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
    
        addSubview(thumbnailImageView)
        addSubview(stackView)
        
        thumbnailImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: paddingTop, left: paddingTop, bottom: 0, right: 0), size: .init(width: dimensions, height: dimensions))
        
        stackView.anchor(top: topAnchor, leading: thumbnailImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: paddingTop, left: paddingTop / 2, bottom: paddingTop, right: paddingTop))
    }
}
