import UIKit

class RequestBoxVC: UIViewController {
    
    // MARK: Properties
    private let viewModel = RequestBoxVM()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let photoButton = ECButton(backgroundColor: UIColor.appColor(.lightGray), title: Strings.selectPhoto, titleColor: .gray, fontSize: 21)
    private let sneakerNameTextField = ECTextField(padding: 16, placeholderText: Strings.sneakerName)
    private let ideaDescriptionTextView = ECTextView(padding: 13, placeholderText: Strings.yourIdea)
    private let submitButton = ECButton(backgroundColor: UIColor.appColor(.lightGray), title: Strings.submit, titleColor: .gray, fontSize: 18)

    private lazy var verticalStackView: UIStackView = {
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
        setupViewModelObserver()
    }
}


// MARK: - Objc Methods
private extension RequestBoxVC {
    
    @objc func handleSubmit() {
        submitRequestInfo()
    }
    
    
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    
    @objc func handleTextChange(textField: UITextField) {
        viewModel.sneakerName = sneakerNameTextField.text
    }
    
    
    @objc func handleTapDismiss() {
        view.endEditing(true)
    }
}


// MARK: - Private Methods
private extension RequestBoxVC {
    
    func submitRequestInfo() {
        handleTapDismiss()
        viewModel.submitRequest { [weak self] status, message in
            guard let self = self else { return }
            if status {
                self.presentAlert(title: Strings.successfull, message: message, buttonTitle: Strings.ok) { (_) in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.presentAlert(title: Strings.failed, message: message, buttonTitle: Strings.ok)
            }
        }
    }
    
    
    func setupViewModelObserver() {
        viewModel.bindalbeIsFormValid.bind { [weak self] isFormValid in
            guard let self = self, let isFormValid = isFormValid else { return }
            if isFormValid {
                self.submitButton.backgroundColor = .black
                self.submitButton.setTitleColor(.white, for: .normal)
            } else {
                self.submitButton.backgroundColor = UIColor.appColor(.lightGray)
                self.submitButton.setTitleColor(.gray, for: .disabled)
            }
            self.submitButton.isEnabled = isFormValid
        }
        
        viewModel.bindableImage.bind { [weak self] image in
            guard let self = self else { return }
            let buttonImage = image?.withRenderingMode(.alwaysOriginal)
            self.photoButton.setImage(buttonImage, for: .normal)
        }
        
        viewModel.bindableIsSaving.bind { [weak self] isSaving in
            guard let self = self, let isSaving = isSaving else { return }
            if isSaving {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    func addTargets() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        photoButton.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        sneakerNameTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    }
    
    
    func setupUI() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    
    func layoutUI() {
        submitButton.isEnabled = false
        ideaDescriptionTextView.delegate = self
        
        sneakerNameTextField.setRoundedBorder(borderColor: GlobalConstants.borderColor, borderWidth: GlobalConstants.borderWidth, radius: GlobalConstants.cornerRadius)
        ideaDescriptionTextView.setRoundedBorder(borderColor: GlobalConstants.borderColor, borderWidth: GlobalConstants.borderWidth, radius: GlobalConstants.cornerRadius)
        submitButton.setRoundedBorder(borderColor: GlobalConstants.borderColor, borderWidth: 0, radius: GlobalConstants.cornerRadius)

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
    
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            viewModel.ideaDescription = text
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 600
    }
}


// MARK: - UIImagePickerControllerDelegate && UINavigationControllerDelegate
extension RequestBoxVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: ImagePickerKeys.EditedImage.key)] as? UIImage {
            viewModel.bindableImage.value = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: ImagePickerKeys.OriginalImage.key)] as? UIImage {
            viewModel.bindableImage.value = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
}
