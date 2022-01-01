import UIKit

class PaymentInfoCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "PaymentInfoCell"
    
    private let subTotalLabel = ECRegularLabel(text: Strings.subtotal, textAlignment: .left, textColor: .gray, fontSize: 15)
    private let subTotalValueLabel = ECRegularLabel(textAlignment: .left, textColor: .gray, fontSize: 15)
    
    private let shippingMethodLabel = ECRegularLabel(text: Strings.shipping, textAlignment: .left, textColor: .gray, fontSize: 15)
    private let shippingMethodValueLabel = ECRegularLabel(text: Strings.select + " ↓", textAlignment: .left, textColor: .gray, fontSize: 15)
    
    private let paymentMethodLabel = ECRegularLabel(text: Strings.paymentMethod, textAlignment: .left, textColor: .gray, fontSize: 15)
    private let paymentMethodValueLabel = ECRegularLabel(text: Strings.select + " ↓", textAlignment: .left, textColor: .gray, fontSize: 15)
    
    private let processingFeesLabel = ECRegularLabel(text: Strings.processingFees, textAlignment: .left, textColor: .gray, fontSize: 15)
    private let processingFeesValueLabel = ECRegularLabel(textAlignment: .left, textColor: .gray, fontSize: 15)
    
    private let totalLabel = ECRegularLabel(text: Strings.total, textAlignment: .left, fontSize: 17)
    private let totalValueLabel = ECRegularLabel(textAlignment: .left, fontSize: 17)
    
    var shippingMethodAction: (() -> Void)? = nil
    var paymentMethodAction: (() -> Void)? = nil

    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.style()
        self.layout()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Objc Methods
private extension PaymentInfoCell {
    
    @objc func handleShippingMethod() {
        shippingMethodAction?()
    }
    
    
    @objc func handlePaymentMethod() {
        paymentMethodAction?()
    }
}


// MARK: - Public Methods
extension PaymentInfoCell {
    
    func set(subtotalPennies: Int, processingFeesPennies: Int, totalPennies: Int, paymentMethod: String?, shippingMethod: String?) {
        let subtotal = Double(subtotalPennies) / 100
        let processingFees = Double(processingFeesPennies) / 100
        let total = Double(totalPennies) / 100
        subTotalValueLabel.text = "$\(subtotal)"
        processingFeesValueLabel.text = "$\(processingFees)"
        totalValueLabel.text = "$\(total)"
        
        shippingMethodValueLabel.text = shippingMethod ?? (Strings.select + " ↓")
        paymentMethodValueLabel.text = paymentMethod ?? (Strings.select + " ↓")
    }
}


// MARK: - Private Methods
private extension PaymentInfoCell {
    
    func style() {
        selectionStyle = .none
        
        shippingMethodValueLabel.isUserInteractionEnabled = true
        shippingMethodValueLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShippingMethod)))
        
        paymentMethodValueLabel.isUserInteractionEnabled = true
        paymentMethodValueLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePaymentMethod)))
    }
    
    
    func layout() {
        let paddingTop: CGFloat = 24
        
        let subTotalStackView = UIStackView(arrangedSubviews: [subTotalLabel, subTotalValueLabel])
        subTotalStackView.alignment = .center
        subTotalStackView.distribution = .equalCentering
        
        let shippingMethodStackView = UIStackView(arrangedSubviews: [shippingMethodLabel, shippingMethodValueLabel])
        shippingMethodStackView.alignment = .center
        shippingMethodStackView.distribution = .equalCentering
        
        let processingFeesStackView = UIStackView(arrangedSubviews: [processingFeesLabel, processingFeesValueLabel])
        processingFeesStackView.alignment = .center
        processingFeesStackView.distribution = .equalCentering
        
        let paymentMethodStackView = UIStackView(arrangedSubviews: [paymentMethodLabel, paymentMethodValueLabel])
        paymentMethodStackView.alignment = .center
        paymentMethodStackView.distribution = .equalCentering
        
        let totalStackView = UIStackView(arrangedSubviews: [totalLabel, totalValueLabel])
        totalStackView.alignment = .center
        totalStackView.distribution = .equalCentering
        
        let overrallStackView = UIStackView(arrangedSubviews: [subTotalStackView, processingFeesStackView, shippingMethodStackView, paymentMethodStackView])
        overrallStackView.axis = .vertical
        overrallStackView.spacing = 6
        overrallStackView.distribution = .fillEqually
        
        contentView.addSubviews(overrallStackView, totalStackView)
        
        overrallStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: paddingTop, left: paddingTop, bottom: 0, right: paddingTop))
        totalStackView.anchor(top: overrallStackView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: paddingTop, left: paddingTop, bottom: 0, right: paddingTop))
    }
}
