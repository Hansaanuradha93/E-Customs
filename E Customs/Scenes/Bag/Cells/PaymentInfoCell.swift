import UIKit

class PaymentInfoCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "PaymentInfoCell"
    
    fileprivate let subTotalLabel = ECRegularLabel(text: Strings.subtotal, textAlignment: .left, textColor: .gray, fontSize: 15)
    fileprivate let subTotalValueLabel = ECRegularLabel(textAlignment: .left, textColor: .gray, fontSize: 15)
    
    fileprivate let shippingMethodLabel = ECRegularLabel(text: Strings.shipping, textAlignment: .left, textColor: .gray, fontSize: 15)
    fileprivate let shippingMethodValueLabel = ECRegularLabel(textAlignment: .left, textColor: .gray, fontSize: 15)
    
    fileprivate let processingFeesLabel = ECRegularLabel(text: Strings.processingFees, textAlignment: .left, textColor: .gray, fontSize: 15)
    fileprivate let processingFeesValueLabel = ECRegularLabel(textAlignment: .left, textColor: .gray, fontSize: 15)
    
    fileprivate let totalLabel = ECRegularLabel(text: Strings.total, textAlignment: .left, fontSize: 15)
    fileprivate let totalValueLabel = ECRegularLabel(textAlignment: .left, fontSize: 15)

    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension PaymentInfoCell {
    
    func set(subtotalPennies: Int, processingFeesPennies: Int, totalPennies: Int) {
        let subtotal = Double(subtotalPennies / 100)
        let processingFees = Double(processingFeesPennies / 100)
        let total = Double(totalPennies / 100)
        subTotalValueLabel.text = "$\(subtotal)"
        shippingMethodValueLabel.text = Strings.free
        processingFeesValueLabel.text = "$\(processingFees)"
        totalValueLabel.text = "$\(total)"
    }
    
    
    fileprivate func setupUI() {
        selectionStyle = .none
        let paddingTop: CGFloat = 24
        
        let subTotalStackView = UIStackView(arrangedSubviews: [subTotalLabel, subTotalValueLabel])
        subTotalStackView.alignment = .center
        subTotalStackView.distribution = .equalCentering
        
        let shippingMethodStackView = UIStackView(arrangedSubviews: [shippingMethodLabel, shippingMethodValueLabel])
        shippingMethodStackView.alignment = .center
        shippingMethodStackView.distribution = .equalCentering
        
        let taxStackView = UIStackView(arrangedSubviews: [processingFeesLabel, processingFeesValueLabel])
        taxStackView.alignment = .center
        taxStackView.distribution = .equalCentering
        
        let totalStackView = UIStackView(arrangedSubviews: [totalLabel, totalValueLabel])
        totalStackView.alignment = .center
        totalStackView.distribution = .equalCentering
        
        let overrallStackView = UIStackView(arrangedSubviews: [subTotalStackView, shippingMethodStackView, taxStackView])
        overrallStackView.axis = .vertical
        overrallStackView.spacing = 4
        overrallStackView.distribution = .fillEqually
        
        contentView.addSubviews(overrallStackView, totalStackView)
        
        overrallStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: paddingTop, left: paddingTop, bottom: 0, right: paddingTop))
        totalStackView.anchor(top: overrallStackView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: paddingTop, left: paddingTop, bottom: 0, right: paddingTop))
    }
}
