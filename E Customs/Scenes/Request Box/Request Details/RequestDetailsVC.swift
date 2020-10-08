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
    
    
    fileprivate func setData() {
        thumbnailImageView.downloadImage(from: request.thumbnailUrl ?? "")
        sneakerNameLabel.text = (request.sneakerName ?? "").uppercased()
        ideaDescriptionLabel.text = request.ideaDescription ?? ""
        statusLabel.text = (request.isApproved ?? false) ? "REQUEST IS APPROVED" : "REQUEST IS STILL PENDING"
    }
    
    
    fileprivate func setupUI() {
        contentView.addSubviews(thumbnailImageView, sneakerNameLabel, ideaDescriptionLabel, statusLabel)

        let paddingTop: CGFloat = 36
        let paddindCorders: CGFloat = 24
        
        thumbnailImageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, size: .init(width: 0, height: 375))
        sneakerNameLabel.anchor(top: thumbnailImageView.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddingTop, left: paddindCorders, bottom: 0, right: paddindCorders))
        ideaDescriptionLabel.anchor(top: sneakerNameLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddingTop, left: paddindCorders, bottom: 0, right: paddindCorders))
        statusLabel.anchor(top: ideaDescriptionLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddingTop, left: paddindCorders, bottom: 0, right: paddindCorders))
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
