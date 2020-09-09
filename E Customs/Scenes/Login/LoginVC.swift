import UIKit

class LoginVC: UIViewController {
    
    // MARK: Properties
    fileprivate let viewModel = LoginVM()
    
    fileprivate let emailTextField = ECTextField(padding: 16, placeholderText: "Enter email")
    fileprivate let passwordTextField = ECTextField(padding: 16, placeholderText: "Enter password")
    fileprivate let loginButton = ECButton(backgroundColor: UIColor.appColor(.lightGray), title: "Log In", titleColor: .gray, fontSize: 21)
    fileprivate let gotoSignupButton = ECButton(backgroundColor: .white, title: "Go to sign up", titleColor: .black, fontSize: 18)
    
    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
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
extension LoginVC {
    
    @objc fileprivate func handleLogin() {
        handleTapDismiss()
        viewModel.performLogin { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlert(title: "Login Failed!", message: error.localizedDescription, buttonTitle: "OK")
                return
            }
            self.navigateToHome()
        }
    }
    
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
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
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - Methods
extension LoginVC {
    
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
                self.loginButton.backgroundColor = .white
                self.loginButton.setTitleColor(.black, for: .normal)
            } else {
                self.loginButton.backgroundColor = UIColor.appColor(.lightGray)
                self.loginButton.setTitleColor(.gray, for: .disabled)
            }
            self.loginButton.isEnabled = isFormValid
        }
        
        viewModel.bindableIsLogin.bind { [weak self] isLogin in
            guard let self = self, let isLogin = isLogin else { return }
            if isLogin {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    fileprivate func addTargets() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        emailTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        gotoSignupButton.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
    }
    
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Log In"
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        loginButton.isEnabled = false
        
        emailTextField.setRoundedBorder(borderColor: .black, borderWidth: 1, radius: 2)
        passwordTextField.setRoundedBorder(borderColor: .black, borderWidth: 1, radius: 2)
        loginButton.setRoundedBorder(borderColor: .black, borderWidth: 1, radius: 2)
        
        view.addSubview(verticalStackView)
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        verticalStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 20, bottom: 0, right: 20))
        
        view.addSubview(gotoSignupButton)
        gotoSignupButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}
