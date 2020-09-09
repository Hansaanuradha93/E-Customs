import UIKit

class SignupVC: UIViewController {
    
    // MARK: Properties
    fileprivate let viewModel = SignupVM()

    fileprivate let fullNameTextField = ECTextField(padding: 16, placeholderText: "Enter full name")
    fileprivate let emailTextField = ECTextField(padding: 16, placeholderText: "Enter email")
    fileprivate let passwordTextField = ECTextField(padding: 16, placeholderText: "Enter password")
    fileprivate let signupButton = ECButton(backgroundColor: UIColor.appColor(.lightGray), title: "Sign Up", titleColor: .gray, fontSize: 21)
    fileprivate let goToLoginButton = ECButton(backgroundColor: .white, title: "Go to login", titleColor: .black, fontSize: 18)
    
    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordTextField, signupButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 18
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
        viewModel.performSignUp { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlert(title: "Signup Failed!", message: error.localizedDescription, buttonTitle: "OK")
                return
            }
            self.navigateToHome()
        }
    }
    
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        viewModel.fullName = fullNameTextField.text
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
        print("navigate to Home")
    }
    
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    fileprivate func setupViewModelObserver() {
        viewModel.bindalbeIsFormValid.bind { [weak self] isFormValid in
            guard let self = self, let isFormValid = isFormValid else { return }
            if isFormValid {
                self.signupButton.backgroundColor = .white
                self.signupButton.setTitleColor(.black, for: .normal)
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
        fullNameTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        signupButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        goToLoginButton.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
    }
    
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Sign Up"
        
        fullNameTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        signupButton.isEnabled = false
        
        fullNameTextField.setRoundedBorder(borderColor: .black, borderWidth: 1, radius: 2)
        emailTextField.setRoundedBorder(borderColor: .black, borderWidth: 1, radius: 2)
        passwordTextField.setRoundedBorder(borderColor: .black, borderWidth: 1, radius: 2)
        signupButton.setRoundedBorder(borderColor: .black, borderWidth: 1, radius: 2)
        
        view.addSubview(verticalStackView)
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        verticalStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 20, bottom: 0, right: 20))
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}
