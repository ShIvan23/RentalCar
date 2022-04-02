//
//  BaseCollectionViewController.swift
//  RentalCar
//
//  Created by Ivan on 27.01.2022.
//

import SnapKit
import UIKit

class BaseCollectionViewController: UIViewController {
    
    enum CollectionStyle {
        case listStyle
        case categoryStyle
        case stockStyle
        case rentalCondition
    }
    
    private let collectionStyle: CollectionStyle
    /// Модель для показа
    var model: [Model]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.makeCarBrands()
            }
        }
    }
    /// Модель после выбора категории
    var modelForPresenting: [Model]?
    
    /// Список марок машин для поиска
    private var carBrands = [String]()
    
    private let categoryPrice: CategoryPrice?
    private let isChooseLegal: Bool
    private let isChooseConditions: Bool
    private let isChooseStock: Bool
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: BaseCollectionViewCell.self)
        collectionView.register(cell: LegalCollectionViewCell.self)
        collectionView.register(cell: StockCollectionViewCell.self)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(hexString: "#000000", alpha: 0.65).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.text = "Найти машину"
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var clearSearchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .systemGray2
        button.addTarget(self, action: #selector(clearSearchAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Войти", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var callUsButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Позвонить нам", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(callUsButtonAction), for: .touchUpInside)
        return button
    }()
    
    init(
        collectionStyle: CollectionStyle,
        categoryPrice: CategoryPrice? = nil,
        isChooseLegal: Bool = false,
        isChooseConditions: Bool = false,
        isChooseStock: Bool = false
    ) {
        self.collectionStyle = collectionStyle
        self.categoryPrice = categoryPrice
        self.isChooseLegal = isChooseLegal
        self.isChooseConditions = isChooseConditions
        self.isChooseStock = isChooseStock
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeView()
        setLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        switch collectionStyle {
        case .categoryStyle:
            if !isChooseLegal {
                loginButton.setCustomGradient()
                callUsButton.setCustomGradient()
            }
        default:
            break
        }
    }
    
    private func customizeView() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        switch collectionStyle {
        case .categoryStyle:
            if !isChooseLegal {
                view.addSubview(scrollView)
                
                scrollView.snp.makeConstraints { make in
                    make.top.left.bottom.right.equalToSuperview()
                }
                
                scrollView.addSubview(contentView)
                
                contentView.snp.makeConstraints { make in
                    make.top.bottom.equalTo(scrollView)
                    make.left.right.equalTo(view)
                    make.width.equalTo(scrollView)
                    make.height.equalTo(scrollView)
                }
                
                [searchView, searchImageView, searchLabel, clearSearchButton, loginButton, collectionView, callUsButton].forEach { contentView.addSubview($0) }
                
                searchView.snp.makeConstraints { make in
                    make.top.equalTo(contentView.snp.top)
                    make.left.equalToSuperview().inset(8)
                    make.height.equalTo(34)
                }
                
                searchImageView.snp.makeConstraints { make in
                    make.left.equalTo(searchView.snp.left).offset(10)
                    make.height.width.equalTo(16)
                    make.centerY.equalTo(searchView.snp.centerY)
                }
                
                searchLabel.snp.makeConstraints { make in
                    make.left.equalTo(searchImageView.snp.right).offset(6)
                    make.centerY.equalTo(searchView.snp.centerY)
                }
                
                clearSearchButton.snp.makeConstraints { make in
                    make.centerY.equalTo(searchView.snp.centerY)
                    make.right.equalTo(searchView.snp.right).inset(10)
                }
                
                addSearchGesture()
                
                loginButton.snp.makeConstraints { make in
                    make.left.equalTo(searchView.snp.right).offset(8)
                    make.right.equalToSuperview().inset(8)
                    make.height.equalTo(searchView.snp.height)
                    make.width.equalTo(100)
                }
                
                collectionView.snp.makeConstraints { make in
                    make.top.equalTo(searchView.snp.bottom).offset(8)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(cellHeight * 2 + sideInset * 3)
                }
                
                callUsButton.snp.makeConstraints { make in
                    make.top.equalTo(collectionView.snp.bottom).offset(20)
                    make.left.right.equalToSuperview().inset(16)
                    make.height.equalTo(40)
                }
                
                
            } else {
                /// На экране с выбором типа лица не нужен поиск. поэтому идем в дефолтный кейс
                fallthrough
            }
            
        default:
            view.addSubview(collectionView)
            
            collectionView.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(view.snp.bottomMargin)
            }
        }
    }
    
    private func makeCarBrands() {
        guard let model = model as? [CarClass2] else { return }
        var setCars = Set<String>()
        model.forEach { carClass in
            carClass.auto?.forEach { car in
                setCars.insert(car.brand ?? "")
            }
        }
        carBrands = Array(setCars)
    }
    
    private func addSearchGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchTapGesture))
        searchView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func searchTapGesture() {
        let popoverTableView = PopoverTableViewController(model: carBrands)
        popoverTableView.modalPresentationStyle = .popover
        popoverTableView.popoverPresentationController?.delegate = self
        popoverTableView.popoverPresentationController?.sourceView = searchView
        popoverTableView.popoverPresentationController?.sourceRect = CGRect(x: searchView.bounds.midX, y: searchView.bounds.maxY, width: 0, height: 0)
        popoverTableView.preferredContentSize = CGSize(width: ScreenSize.width, height: CGFloat(carBrands.count * 40))
        popoverTableView.delegate = self
        present(popoverTableView, animated: true)
    }
    
    @objc private func loginButtonAction() {
        print("Войти")
    }
    
    @objc private func callUsButtonAction() {
        print("Позвонить")
    }
    
    @objc private func clearSearchAction() {
        searchLabel.text = "Найти машину"
        UIView.animate(withDuration: 0.1) {
            self.clearSearchButton.alpha = 0.4
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.clearSearchButton.alpha = 1.0
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension BaseCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionStyle {
            /// Ячейка для отображения всех машин
        case .listStyle:
            guard let model = model as? [CarModel2] else { fatalError() }
            let cell: BaseCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.setupCell(
                model: model[indexPath.item],
                categoryPrice: categoryPrice!
            )
            return cell
            
            /// Ячейка для отображения категорий юр лица, видов акций и категорий машин
        case .categoryStyle:
            // если выбор акции
            if isChooseStock {
                guard let model = model as? [InformationModel] else { fatalError() }
                let cell: LegalCollectionViewCell = collectionView.dequeueCell(for: indexPath)
                cell.setupCell(model: model[indexPath.item])
                return cell
            }
            
            guard let model = model as? [CarClass2] else { fatalError() }
            let cell: LegalCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.setupCell(model: model[indexPath.item])
            return cell
          
            /// Ячейка для отображения условий проката
        case .rentalCondition:
            guard let model = model as? [InformationModel] else { fatalError() }
            let cell: LegalCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.setupCell(model: model[indexPath.item])
            return cell
            
            /// Ячейка для отображения акций
        case .stockStyle:
            guard let model = model as? [InformationModel] else { fatalError() }
            let cell: StockCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.setupCell(stockModel: model[indexPath.item])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BaseCollectionViewController: UICollectionViewDelegateFlowLayout {
    private var sideInset: CGFloat { return 8 }
    private var cellHeight: CGFloat { return 260 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sideInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sideInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionStyle {
        case .stockStyle:
            let width = collectionView.bounds.width - sideInset * 2
            let height: CGFloat = 200
            return CGSize(width: width, height: height)
        default:
            let width = (collectionView.bounds.width - sideInset * 3) / 2
            return CGSize(width: width, height: cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionStyle {
            
        case .categoryStyle, .rentalCondition:
            guard let model = model else { return .zero}
            switch model.count {
                /// Если всего 2 ячейки, то это выбор юр лица и ячейки будут посередине экрана
                // TODO: - протестить на разных экранах
            case 2:
                let middleHeightScreen = (ScreenSize.height - cellHeight) / 3
                return UIEdgeInsets(top: middleHeightScreen, left: sideInset, bottom: sideInset, right: sideInset)
            default :
                return UIEdgeInsets(top: sideInset, left: sideInset, bottom: sideInset, right: sideInset)
            }

        default:
            return UIEdgeInsets(top: sideInset, left: sideInset, bottom: sideInset, right: sideInset)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionStyle {
        case .listStyle:
            guard let model = model as? [CarModel2] else { fatalError() }
            /// Экран с детальной информацией
            let currentCar = model[indexPath.item]
            // TODO: - убрать force unwrap 
            let detailViewController = DetailCarViewController(carModel: currentCar, categoryPrice: categoryPrice!)
            detailViewController.title = currentCar.name
            navigationController?.pushViewController(detailViewController, animated: true)

            
        case .categoryStyle:
            /// При выборе акции
            if isChooseStock {
                guard let model = model as? [InformationModel] else { fatalError() }
                let collectionViewController = BaseCollectionViewController(collectionStyle: .stockStyle)
                collectionViewController.model = InformationModel.makeMockStocks()
                collectionViewController.title = model[indexPath.item].name
                navigationController?.pushViewController(collectionViewController, animated: true)
                return
            }
            
            /// При выборе категории должна быть такая модель
            guard let model = model as? [CarClass2] else { fatalError() }
            
            /// Если выбирается вид юр лица, то нужно показать категории машин
            if isChooseLegal {
                let collectionViewController = BaseCollectionViewController(
                    collectionStyle: .categoryStyle,
                    categoryPrice: indexPath.item == 0 ? .commercialPriceWithNDS : .commercialPriceWithoutNDS
//                    model: CarClass.makeMockModel()
                )
                collectionViewController.model = modelForPresenting
                collectionViewController.title = model[indexPath.item].name
                navigationController?.pushViewController(collectionViewController, animated: true)
                /// Если вид юр лица выбран, то показывает категории машин
            } else {
                let cars = model[indexPath.item].auto
                let collectionViewController = BaseCollectionViewController(
                    collectionStyle: .listStyle,
                    categoryPrice: categoryPrice
//                    model: cars
                )
                collectionViewController.model = cars
                collectionViewController.title = model[indexPath.item].name
                navigationController?.pushViewController(collectionViewController, animated: true)
            }
            
        case .stockStyle:
            print("Открыть детальный экран с акцией?")
            
            /// Если выбирается условие проката, то показывает детальный экран с условиями
        case .rentalCondition:
            print("Показать экран с условиями")
        }
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension BaseCollectionViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - PopoverTableViewControllerDelegate

extension BaseCollectionViewController: PopoverTableViewControllerDelegate {
    func selectedValue(text: String) {
        searchLabel.text = text
        print("Открыть все машины марки = \(text)")
    }
}
