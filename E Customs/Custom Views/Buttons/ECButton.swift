import UIKit

class ECButton: UIButton {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) { fatalError() }

    
    convenience init(backgroundColor: UIColor = .white, title: String = "", titleColor: UIColor = .black, radius: CGFloat = 0, fontSize: CGFloat = 32) {
        self.init(frame: .zero)
        self.setup(backgroundColor: backgroundColor, title: title, titleColor: titleColor, radius: radius, fontSize: fontSize)
    }
}


// MARK: - Methods
extension ECButton {
    
    func set(image: UIImage, withTint color: UIColor) {
        self.setImage(image, for: .normal)
        self.imageView?.image = self.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
    
    fileprivate func setup(backgroundColor: UIColor, title: String, titleColor: UIColor, radius: CGFloat, fontSize: CGFloat) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = radius
        let traits = [UIFontDescriptor.TraitKey.weight: UIFont.Weight.medium]
        var descriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: Fonts.avenirNext])
        descriptor = descriptor.addingAttributes([UIFontDescriptor.AttributeName.traits: traits])
        
        self.titleLabel?.font = UIFont(descriptor: descriptor, size: fontSize)
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.imageView?.contentMode = .scaleAspectFill
    }
}
