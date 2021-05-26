import UIKit
import Stripe

class RequestDetailsVC: UIViewController {
    
    // MARK: Properties
    private let viewModel = RequestDetailsVM()
    
    var request: Request!
    private var paymentContext: STPPaymentContext!
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let thumbnailImageView = ECImageView(contentMode: .scaleAspectFill)
    private let sneakerNameLabel = ECMediumLabel(textAlignment: .left, fontSize: 17)
    private let ideaDescriptionLabel =  ECRegularLabel(textAlignment: .left, textColor: .lightGray, fontSize: 15, numberOfLines: 0)
    private let statusLabel = ECMediumLabel(textAlignment: .left, fontSize: 17)
    
    private let tableView = UITableView()

        
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
        setupStripeConfig()
        setupScrollView()
        setupUI()
        setData()
        setupViewModelObserver()
    }
}


// MARK: UITableView
extension RequestDetailsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentInfoCell.reuseID, for: indexPath) as! PaymentInfoCell
            cell.set(subtotalPennies: viewModel.subtotal, processingFeesPennies: viewModel.processingFees, totalPennies: viewModel.total, paymentMethod: viewModel.paymentMethod, shippingMethod: viewModel.shippingMethod)
            
            cell.shippingMethodAction = {
                self.paymentContext.pushShippingViewController()
            }
            
            cell.paymentMethodAction = {
                self.paymentContext.pushPaymentOptionsViewController()
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.reuseID, for: indexPath) as! ButtonCell
            cell.set(buttonType: .requestDetails)
            
            cell.buttonAction = {
                self.presentAlertAction(title: Strings.confirmPayment, message: Strings.paymentConfirmationMessage, rightButtonTitle: Strings.yes, leftButtonTitle: Strings.no, rightButtonAction:  { (_) in
                    self.paymentContext.requestPayment()
                    self.viewModel.bindableIsMakingPayment.value = true
                })
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 190
        case 1:
            return 75
        default:
            return 0
        }
    }
}


// MARK: - STPPaymentContextDelegate
extension RequestDetailsVC: STPPaymentContextDelegate {
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if let paymentMethod = paymentContext.selectedPaymentOption {
            viewModel.paymentMethod = paymentMethod.label
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        } else {
            viewModel.paymentMethod = nil
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
        
        if let shippingMethod = paymentContext.selectedShippingMethod {
            viewModel.shippingMethod = shippingMethod.label
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        } else {
            viewModel.shippingMethod = nil
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        // TODO: add this alert again
//        presentAlert(title: Strings.failed, message: Strings.somethingWentWrong, buttonTitle: Strings.ok) { (_) in
//            self.paymentContext.retryLoading()
//        }
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        makeCharge(paymentContext: paymentContext, paymentResult: paymentResult, completion: completion)
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        viewModel.bindableIsMakingPayment.value = false
        
        switch status {
        case .error:
            presentAlert(title: Strings.failed, message: error?.localizedDescription ?? "", buttonTitle: Strings.ok)
        case .success:
            self.saveOrderDetails()
            self.deleteRequest()
        case .userCancellation:
            return
        @unknown default:
            return
        }
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        setShippingAddress(address)
        
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "UPS Ground"
        upsGround.detail = "Arrives in 3-5 days"
        upsGround.identifier = "ups_ground"
        
        completion(.valid, nil, [upsGround], upsGround)
    }
}


// MARK: - Firebase Methods
private extension RequestDetailsVC {
    
    func deleteRequest() {
        viewModel.deleteRequest()
    }
    
    
    func saveOrderDetails() {
        viewModel.saveOrderDetails { [weak self] status, message in
            guard let self = self else { return }
            if status {
                self.presentAlert(title: Strings.successfull, message: Strings.orderPlacedSuccessfully, buttonTitle: Strings.ok) { [weak self] _ in
                    self?.removeTableView()
                    self?.goToOrderDetails()
                }
            } else {
                self.presentAlert(title: Strings.failed, message: message, buttonTitle: Strings.ok)
            }
        }
    }
}


// MARK: - Stripe Helper Methods
private extension RequestDetailsVC {
    
