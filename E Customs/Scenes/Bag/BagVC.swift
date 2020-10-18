import UIKit
import Firebase
import Stripe

class BagVC: UITableViewController {
    
    // MARK: Properties
    let viewModel = BagVM()
    let picker = UIPickerView()
    let toolBar = UIToolbar()
    
    fileprivate var listener: ListenerRegistration?
    fileprivate var paymentContext: STPPaymentContext!
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStripeConfig()
        setupUI()
        createToolBar()
        setupTableView()
        setupViewModelObserver()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchItems()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent { listener?.remove() }
    }
}


// MARK: - TableView
extension BagVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return viewModel.items.count
        } else if section == 0 || section == 2 || section == 3 {
            return viewModel.items.count > 0 ? 1 : 0
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NumberOfItemsCell.reuseID, for: indexPath) as! NumberOfItemsCell
            cell.set(count: viewModel.numberOfItems)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseID, for: indexPath) as! ItemCell
            if viewModel.items.count > 0 {
                let item = viewModel.items[indexPath.row]
                cell.set(item: item)
                
                cell.removeAction =  {
                    self.deleteItem(at: indexPath)
                    self.hidePickerWithAnimation()
                }
                
                cell.selectQuntity = {
                    self.viewModel.selectedItem = item
                    self.showPickerWithAnimation()
                }
            }
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentInfoCell.reuseID, for: indexPath) as! PaymentInfoCell
            cell.set(subtotalPennies: viewModel.subtotal, processingFeesPennies: viewModel.processingFees, totalPennies: viewModel.total, paymentMethod: viewModel.paymentMethod, shippingMethod: viewModel.shippingMethod)
            
            cell.shippingMethodAction = {
                self.paymentContext.pushShippingViewController()
            }
            
            cell.paymentMethodAction = {
                self.paymentContext.pushPaymentOptionsViewController()
            }
            
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.reuseID, for: indexPath) as! ButtonCell
            cell.set(buttonType: .placeOrder)
            cell.buttonAction = {
                self.presentAlertAction(title: Strings.confirmPayment, message: Strings.paymentConfirmationMessage, rightButtonTitle: Strings.yes, leftButtonTitle: Strings.no, rightButtonAction:  { (_) in
                    self.paymentContext.requestPayment()
                    self.viewModel.bindableIsMakingPayment.value = true
                })
            }
            return cell
        }
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        } else if indexPath.section == 1 {
            return 170
        } else if indexPath.section == 2 {
            return 190
        } else if indexPath.section == 3 {
            return 75
        }
        return 0
    }
}


// MARK: - STPPaymentContextDelegate
extension BagVC: STPPaymentContextDelegate {
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if let paymentMethod = paymentContext.selectedPaymentOption {
            viewModel.paymentMethod = paymentMethod.label
            tableView.reloadSections(IndexSet(integer: 2), with: .none)
        } else {
            viewModel.paymentMethod = nil
            tableView.reloadSections(IndexSet(integer: 2), with: .none)
        }
        
