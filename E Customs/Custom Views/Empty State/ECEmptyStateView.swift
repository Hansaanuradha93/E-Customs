import UIKit

class ECEmptyStateView: UIView {

    // MARK: Properties
    private let messageLabel = ECMediumLabel(textColor: .lightGray, fontSize: 25)
    private let logoImageView = ECImageView(contentMode: .scaleAspectFill)
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    convenience init(emptyStateType: EmptyStateType) {
        self.init(frame: .zero)
        configureState(emptyStateType)
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension ECEmptyStateView {
    
    fileprivate func configureState(_ emptyStateType: EmptyStateType) {
        var image = Asserts.placeHolder
        var message = ""
        
        switch emptyStateType {
        case .home:
            image = Asserts.emptyShoe
            message = Strings.noShoesYet
        case .requestBox:
            image = Asserts.emptyEnvelope
            message = Strings.noRequestsYet
        case .shoppinBag:
            image = Asserts.emptyCart
            message = Strings.noItemsYet
        case .order:
            image = Asserts.emptyDocument
            message = Strings.noOrdersYet
        }
        
        logoImageView.image = image
        logoImageView.image = logoImageView.image?.withRenderingMode(.alwaysTemplate)
        logoImageView.tintColor = .lightGray
        messageLabel.text = message
    }
    
    
    fileprivate func setupUI() {
        let padding: CGFloat = 24
        let dimension: CGFloat = 100
        
        addSubviews(logoImageView, messageLabel)
        logoImageView.centerInSuperview(size: .init(width: dimension, height: dimension))
        messageLabel.anchor(top: logoImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: padding / 2, left: padding, bottom: 0, right: padding))
    }
}
