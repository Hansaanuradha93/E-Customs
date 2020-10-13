import UIKit

class ItemCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "ItemCell"
    
    fileprivate let thumbnailImageView = ECImageView(contentMode: .scaleAspectFill)
    fileprivate let nameLabel = ECRegularLabel(textAlignment: .left, fontSize: 15, numberOfLines: 2)
    fileprivate let descriptionLabel = ECRegularLabel(textAlignment: .left, textColor: .gray, fontSize: 15)
    fileprivate let sizeLabel = ECRegularLabel(textAlignment: .left, textColor: .gray, fontSize: 15)
    fileprivate let priceLabel = ECMediumLabel(textAlignment: .left, fontSize: 15)
    fileprivate let quantityLabel = ECMediumLabel(textAlignment: .left, fontSize: 15)
    fileprivate let closeButton = ECButton(backgroundColor: .white)
    
    var removeAction: (() -> Void)? = nil
    var selectQuntity: (() -> Void)? = nil
    
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension ItemCell {
    
    @objc fileprivate func handleQuntity() {
        selectQuntity?()
    }
    
    
    @objc fileprivate func handleClose() {
        removeAction?()
    }
    
    
    func set(item: Item, itemType: ItemType = .bagItem) {
        thumbnailImageView.downloadImage(from: item.thumbnailUrl ?? "")
        nameLabel.text = item.name ?? ""
        descriptionLabel.text = item.description ?? ""
        sizeLabel.text = "\(Strings.size) \(item.selectedSize ?? Strings.notAvailable)"
        
        let quantity = item.quantity ?? 1
        let quantityString = "\(Strings.qty) \(quantity) ↓"
        let arrowString = "↓"

        let range = (quantityString as NSString).range(of: arrowString)
        let attributedString = NSMutableAttributedString(string:quantityString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: range)
        
        let price = (Double(item.price ?? "0") ?? 0) * Double(quantity)
        priceLabel.text = "$\(price)"
        
        if itemType == .orderItem {
            closeButton.alpha = 0
            quantityLabel.text = "\(Strings.qty) \(quantity)"
        } else if itemType ==  .bagItem {
            closeButton.alpha = 1
            quantityLabel.attributedText = attributedString
        }
    }
    
    
    fileprivate func setupUI() {
        selectionStyle = .none
        quantityLabel.isUserInteractionEnabled = true
        quantityLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleQuntity)))
        closeButton.alpha = 0
        
        let paddingTop: CGFloat = 24
        let dimensions: CGFloat = 102
        let closeButtonDimensions: CGFloat = 14
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, sizeLabel, priceLabel, quantityLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.set(image: Asserts.close, withTint: .gray)
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        
        contentView.addSubviews(thumbnailImageView, closeButton, stackView)
        
        thumbnailImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: paddingTop, left: paddingTop, bottom: 0, right: 0), size: .init(width: dimensions, height: dimensions))
        
        closeButton.anchor(top: thumbnailImageView.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: paddingTop / 2, bottom: 0, right: paddingTop), size: .init(width: closeButtonDimensions, height: closeButtonDimensions))
        stackView.anchor(top: thumbnailImageView.topAnchor, leading: thumbnailImageView.trailingAnchor, bottom: nil, trailing: closeButton.leadingAnchor, padding: .init(top: 0, left: paddingTop / 2, bottom: paddingTop, right: paddingTop))
    }
}