        if let shippingMethod = paymentContext.selectedShippingMethod {
            viewModel.shippingMethod = shippingMethod.label
            tableView.reloadSections(IndexSet(integer: 2), with: .none)
        } else {
            viewModel.shippingMethod = nil
            tableView.reloadSections(IndexSet(integer: 2), with: .none)
        }
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        presentAlert(title: Strings.failed, message: Strings.somethingWentWrong, buttonTitle: Strings.ok) { (_) in
            self.paymentContext.retryLoading()
        }
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {        makeCharge(paymentContext: paymentContext, paymentResult: paymentResult, completion: completion)
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        viewModel.bindableIsMakingPayment.value = false
        
        switch status {
        case .error:
            presentAlert(title: Strings.failed, message: error?.localizedDescription ?? "", buttonTitle: Strings.ok)
        case .success:
            self.saveOrderDetails()
            self.deleteAllBagItems()
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


// MARK: - Objc Method
extension BagVC {
    
    @objc fileprivate func handleDone() {
        updateQuantity()
        hidePickerWithAnimation()
    }
    
    
    @objc fileprivate func handleTap() {
        hidePickerWithAnimation()
    }
}


// MARK: - Firebase Methods
extension BagVC {
    
    fileprivate func deleteAllBagItems() {
        viewModel.deleteAllBagItems()
    }
    
    
    fileprivate func makeCharge(paymentContext: STPPaymentContext, paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
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
    
    
    fileprivate func saveOrderDetails() {
        viewModel.saveOrderDetails { [weak self] status, message in
            guard let self = self else { return }
            if status {
                self.presentAlert(title: Strings.successfull, message: Strings.orderPlacedSuccessfully, buttonTitle: Strings.ok) { [weak self] _ in
                    self?.updateUI()
                    self?.goToOrderDetails()
                }
            } else {
                self.presentAlert(title: Strings.failed, message: message, buttonTitle: Strings.ok)
            }
        }
    }
    
    
    fileprivate func updateQuantity() {
        viewModel.updateQuanitity { [weak self] status, message in
            guard let self = self else { return }
            if status {
                self.fetchItems()
            } else {
                self.presentAlert(title: Strings.failed, message: message, buttonTitle: Strings.ok)
            }
        }
    }
    
    
    fileprivate func deleteItem(at indexPath: IndexPath) {
        let item = viewModel.items[indexPath.row]
        
        viewModel.delete(item) { [weak self] status, message in
            guard let self = self else { return }
            if !status {
                self.presentAlert(title: Strings.failed, message: message, buttonTitle: Strings.ok)
            }
        }
    }
    
    fileprivate func fetchItems() {
        listener = viewModel.fetchItems { (status) in
            if status {
                self.paymentContext.paymentAmount = self.viewModel.total
                self.updateUIWithItems()
            }
        }
    }
}


// MARK: - Methods
extension BagVC {
    
    fileprivate func updateUIWithItems() {
        if self.viewModel.items.isEmpty {
            DispatchQueue.main.async { self.tableView.backgroundView = ECEmptyStateView(emptyStateType: .shoppinBag) }
        } else {
            DispatchQueue.main.async { self.tableView.backgroundView = nil }
        }
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    
    fileprivate func updateUI() {
        DispatchQueue.main.async {
            self.viewModel.items.removeAll()
            self.tableView.reloadData()
        }
    }
    
    
    fileprivate func goToOrderDetails() {
        let subtotal = viewModel.subTotalDollars
        let proccessingFees = viewModel.proccessingFeesDollars
        let total = viewModel.totalDollars

        let order = Order(orderId: viewModel.orderId, uid: viewModel.uid, type: OrderType.item.rawValue, status: viewModel.status, description: nil, paymentMethod: viewModel.paymentMethod, shippingMethod: viewModel.shippingMethod, address: viewModel.address, thumbnailUrl: viewModel.thumbnailUrl, subtotal: subtotal , proccessingFees: proccessingFees, total: total, itemCount: viewModel.itemCount, timestamp: viewModel.timestamp)
        
        let controller = OrderDetailsVC()
        controller.viewModel = OrderDetailsVM(order: order)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    fileprivate func setShippingAddress(_ address: STPAddress) {
        let line1 = address.line1 ?? ""
        let city = address.city ?? ""
        let state = address.state ?? ""
        let country = address.country ?? ""
        viewModel.address = "\(line1), \(city), \(state), \(country)"
    }
    
    
    fileprivate func setupViewModelObserver() {
        viewModel.bindableIsMakingPayment.bind { [weak self] isMakingPayment in
            guard let self = self, let isMakingPayment = isMakingPayment else { return }
            if isMakingPayment {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    fileprivate func setupStripeConfig() {
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
    
    
    fileprivate func createToolBar() {
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: Strings.done, style: .plain, target: self, action: #selector(handleDone))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.barTintColor = .white
        toolBar.tintColor = .black
        toolBar.alpha = 0
        view.addSubview(toolBar)
        
        toolBar.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: picker.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
    
    
    fileprivate func showPickerWithAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.picker.alpha = 1
            self.toolBar.alpha = 1
        }
    }
    
    
    fileprivate func hidePickerWithAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.picker.alpha = 0
            self.toolBar.alpha = 0
        }
    }
    
    
    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(NumberOfItemsCell.self, forCellReuseIdentifier: NumberOfItemsCell.reuseID)
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.reuseID)
        tableView.register(PaymentInfoCell.self, forCellReuseIdentifier: PaymentInfoCell.reuseID)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.reuseID)
    }
    
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = Strings.shoppingBag
        tabBarItem.title = Strings.empty
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        picker.alpha = 0
        picker.backgroundColor = .white
        view.addSubview(picker)
        picker.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        picker.dataSource = self
        picker.delegate = self
    }
}


// MARK: - UIPickerViewDataSource && UIPickerViewDelegate
extension BagVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedQuantity = row + 1
    }
}
