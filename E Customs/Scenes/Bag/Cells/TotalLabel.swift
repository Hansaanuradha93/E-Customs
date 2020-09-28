import UIKit

class TotalLabel: UITableViewCell {

    // MARK: Properties
    static let reuseID = "TotalLabel"
    
    fileprivate let subTotalLabel = ECSemiBoldLabel(textAlignment: .left, fontSize: 15)
    fileprivate let subTotalValueLabel = ECRegularLabel(textAlignment: .left, fontSize: 15)
    
    fileprivate let shippingMethodLabel = ECSemiBoldLabel(textAlignment: .left, fontSize: 15)
    fileprivate let shippingMethodValueLabel = ECRegularLabel(textAlignment: .left, fontSize: 15)
    
    fileprivate let taxLabel = ECSemiBoldLabel(textAlignment: .left, fontSize: 15)
    fileprivate let taxValueLabel = ECRegularLabel(textAlignment: .left, fontSize: 15)
    
    fileprivate let totalLabel = ECSemiBoldLabel(textAlignment: .left, fontSize: 15)
    fileprivate let totalValueLabel = ECRegularLabel(textAlignment: .left, fontSize: 15)

    
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension TotalLabel {
    
    func set(subtotal: Double, tax: Double, total: Double) {
        subTotalValueLabel.text = "$\(subtotal)"
        shippingMethodValueLabel.text = "free".uppercased()
        taxValueLabel.text = "$\(tax)"
        totalValueLabel.text = "$\(total)"
    }
    
    
    fileprivate func setupUI() {
        selectionStyle = .none
        let paddingTop: CGFloat = 24
        
        subTotalLabel.text = "subtotal".uppercased()
        shippingMethodLabel.text = "Estimated shipping & handling".uppercased()
        taxLabel.text = "tax".uppercased()
        totalLabel.text = "total".uppercased()
        
        let subTotalStackView = UIStackView(arrangedSubviews: [subTotalLabel, subTotalValueLabel])
        subTotalStackView.alignment = .center
        subTotalStackView.distribution = .equalCentering
        
        let shippingMethodStackView = UIStackView(arrangedSubviews: [shippingMethodLabel, shippingMethodValueLabel])
        shippingMethodStackView.alignment = .center
        shippingMethodStackView.distribution = .equalCentering
        
        let taxStackView = UIStackView(arrangedSubviews: [taxLabel, taxValueLabel])
        taxStackView.alignment = .center
        taxStackView.distribution = .equalCentering
        
        let totalStackView = UIStackView(arrangedSubviews: [totalLabel, totalValueLabel])
        totalStackView.alignment = .center
        totalStackView.distribution = .equalCentering
        
        let overrallStackView = UIStackView(arrangedSubviews: [subTotalStackView, shippingMethodStackView, taxStackView])
        overrallStackView.axis = .vertical
        overrallStackView.spacing = 2
        overrallStackView.distribution = .fillEqually
        
        addSubview(overrallStackView)
        addSubview(totalStackView)
        
        overrallStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: paddingTop, left: paddingTop, bottom: 0, right: paddingTop))
        totalStackView.anchor(top: overrallStackView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: paddingTop, left: paddingTop, bottom: 0, right: paddingTop))
    }
}
