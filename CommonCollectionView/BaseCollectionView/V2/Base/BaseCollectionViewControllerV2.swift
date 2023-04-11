//
//  BaseCollectionViewControllerV2.swift
//  RentalCar
//
//  Created by Ivan on 25.03.2023.
//

import UIKit

protocol IBaseCollectionViewControllerV2 where Self: UIViewController {
    var collectionView: UICollectionView { get }
    var dataSource: IBaseDataSource { get }
    var delegate: IBaseFlowLayout { get }
    var coordinator: ICoordinator { get }
    var categoryPrice: CategoryPrice { get }
    var city: City? { get set }
    func reloadData(with model: [Model])
}
 
class BaseCollectionViewControllerV2: UIViewController {
    
    // MARK: - Properties
    
    var dataSource: IBaseDataSource
    var delegate: IBaseFlowLayout
    var coordinator: ICoordinator
    var city: City?
    var categoryPrice: CategoryPrice
    
    // MARK: - UI
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.register(cell: BaseCollectionViewCell.self)
        collectionView.register(cell: ChooseCollectionViewCell.self)
        collectionView.register(cell: StockCollectionViewCell.self)
        collectionView.register(cell: EmptyStockCollectionViewCell.self)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK: - Init
    
    init(
        dataSource: IBaseDataSource,
        delegate: IBaseFlowLayout,
        coordinator: ICoordinator,
        categoryPrice: CategoryPrice = .personPrice
    ) {
        self.dataSource = dataSource
        self.delegate = delegate
        self.coordinator = coordinator
        self.categoryPrice = categoryPrice
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeView()
    }
    
    // MARK: - Private
    
    private func customizeView() {
        view.backgroundColor = .white
    }
}

// MARK: - IBaseCollectionViewControllerV2

extension BaseCollectionViewControllerV2: IBaseCollectionViewControllerV2 {
    
    func reloadData(with model: [Model]) {
        dataSource.setupModel(model)
        delegate.setupModel(model)
        collectionView.reloadData()
    }
}
