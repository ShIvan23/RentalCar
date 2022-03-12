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
    private let model: [Model]
    private let categoryPrice: CategoryPrice?
    private let isChooseLegal: Bool
    private let isChooseConditions: Bool
    
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
        return label
    }()
    
    init(
        collectionStyle: CollectionStyle,
        categoryPrice: CategoryPrice? = nil,
        model: [Model],
        isChooseLegal: Bool = false,
        isChooseConditions: Bool = false
    ) {
        self.collectionStyle = collectionStyle
        self.categoryPrice = categoryPrice
        self.model = model
        self.isChooseLegal = isChooseLegal
        self.isChooseConditions = isChooseConditions
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
                
                [searchView, searchImageView, searchLabel, collectionView].forEach { contentView.addSubview($0) }
                
                searchView.snp.makeConstraints { make in
                    make.top.equalTo(contentView.snp.top)
                    make.left.right.equalToSuperview().inset(8)
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
                
                addSearchGesture()
                
                collectionView.snp.makeConstraints { make in
                    make.top.equalTo(searchView.snp.bottom).offset(8)
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(contentView.snp.bottom)
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
    
    private func addSearchGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchTapGesture))
        searchView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func searchTapGesture() {
        let popoverTableView = PopoverTableViewController(model: ["BMW", "Lada", "Opel", "Skoda"])
        popoverTableView.modalPresentationStyle = .popover
        popoverTableView.popoverPresentationController?.delegate = self
        popoverTableView.popoverPresentationController?.sourceView = searchView
        popoverTableView.popoverPresentationController?.sourceRect = CGRect(x: searchView.bounds.midX, y: searchView.bounds.maxY, width: 0, height: 0)
        popoverTableView.preferredContentSize = CGSize(width: ScreenSize.width, height: CGFloat(4 * 40))
        popoverTableView.delegate = self
        present(popoverTableView, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension BaseCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionStyle {
            /// Ячейка для отображения всех машин
        case .listStyle:
            guard let model = model as? [CarModel] else { fatalError() }
            let cell: BaseCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.setupCell(
                model: model[indexPath.item],
                categoryPrice: categoryPrice!
            )
            return cell
            
            /// Ячейка для отображения категорий юр лица и категорий машин
        case .categoryStyle:
            guard let model = model as? [CarClass] else { fatalError() }
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
            guard let model = model as? [CarModel] else { fatalError() }
            /// Экран с детальной информацией
            let currentCar = model[indexPath.item]
            // TODO: - убрать force unwrap 
            let detailViewController = DetailCarViewController(carModel: currentCar, categoryPrice: categoryPrice!)
            detailViewController.title = currentCar.marka + " " + currentCar.model
            navigationController?.pushViewController(detailViewController, animated: true)

            
        case .categoryStyle:
            /// При выборе категории должна быть такая модель
            guard let model = model as? [CarClass] else { fatalError() }
            
            /// Если выбирается вид юр лица, то нужно показать категории машин
            if isChooseLegal {
                let collectionViewController = BaseCollectionViewController(
                    collectionStyle: .categoryStyle,
                    categoryPrice: indexPath.item == 0 ? .commercialPriceWithNDS : .commercialPriceWithoutNDS,
                    model: CarClass.makeMockModel()
                )
                collectionViewController.title = model[indexPath.item].className
                navigationController?.pushViewController(collectionViewController, animated: true)
                /// Если вид юр лица выбран, то показывает категории машин
            } else {
                let cars = model[indexPath.item].carList
                let collectionViewController = BaseCollectionViewController(
                    collectionStyle: .listStyle,
                    categoryPrice: categoryPrice,
                    model: cars
                )
                collectionViewController.title = model[indexPath.item].className
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
        print("Открыть все машины марки = \(text)")
    }
}
