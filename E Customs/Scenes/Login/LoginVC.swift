import UIKit

class LoginVC: UIViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
    }
    
    
    @objc fileprivate func handleLogin() {
        handleTapDismiss()
        print("login")
    }
    
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        print("text changed")
//        viewModel.fullName = fullNameTextField.text
//        viewModel.email = emailTextField.text
//        viewModel.password = passwordTextField.text
    }
    
    
    @objc fileprivate func handleTapDismiss() {
        view.endEditing(true)
    }
    
    
    @objc fileprivate func handleGoToLogin() {
        self.navigationController?.popViewController(animated: true)
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
