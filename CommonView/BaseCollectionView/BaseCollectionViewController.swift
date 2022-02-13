//
//  BaseCollectionViewController.swift
//  RentalCar
//
//  Created by Ivan on 27.01.2022.
//

import UIKit

class BaseCollectionViewController: UIViewController {
    
    enum CollectionStyle {
        case listStyle
        case categoryStyle
    }
    
    private let collectionStyle: CollectionStyle
    private let model: [Model]
    private let categoryPrice: CategoryPrice?
    private let isChooseLegal: Bool
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: BaseCollectionViewCell.self)
        collectionView.register(cell: LegalCollectionViewCell.self)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    init(
        collectionStyle: CollectionStyle,
        categoryPrice: CategoryPrice? = nil,
        model: [Model],
        isChooseLegal: Bool = false
    ) {
        self.collectionStyle = collectionStyle
        self.categoryPrice = categoryPrice
        self.model = model
        self.isChooseLegal = isChooseLegal
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
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
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
        let width = (collectionView.bounds.width - sideInset * 3) / 2
        return CGSize(width: width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionStyle {
            
        case .categoryStyle:
            switch model.count {
                /// Если всего 2 ячейки, то это выбор юр лица и ячейки будут посередине экрана
                // TODO: - протестить на разных экранах
            case 2:
                let middleHeightScreen = (ScreenSize.height - cellHeight) / 3
                return UIEdgeInsets(top: middleHeightScreen, left: sideInset, bottom: sideInset, right: sideInset)
            default :
                return UIEdgeInsets(top: sideInset, left: sideInset, bottom: sideInset, right: sideInset)
            }

        case .listStyle:
            return UIEdgeInsets(top: sideInset, left: sideInset, bottom: sideInset, right: sideInset)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionStyle {
        case .listStyle:
            guard let model = model as? [CarModel] else { fatalError() }
            /// Экран с детальной информацией
            let currentCar = model[indexPath.item]
            let detailViewController = DetailCarViewController(carModel: currentCar)
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
        }
    }
}
