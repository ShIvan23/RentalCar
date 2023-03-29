//
//  BaseCollectionViewControllerV2.swift
//  RentalCar
//
//  Created by Ivan on 25.03.2023.
//

import SnapKit

protocol IBaseCollectionViewControllerV2 where Self: UIViewController {
    var collectionView: UICollectionView { get }
    var dataSource: IBaseDataSource { get }
    var delegate: IBaseFlowLayout{ get }
    func reloadData(with model: [Model])
}

extension IBaseCollectionViewControllerV2 {
    func reloadData(with model: [Model]) {
        dataSource.setupModel(model)
        delegate.setupModel(model)
        collectionView.reloadData()
    }
}

class BaseCollectionViewControllerV2: UIViewController, IBaseCollectionViewControllerV2 {
    
    // MARK: - Properties
    
    var dataSource: any IBaseDataSource
    var delegate: IBaseFlowLayout
    
    // MARK: - UI
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.register(cell: BaseCollectionViewCell.self)
        collectionView.register(cell: ChooseCollectionViewCell.self)
        collectionView.register(cell: StockCollectionViewCell.self)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK: - Init
    
    init(
        dataSource: any IBaseDataSource,
        delegate: IBaseFlowLayout
    ) {
        self.dataSource = dataSource
        self.delegate = delegate
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

//// MARK: - IBaseCollectionViewControllerV2
//
//extension BaseCollectionViewControllerV2: IBaseCollectionViewControllerV2 {
//    func reloadData() {
//        collectionView.reloadData()
//    }
//}
