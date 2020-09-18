import UIKit

class ECLabel: UILabel {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) { fatalError() }

    
    convenience init(text: String = "", textAlignment: NSTextAlignment = .center, textColor: UIColor = .black, font: UIFont = UIFont.systemFont(ofSize: 16), fontSize: CGFloat = 16, numberOfLines: Int = 1) {
        self.init(frame: .zero)
        self.text = text
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.font = font
        self.numberOfLines = numberOfLines
    }
}
