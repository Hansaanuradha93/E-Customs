import UIKit

class ECSemiBoldLabel: UILabel {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) { fatalError() }

    
    convenience init(text: String = "", textAlignment: NSTextAlignment = .center, textColor: UIColor = .black, fontSize: CGFloat = 16, numberOfLines: Int = 1) {
        self.init(frame: .zero)
        self.init(frame: .zero)
        let traits = [UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold]
        var descriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: Fonts.avenirNext])
        descriptor = descriptor.addingAttributes([UIFontDescriptor.AttributeName.traits: traits])

        self.text = text
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.font = UIFont(descriptor: descriptor, size: fontSize)
        self.numberOfLines = numberOfLines
    }
}
