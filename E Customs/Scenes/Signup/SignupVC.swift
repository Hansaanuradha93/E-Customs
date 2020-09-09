import UIKit

class SignupVC: UIViewController {

    fileprivate let fullNameTextField = ECTextField(padding: 16, placeholderText: "Enter full name")
    fileprivate let emailTextField = ECTextField(padding: 16, placeholderText: "Enter email")
    fileprivate let passwordTextField = ECTextField(padding: 16, placeholderText: "Enter password")
    fileprivate let signupButton = ECButton(backgroundColor: .white, title: "Sign Up", titleColor: .black, fontSize: 21)
    
    
    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordTextField, signupButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 18
        return stackView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        
        fullNameTextField.setRoundedBorder(borderColor: .black, borderWidth: 1, radius: 2)
        emailTextField.setRoundedBorder(borderColor: .black, borderWidth: 1, radius: 2)
        passwordTextField.setRoundedBorder(borderColor: .black, borderWidth: 1, radius: 2)
        signupButton.setRoundedBorder(borderColor: .black, borderWidth: 1, radius: 2)
        
        
        view.addSubview(verticalStackView)
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        verticalStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 20, bottom: 0, right: 20))
    }
}
