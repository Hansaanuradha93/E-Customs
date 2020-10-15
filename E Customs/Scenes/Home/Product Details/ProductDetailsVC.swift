import UIKit

class ProductDetailsVC: UIViewController {

    // MARK: Properties
    fileprivate var viewModel: ProductDetialsVM!
    
    fileprivate let scrollView = UIScrollView()
    fileprivate let contentView = UIView()
    
    fileprivate let thumbnailImageView = ECImageView(contentMode: .scaleAspectFill)
    fileprivate let titleLabel = ECMediumLabel(textAlignment: .left, fontSize: 17)
    fileprivate let descriptionLabel = ECRegularLabel(textAlignment: .left, textColor: .lightGray, fontSize: 15, numberOfLines: 0)
    fileprivate let sizeLabel = ECMediumLabel(textAlignment: .left, fontSize: 17)
    fileprivate let priceLabel = ECMediumLabel(textAlignment: .left, fontSize: 17)
    fileprivate let addToBagButton = ECButton(backgroundColor: UIColor.appColor(.lightGray), title: Strings.addToBag, titleColor: .gray, radius: GlobalConstants.cornerRadius, fontSize: 16)
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()

    var selectedItem = -1

    
    // MARK: Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    convenience init(viewModel: ProductDetialsVM) {
        self.init()
        self.viewModel = viewModel
    }
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        layoutUI()
        setupCollectionView()
        setData()
        setupViewModelObserver()
    }
}


// MARK: - UICollectionView
extension ProductDetailsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sizes.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: SizeCell.reuseID, for: indexPath) as! SizeCell
        let size = Double(viewModel.sizes[indexPath.item]) ?? 0
        cell.setup(size: size)
        
        if selectedItem == indexPath.item {
            cell.setSelected(isSelected: true)
        } else {
            cell.setSelected(isSelected: false)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedItem == indexPath.item {
            selectedItem = -1
            viewModel.selectedSize = "0"
        } else {
            selectedItem = indexPath.item
            viewModel.selectedSize = viewModel.sizes[selectedItem]
        }
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize {
        return CGSize(width: 65, height: 55)
    }
}


// MARK: - Objc Methods
extension ProductDetailsVC {
    
    @objc fileprivate func handleAddToBag() {
        addToBag()
    }
}


// MARK: - Methods
extension ProductDetailsVC {
    
    fileprivate func addToBag() {
        viewModel.addToBag { [weak self] status, message in
            guard let self = self else { return }
            if status {
                self.presentAlert(title: Strings.successfull, message: message, buttonTitle: Strings.ok)
            } else {
                self.presentAlert(title: Strings.failed, message: message, buttonTitle: Strings.ok)
            }
        }
    }
    
    
    fileprivate func setupViewModelObserver() {
        viewModel.bindableIsSizesAvailable.bind { [weak self] isSizesAvailable in
            guard let self = self, let isSizesAvailable = isSizesAvailable else { return }
            if isSizesAvailable {
                DispatchQueue.main.async { self.collectionView.reloadData() }
            }
        }
        
        viewModel.bindalbeIsProductIsReady.bind { [weak self] isReady in
            guard let self = self, let isReady = isReady else { return }
            if isReady {
                self.addToBagButton.backgroundColor = .black
                self.addToBagButton.setTitleColor(.white, for: .normal)
                self.addToBagButton.isEnabled = true
            } else {
                self.addToBagButton.backgroundColor = UIColor.appColor(.lightGray)
                self.addToBagButton.setTitleColor(.gray, for: .normal)
                self.addToBagButton.isEnabled = false
            }
        }
        
        viewModel.bindableIsSaving.bind { [weak self] isSaving in
            guard let self = self, let isSaving = isSaving else { return }
            if isSaving {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    fileprivate func setData() {
        thumbnailImageView.downloadImage(from: viewModel.product.thumbnailUrl ?? "")
        titleLabel.text = (viewModel.product.name ?? "").uppercased()
        descriptionLabel.text = viewModel.product.description ?? ""
        priceLabel.text = "\(viewModel.product.price ?? "")$"
        let sizes = (viewModel.product.sizes ?? "").replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        viewModel.sizes = sizes.components(separatedBy: ",")
    }
    
    
    fileprivate func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SizeCell.self, forCellWithReuseIdentifier: SizeCell.reuseID)
    }
    
    
    fileprivate func setupScrollView() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = Strings.detail
        tabBarItem.title = Strings.empty
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.fillSuperview()
        contentView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1000)
        ])
    }
    
    
    fileprivate func layoutUI() {
        sizeLabel.text = Strings.size.uppercased()
        addToBagButton.isEnabled = false
        addToBagButton.addTarget(self, action: #selector(handleAddToBag), for: .touchUpInside)
        
        contentView.addSubviews(thumbnailImageView, titleLabel, descriptionLabel, priceLabel, sizeLabel, collectionView, addToBagButton)
    
        let paddingTop: CGFloat = 36
        let paddindCorners: CGFloat = 24
        
        thumbnailImageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddindCorners, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 375))
        titleLabel.anchor(top: thumbnailImageView.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddingTop, left: paddindCorners, bottom: 0, right: paddindCorners))
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddingTop, left: paddindCorners, bottom: 0, right: paddindCorners))
        priceLabel.anchor(top: descriptionLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddingTop, left: paddindCorners, bottom: 0, right: paddindCorners))
        sizeLabel.anchor(top: priceLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddingTop, left: paddindCorners, bottom: 0, right: paddindCorners))
        collectionView.anchor(top: sizeLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddingTop, left: paddindCorners, bottom: 0, right: paddindCorners), size: .init(width: 0, height: 60))
        addToBagButton.anchor(top: collectionView.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: paddingTop, left: paddindCorners, bottom: 0, right: paddindCorners), size: .init(width: 0, height: GlobalConstants.height))
    }
}
