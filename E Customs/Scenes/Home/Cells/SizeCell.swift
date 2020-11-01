import UIKit

class SizeCell: UICollectionViewCell {
    
    // MARK: Properties
    static let reuseID = "SizeCell"
    fileprivate let sizeLabel = ECRegularLabel(textColor: .gray, fontSize: 12)
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Public Methods
extension SizeCell {
    
    func setup(size: Double) {
        sizeLabel.text = "\(size)"
    }
    
    
    func setSelected(isSelected: Bool) {
        if isSelected {
            backgroundColor = .black
            sizeLabel.textColor = .white
        } else {
            backgroundColor = .white
            sizeLabel.textColor = .gray
        }
    }
}


// MARK: - Fileprivate Methods
fileprivate extension SizeCell {
    
    func setupUI() {
        self.setRoundedBorder(borderColor: GlobalConstants.borderColor, borderWidth: GlobalConstants.borderWidth, radius: GlobalConstants.cornerRadius)

        addSubview(sizeLabel)
        sizeLabel.fillSuperview()
    }
}
