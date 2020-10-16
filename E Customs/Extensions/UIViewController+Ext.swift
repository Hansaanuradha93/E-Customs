import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String, buttonTitle: String, action: ((_ alertAction: UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: action)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
    func presentAlertAction(title: String, message: String, rightButtonTitle: String, leftButtonTitle: String, rightButtonAction: ((_ alertAction: UIAlertAction) -> Void)? = nil, leftButtonAction: ((_ alertAction: UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "Are you sure?", message: "Do you want to complete the order", preferredStyle: .alert)
        
        let rightAction = UIAlertAction(title: rightButtonTitle, style: .default, handler: rightButtonAction)
        let leftAction = UIAlertAction(title: leftButtonTitle, style: .cancel, handler: leftButtonAction)
        
        alertController.addAction(rightAction)
        alertController.addAction(leftAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func showPreloader() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.6
        backgroundView.tag = 475647
        backgroundView.layer.cornerRadius = 10
        view.addSubview(backgroundView)
        backgroundView.centerInSuperview(size: CGSize(width: 120, height: 90))
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        backgroundView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
        
        view.isUserInteractionEnabled = false
    }

    
    func hidePreloader() {
        if let background = view.viewWithTag(475647){
            background.removeFromSuperview()
        }
        view.isUserInteractionEnabled = true
    }
}
