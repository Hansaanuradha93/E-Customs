import UIKit

class SignupVC: UIViewController {
    
    // MARK: Properties
    fileprivate let viewModel = SignupVM()

    fileprivate let firstNameTextField = ECTextField(padding: 16, placeholderText: Strings.firstName)
    fileprivate let lastNameTextField = ECTextField(padding: 16, placeholderText: Strings.lastName)
    fileprivate let emailTextField = ECTextField(padding: 16, placeholderText: Strings.email)
    fileprivate let passwordTextField = ECTextField(padding: 16, placeholderText: Strings.password)
    fileprivate let maleButton = ECButton(title: Strings.male, titleColor: .gray, fontSize: 17)
    fileprivate let femaleButton = ECButton(title: Strings.female, titleColor: .gray, fontSize: 17)
    fileprivate let signupButton = ECButton(backgroundColor: UIColor.appColor(.lightGray), title: Strings.signup, titleColor: .gray, fontSize: 18)
    fileprivate let goToLoginButton = ECButton(backgroundColor: .white, title: Strings.gotoLogin, titleColor: .black, fontSize: 15)
    
    fileprivate lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [maleButton, femaleButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        return stackView
    }()
    
    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, firstNameTextField, lastNameTextField,  horizontalStackView,signupButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        return stackView
    }()

    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
        setupNotifications()
        setupViewModelObserver()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - Objc Methods
extension SignupVC {
    
    @objc fileprivate func handleSignUp() {
        handleTapDismiss()
        viewModel.performSignUp { [weak self] status, message in
            guard let self = self else { return }
            if status {
                self.navigateToHome()
            } else {
                self.presentAlert(title: Strings.failed, message: message, buttonTitle: Strings.ok)
            }
        }
    }
    
    
    @objc fileprivate func handleMaleButtonClick() {
        viewModel.isMale = true
    }
    
    
    @objc fileprivate func handleFemaleButtonClick() {
        viewModel.isMale = false
    }
    
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        viewModel.firstName = firstNameTextField.text
        viewModel.lastName = lastNameTextField.text
        viewModel.email = emailTextField.text
        viewModel.password = passwordTextField.text
    }
    
    
    @objc fileprivate func handleTapDismiss() {
        view.endEditing(true)
    }
    
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.verticalStackView.transform = .identity
        })
    }
    
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        self.verticalStackView.transform = CGAffineTransform(translationX: 0, y: -10)
    }
    
    
    @objc fileprivate func handleGoToLogin() {
        let controller = LoginVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - Methods
extension SignupVC {
    
    fileprivate func navigateToHome() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = ECTabBar()
    }
    
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    fileprivate func setupViewModelObserver() {
        viewModel.bindableIsMaleSelected.bind { [weak self] isMale in
            guard let self = self, let isMale = isMale else { return }
            if isMale {
                self.maleButton.backgroundColor = .black
                self.maleButton.setTitleColor(.white, for: .normal)
                self.maleButton.setRoundedBorder(borderColor: .black, borderWidth: GlobalDimensions.borderWidth, radius: GlobalDimensions.cornerRadius)
                
                self.femaleButton.backgroundColor = .white
                self.femaleButton.setTitleColor(.gray, for: .normal)
                self.femaleButton.setRoundedBorder(borderColor: .gray, borderWidth: GlobalDimensions.borderWidth, radius: GlobalDimensions.cornerRadius)
            } else {
                self.femaleButton.backgroundColor = .black
                self.femaleButton.setTitleColor(.white, for: .normal)
                self.femaleButton.setRoundedBorder(borderColor: .black, borderWidth: GlobalDimensions.borderWidth, radius: GlobalDimensions.cornerRadius)
                
                self.maleButton.backgroundColor = .white
                self.maleButton.setTitleColor(.gray, for: .normal)
                self.maleButton.setRoundedBorder(borderColor: .gray, borderWidth: GlobalDimensions.borderWidth, radius: GlobalDimensions.cornerRadius)
            }
        }
        
        viewModel.bindalbeIsFormValid.bind { [weak self] isFormValid in
            guard let self = self, let isFormValid = isFormValid else { return }
            if isFormValid {
                self.signupButton.backgroundColor = .black
                self.signupButton.setTitleColor(.white, for: .normal)
            } else {
                self.signupButton.backgroundColor = UIColor.appColor(.lightGray)
                self.signupButton.setTitleColor(.gray, for: .disabled)
            }
            self.signupButton.isEnabled = isFormValid
        }
        
        viewModel.bindableIsRegistering.bind { [weak self] isRegistering in
            guard let self = self, let isRegistering = isRegistering else { return }
            if isRegistering {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    fileprivate func addTargets() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        firstNameTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        signupButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        maleButton.addTarget(self, action: #selector(handleMaleButtonClick), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(handleFemaleButtonClick), for: .touchUpInside)
        goToLoginButton.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
    }
    
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Strings.signup
        
        firstNameTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        signupButton.isEnabled = false
        
        firstNameTextField.setRoundedBorder(borderColor: GlobalDimensions.borderColor, borderWidth: GlobalDimensions.borderWidth, radius: GlobalDimensions.cornerRadius)
        lastNameTextField.setRoundedBorder(borderColor: GlobalDimensions.borderColor, borderWidth: GlobalDimensions.borderWidth, radius: GlobalDimensions.cornerRadius)
        emailTextField.setRoundedBorder(borderColor: GlobalDimensions.borderColor, borderWidth: GlobalDimensions.borderWidth, radius: GlobalDimensions.cornerRadius)
        passwordTextField.setRoundedBorder(borderColor: GlobalDimensions.borderColor, borderWidth: GlobalDimensions.borderWidth, radius: GlobalDimensions.cornerRadius)
        signupButton.setRoundedBorder(borderColor: GlobalDimensions.borderColor, borderWidth: 0, radius: GlobalDimensions.cornerRadius)
        maleButton.setRoundedBorder(borderColor: GlobalDimensions.borderColor, borderWidth: GlobalDimensions.borderWidth, radius: GlobalDimensions.cornerRadius)
        femaleButton.setRoundedBorder(borderColor: GlobalDimensions.borderColor, borderWidth: GlobalDimensions.borderWidth, radius: GlobalDimensions.cornerRadius)

        view.addSubview(verticalStackView)
        signupButton.heightAnchor.constraint(equalToConstant: GlobalDimensions.height).isActive = true
        maleButton.heightAnchor.constraint(equalToConstant: GlobalDimensions.height).isActive = true
        femaleButton.heightAnchor.constraint(equalToConstant: GlobalDimensions.height).isActive = true
        verticalStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 20, bottom: 0, right: 20))
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}
