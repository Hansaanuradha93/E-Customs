import UIKit

class RequestBoxVC: UIViewController {
    
    // MARK: Properties
    fileprivate let viewModel = RequestBoxVM()
    
    fileprivate let scrollView = UIScrollView()
    fileprivate let contentView = UIView()
    
    fileprivate let photoButton = ECButton(backgroundColor: UIColor.appColor(.lightGray), title: Strings.selectPhoto, titleColor: .gray, fontSize: 21)
    fileprivate let sneakerNameTextField = ECTextField(padding: 16, placeholderText: Strings.sneakerName)
    fileprivate let ideaDescriptionTextView = ECTextView(padding: 13, placeholderText: Strings.yourIdea)
    fileprivate let submitButton = ECButton(backgroundColor: UIColor.appColor(.lightGray), title: Strings.submit, titleColor: .gray, fontSize: 18)

    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [photoButton, sneakerNameTextField, ideaDescriptionTextView, submitButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 24
        return stackView
    }()

    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layoutUI()
        addTargets()
    }
}


// MARK: - Methods
extension RequestBoxVC {
    
    fileprivate func addTargets() {}
    
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        view.backgroundColor = .white
        title = Strings.requestBox
        tabBarItem.title = Strings.empty
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.fillSuperview()
        contentView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 800)
        ])
    }
    
    
    fileprivate func layoutUI() {
        ideaDescriptionTextView.delegate = self
        
        sneakerNameTextField.setRoundedBorder(borderColor: GlobalConstants.borderColor, borderWidth: GlobalConstants.borderWidth, radius: GlobalConstants.cornerRadius)
        ideaDescriptionTextView.setRoundedBorder(borderColor: GlobalConstants.borderColor, borderWidth: GlobalConstants.borderWidth, radius: GlobalConstants.cornerRadius)

        contentView.addSubview(verticalStackView)
        
        let paddingCorners: CGFloat = 24
        photoButton.setHeight(215)
        ideaDescriptionTextView.setHeight(150)
        submitButton.setHeight(GlobalConstants.height)
        verticalStackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 30, left: paddingCorners, bottom: 0, right: paddingCorners))
    }
}


// MARK: - UITextViewDelegate
extension RequestBoxVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Strings.yourIdea
            textView.textColor = UIColor.lightGray
        }
    }
}
