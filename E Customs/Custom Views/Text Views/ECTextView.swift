import UIKit

class ECTextView: UITextView {
    
    // MARK: Initializers
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    
    convenience init(background: UIColor = .white, padding: CGFloat, placeholderText: String = "", textColor: UIColor = .lightGray, fontSize: CGFloat = 18, radius: CGFloat = 0) {
        self.init()
        configureTextView(background, placeholderText, textColor, fontSize, padding)
    }
}


// MARK: - Methods
extension ECTextView {
    
    fileprivate func configureTextView(_ background: UIColor, _ placeholderText: String, _ textColor: UIColor, _ fontSize: CGFloat, _ padding: CGFloat) {
        let traits = [UIFontDescriptor.TraitKey.weight: UIFont.Weight.regular]
        var descriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: Fonts.avenirNext])
        descriptor = descriptor.addingAttributes([UIFontDescriptor.AttributeName.traits: traits])
        
        self.backgroundColor = background
        self.text = placeholderText
        self.textColor = textColor
        self.font = UIFont(descriptor: descriptor, size: fontSize)
        self.textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}
