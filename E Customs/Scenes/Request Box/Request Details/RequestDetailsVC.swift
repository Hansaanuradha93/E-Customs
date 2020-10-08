import UIKit

class RequestDetailsVC: UIViewController {
    
    // MARK: Properties
    fileprivate let viewModel = RequestDetailsVM()
    var request: Request!
    
    fileprivate let scrollView = UIScrollView()
    fileprivate let contentView = UIView()
    
    fileprivate let thumbnailImageView = ECImageView(contentMode: .scaleAspectFill)
    fileprivate let sneakerNameLabel = ECMediumLabel(textAlignment: .left, fontSize: 17)
    fileprivate let ideaDescriptionLabel =  ECRegularLabel(textAlignment: .left, textColor: .lightGray, fontSize: 15, numberOfLines: 0)
    fileprivate let statusLabel = ECMediumLabel(textAlignment: .left, fontSize: 17)
    
    fileprivate let approveButton = ECButton(backgroundColor: UIColor.appColor(.lightGray), title: Strings.approve, titleColor: .gray, radius: GlobalConstants.cornerRadius, fontSize: 16)
    
    
    // MARK: Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    convenience init(request: Request) {
        self.init()
        self.request = request
    }
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupUI()
        setData()
        setupViewModelObserver()
    }
}


// MARK: - Methods
extension RequestDetailsVC {
    
    @objc fileprivate func handleApprove() {
//        approveRequest()
    }
    
    
    fileprivate func setupViewModelObserver() {
        viewModel.bindableIsApproving.bind { [weak self] isSaving in
            guard let self = self, let isSaving = isSaving else { return }
            if isSaving {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
//    fileprivate func approveRequest() {
//        viewModel.updateStatus(request: request) { [weak self] status, message in
//            guard let self = self else { return }
//            if status {
//                self.presentAlert(title: Strings.successfull, message: message, buttonTitle: Strings.ok)
//                self.updateUI()
//            } else {
//                self.presentAlert(title: Strings.failed, message: message, buttonTitle: Strings.ok)
//            }
//        }
//    }
    
    
    fileprivate func updateUI() {
        approveButton.backgroundColor = UIColor.appColor(.lightGray)
        approveButton.setTitleColor(.gray, for: .normal)
        approveButton.isEnabled = false
        statusLabel.text = "REQUEST IS APPROVED"
    }
    
    
    fileprivate func setData() {
        thumbnailImageView.downloadImage(from: request.thumbnailUrl ?? "")
        sneakerNameLabel.text = (request.sneakerName ?? "").uppercased()
        ideaDescriptionLabel.text = request.ideaDescription ?? ""
        
        if request.isApproved ?? false {
            approveButton.backgroundColor = UIColor.appColor(.lightGray)
            approveButton.setTitleColor(.gray, for: .normal)
            approveButton.isEnabled = false
            statusLabel.text = "REQUEST IS APPROVED"
        } else {
            approveButton.backgroundColor = .black
            approveButton.setTitleColor(.white, for: .normal)
            approveButton.isEnabled = true
            statusLabel.text = "REQUEST IS STILL PENDING"
        }
    }
    
    
    fileprivate func setupUI() {
        approveButton.addTarget(self, action: #selector(handleApprove), for: .touchUpInside)
        contentView.addSubviews(thumbnailImageView, sneakerNameLabel, ideaDescriptionLabel, statusLabel, approveButton)

        let paddingTop: CGFloat = 36
        let paddindCorders: CGFloat = 24
        
        thumbnailImageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, size: .init(width: 0, height: 375))
        sneakerNameLabel.anchor(top: thumbnailImageView.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddingTop, left: paddindCorders, bottom: 0, right: paddindCorders))
        ideaDescriptionLabel.anchor(top: sneakerNameLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddingTop, left: paddindCorders, bottom: 0, right: paddindCorders))
        statusLabel.anchor(top: ideaDescriptionLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddingTop, left: paddindCorders, bottom: 0, right: paddindCorders))
        approveButton.anchor(top: statusLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddingTop, left: paddindCorders, bottom: 0, right: paddindCorders), size: .init(width: 0, height: GlobalConstants.height))
    }
    
    
    fileprivate func setupScrollView(){
        view.backgroundColor = .white
        title = Strings.detail
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
}
