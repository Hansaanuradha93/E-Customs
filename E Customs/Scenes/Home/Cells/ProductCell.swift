import UIKit

class ProductCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseID = "ProductCell"
    
    fileprivate let thumbnailImageView = ECImageView(image: Asserts.placeHolder)
    fileprivate let titleLabel = ECLabel(textAlignment: .left, font: UIFont.systemFont(ofSize: 20, weight: .bold))
    fileprivate let priceLabel = ECLabel(textAlignment: .left, font: UIFont.systemFont(ofSize: 16, weight: .medium))

    
    // MARK: Initilizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension ProductCell {
    
    func set(product: Product) {
        titleLabel.text = product.name ?? ""
        priceLabel.text = "$\(product.price ?? "")"
        thumbnailImageView.downloadImage(from: product.thumbnailUrl ?? "")
    }
    
    
    func setupUI() {
        selectionStyle = .none
        addSubviews(thumbnailImageView, titleLabel, priceLabel)
        
        thumbnailImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 330))
        titleLabel.anchor(top: thumbnailImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8))
        priceLabel.anchor(top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: nil, trailing: titleLabel.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 0, right: 0))
    }
}
