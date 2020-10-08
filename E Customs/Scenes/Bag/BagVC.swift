import UIKit
import Firebase

class BagVC: UITableViewController {
    
    // MARK: Properties
    let viewModel = BagVM()
    let picker = UIPickerView()
    let toolBar = UIToolbar()
    
    fileprivate var listener: ListenerRegistration?
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createToolBar()
        setupTableView()
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
        if section == 0 || section == 2 || section == 3 {
            return 1
        } else if section == 1 {
            return viewModel.items.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NumberOfItemsCell.reuseID, for: indexPath) as! NumberOfItemsCell
            cell.set(count: viewModel.getNumberOfItems())
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseID, for: indexPath) as! ItemCell
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
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TotalLabel.reuseID, for: indexPath) as! TotalLabel
            cell.set(subtotal: viewModel.calculateSubtotal(), tax: viewModel.calculateTax(), total: viewModel.calculateTotal())
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.reuseID, for: indexPath) as! ButtonCell
            cell.set(buttonType: .checkout)
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
            return 160
        } else if indexPath.section == 3 {
            return 75
        }
        return 0
    }
}


// MARK: - Methods
extension BagVC {
    
    @objc fileprivate func handleDone() {
        updateQuantity()
        hidePickerWithAnimation()
    }
    
    
    @objc fileprivate func handleTap() {
        hidePickerWithAnimation()
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
            if status {
                self.viewModel.items.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadData()
            } else {
                self.presentAlert(title: Strings.failed, message: message, buttonTitle: Strings.ok)
            }
        }
    }
    
    
    fileprivate func fetchItems() {
        listener = viewModel.fetchItems { (status) in
            if status {
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
    }
    
    
    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(NumberOfItemsCell.self, forCellReuseIdentifier: NumberOfItemsCell.reuseID)
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.reuseID)
        tableView.register(TotalLabel.self, forCellReuseIdentifier: TotalLabel.reuseID)
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