    func makeCharge(paymentContext: STPPaymentContext, paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let customerId = UserDefaults.standard.string(forKey: UserDefaultsKeys.stripeId) ?? ""
        let data: [String: Any] = [
            "total_amount": paymentContext.paymentAmount,
            "customer_id" : customerId,
            "payment_method_id" : paymentResult.paymentMethod?.stripeId ?? "",
            "idempotency" : idempotency
        ]
        
        viewModel.makeCharge(data: data) { status, error in
            if status {
                completion(.success, nil)
            } else {
                completion(.error, error)
            }
        }
    }
    
    
    func setShippingAddress(_ address: STPAddress) {
        let line1 = address.line1 ?? ""
        let city = address.city ?? ""
        let state = address.state ?? ""
        let country = address.country ?? ""
        viewModel.address = "\(line1), \(city), \(state), \(country)"
    }
    
    
    func setupStripeConfig() {
        let config = STPPaymentConfiguration.shared()
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = [.postalAddress]
        
        let theme = STPTheme()
        theme.primaryBackgroundColor = .white
        theme.secondaryBackgroundColor = .white
        theme.accentColor = .darkGray
        theme.primaryForegroundColor = .black
        theme.secondaryForegroundColor = .black
        theme.font = UIFont(name: Fonts.avenirNext, size: 17)
        theme.emphasisFont = UIFont(name: Fonts.avenirNext, size: 17)
        
        let customerContext = STPCustomerContext(keyProvider: StripeAPI.shared)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: theme)
        paymentContext.paymentAmount = viewModel.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
}


// MARK: - Private Methods
private extension RequestDetailsVC {
    
    func removeTableView(){
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    
    func goToOrderDetails() {
        let subtotal = viewModel.subTotalDollars
        let proccessingFees = viewModel.proccessingFeesDollars
        let total = viewModel.totalDollars

        let order = Order(orderId: viewModel.orderId, uid: viewModel.uid, type: OrderType.design.rawValue, status: viewModel.status, description: viewModel.request?.ideaDescription,paymentMethod: viewModel.paymentMethod, shippingMethod: viewModel.shippingMethod, address: viewModel.address, thumbnailUrl: viewModel.thumbnailUrl, subtotal: subtotal , proccessingFees: proccessingFees, total: total, itemCount: viewModel.itemCount, timestamp: viewModel.timestamp)
        
        let controller = OrderDetailsVC()
        controller.viewModel = OrderDetailsVM(order: order)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func setupViewModelObserver() {
        viewModel.bindableIsApproving.bind { [weak self] isSaving in
            guard let self = self, let isSaving = isSaving else { return }
            if isSaving {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
        
        viewModel.bindableIsMakingPayment.bind { [weak self] isMakingPayment in
            guard let self = self, let isMakingPayment = isMakingPayment else { return }
            if isMakingPayment {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    func setData() {
        thumbnailImageView.downloadImage(from: request.thumbnailUrl ?? "")
        sneakerNameLabel.text = (request.sneakerName ?? "").uppercased()
        ideaDescriptionLabel.text = request.ideaDescription ?? ""
        statusLabel.text = (request.isApproved ?? false) ? Strings.requestIsApproved : Strings.requestIsPending
        viewModel.subtotal = Int((request.price ?? 0) * 100)
        paymentContext.paymentAmount = viewModel.total
        viewModel.request = request
        tableView.reloadData()
    }
    
    
    func setupUI() {
        tableView.tag = 100
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PaymentInfoCell.self, forCellReuseIdentifier: PaymentInfoCell.reuseID)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.reuseID)
        
        contentView.addSubviews(thumbnailImageView, sneakerNameLabel, ideaDescriptionLabel, statusLabel)

        let paddingTop: CGFloat = 36
        let paddingCorners: CGFloat = 24
        let padding = UIEdgeInsets(top: paddingTop, left: paddingCorners, bottom: 0, right: paddingCorners)
        
        thumbnailImageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddingCorners, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 375))
        sneakerNameLabel.anchor(top: thumbnailImageView.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: padding)
        ideaDescriptionLabel.anchor(top: sneakerNameLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: padding)
        statusLabel.anchor(top: ideaDescriptionLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: padding)
        
        if request.isApproved ?? false {
            contentView.addSubview(tableView)
            tableView.anchor(top: statusLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddingCorners, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 300))
        }
    }
    
    
    func setupScrollView(){
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = Strings.requestDetail
        tabBarItem.title = Strings.empty
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.fillSuperview()
        contentView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor)
    
        var contentViewHeight: CGFloat = 0
        
        contentViewHeight =  (request.isApproved ?? false) ? 1100 : 800
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: contentViewHeight)
        ])
    }
}
