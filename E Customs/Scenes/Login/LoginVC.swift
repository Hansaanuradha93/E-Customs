import UIKit

class LoginVC: UIViewController {
    
    // MARK: Properties
    fileprivate let viewModel = LoginVM()
    
    fileprivate let emailTextField = ECTextField(padding: 16, placeholderText: Strings.email)
    fileprivate let passwordTextField = ECTextField(padding: 16, placeholderText: Strings.password)
    fileprivate let loginButton = ECButton(backgroundColor: UIColor.appColor(.lightGray), title: Strings.login, titleColor: .gray, fontSize: 18)
    fileprivate let gotoSignupButton = ECButton(backgroundColor: .white, title: Strings.gotoSignup, titleColor: .black, fontSize: 15)
    
    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
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
extension LoginVC {
    
    @objc fileprivate func handleLogin() {
        handleTapDismiss()
        viewModel.performLogin { [weak self] status, message in
            guard let self = self else { return }
            if status {
                self.navigateToHome()
            } else {
                self.presentAlert(title: Strings.failed, message: message, buttonTitle: Strings.ok)
            }
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
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = ECTabBar()
    }
    
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    fileprivate func setupViewModelObserver() {
        viewModel.bindalbeIsFormValid.bind { [weak self] isFormValid in
            guard let self = self, let isFormValid = isFormValid else { return }
            if isFormValid {
                self.loginButton.backgroundColor = .black
                self.loginButton.setTitleColor(.white, for: .normal)
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
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = Strings.login
        tabBarItem.title = Strings.empty
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        loginButton.isEnabled = false
        
        emailTextField.setRoundedBorder(borderColor: GlobalConstants.borderColor, borderWidth: GlobalConstants.borderWidth, radius: GlobalConstants.cornerRadius)
        passwordTextField.setRoundedBorder(borderColor: GlobalConstants.borderColor, borderWidth: GlobalConstants.borderWidth, radius: GlobalConstants.cornerRadius)
        loginButton.setRoundedBorder(borderColor: .black, borderWidth: 0, radius: 2)
        
        let paddingTop: CGFloat = 30
        let paddingCorners: CGFloat = 24
        view.addSubviews(verticalStackView, gotoSignupButton)
        loginButton.heightAnchor.constraint(equalToConstant: GlobalConstants.height).isActive = true
        verticalStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: paddingCorners, bottom: 0, right: paddingCorners))

        gotoSignupButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}
