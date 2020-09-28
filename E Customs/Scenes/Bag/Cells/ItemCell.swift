import UIKit

class ItemCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "ItemCell"
    
    fileprivate let thumbnailImageView = ECImageView(contentMode: .scaleAspectFill)
    fileprivate let nameLabel = ECSemiBoldLabel(textAlignment: .left, fontSize: 15, numberOfLines: 2)
    fileprivate let descriptionLabel = ECRegularLabel(textAlignment: .left, textColor: .darkGray, fontSize: 15)
    fileprivate let sizeLabel = ECRegularLabel(textAlignment: .left, textColor: .darkGray, fontSize: 15)
    fileprivate let priceLabel = ECMediumLabel(textAlignment: .left, fontSize: 15)
    fileprivate let quantityLabel = ECMediumLabel(textAlignment: .left, fontSize: 15)
    
    
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
        descriptionLabel.text = item.description ?? ""
        sizeLabel.text = "Size \(item.selectedSize ?? "Not availabel")"
        
        let quantity = item.quantity ?? 1
        let quantityString = "Qty \(quantity) ↓"
        let arrowString = "↓"

        let range = (quantityString as NSString).range(of: arrowString)
        let attributedString = NSMutableAttributedString(string:quantityString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: range)
        quantityLabel.attributedText = attributedString
        
        let price = (Double(item.price ?? "0") ?? 0) * Double(quantity)
        priceLabel.text = "$" + "\(price)"
    }
    
    
    fileprivate func setupUI() {
        selectionStyle = .none
        
        let paddingTop: CGFloat = 24
        let dimensions: CGFloat = 102
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, sizeLabel, priceLabel, quantityLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        
        addSubviews(thumbnailImageView, stackView)
        
        thumbnailImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: paddingTop, left: paddingTop, bottom: 0, right: 0), size: .init(width: dimensions, height: dimensions))
        stackView.anchor(top: thumbnailImageView.topAnchor, leading: thumbnailImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: paddingTop / 2, bottom: paddingTop, right: paddingTop))
    }
}
