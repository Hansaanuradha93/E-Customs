import UIKit

class DescriptionCell: UITableViewCell {

    // MARK: Properties
    static let reuseID = "DescriptionCell"
        
    private let titleLabel = ECMediumLabel(text: Strings.designDescription, textAlignment: .left, fontSize: 17)
    private let decriptionLabel = ECRegularLabel(textAlignment: .left, textColor: .gray, fontSize: 15, numberOfLines: 0)

    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Public Methods
extension DescriptionCell {
    
    func set(description: String?) {
        decriptionLabel.text = description ?? ""
    }
}


// MARK: - Private Methods
private extension DescriptionCell {
    
    func layout() {
        selectionStyle = .none
        
        let padding: CGFloat = 24
                
        let stackView = UIStackView(arrangedSubviews: [titleLabel, decriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .leading
        
        contentView.addSubviews(stackView)
        
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: padding, left: padding, bottom: 0, right: padding))
    }
}
