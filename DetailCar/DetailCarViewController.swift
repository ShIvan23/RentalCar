//
//  DetailCarViewController.swift
//  RentalCar
//
//  Created by Ivan on 05.02.2022.
//

import UIKit

final class DetailCarViewController: UIViewController {
    
    private let carModel: CarModel2
    private var categoryPrice: CategoryPrice 
    private var currentPrice = 0
    private var descriptions = [NSMutableAttributedString]()
    private lazy var transition = ImageTransition()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(cell: ImageAndButtonTableViewCell.self)
        tableView.register(cell: DescriptionTableViewCell.self)
        tableView.register(cell: CallUsTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        return tableView
    }()
    
    init(carModel: CarModel2, categoryPrice: CategoryPrice) {
        self.carModel = carModel
        self.categoryPrice = categoryPrice
        super.init(nibName: nil, bundle: nil)
        currentPrice = makeCurrentPriceWith(categoryPrice, car: carModel)
        makeDescriptionArray()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func makeDescriptionArray() {
        var stringArray = [String]()
        stringArray.append("\(currentPrice)")
        stringArray.append("\(carModel.engineVolume ?? 0)")
        stringArray.append("\(carModel.countSeats ?? 0)")
        stringArray.append(carModel.driveType ?? "")
        stringArray.append("\(carModel.year ?? 0)")
        stringArray.append(carModel.gearboxType ?? "")
        stringArray.append("\(carModel.countDoors ?? 0)")
        stringArray.append((carModel.conditioner ?? false) ? "Да" : "Нет")
        stringArray.append((carModel.description?.html2String ?? ""))
        descriptions = stringArray.makeAttributedString(stringArray: stringArray)
    }
}

// MARK: - UITableViewDataSource

extension DetailCarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        descriptions.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: ImageAndButtonTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setupCell(images: carModel.images)
            cell.delegate = self
            return cell
            
            /// Позвонить нам
        case descriptions.count + 1:
            let cell: CallUsTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.delegate = self
            return cell
            
        default:
            let cell: DescriptionTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setupCell(descriptions[indexPath.row - 1])
            return cell
        }
    }
    
}

// MARK: - UITableViewDelegate

extension DetailCarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return view.frame.width + 26 + 8 + 50 // коллекция, pageControl, отступ, кнопка
            // на iOS 14 pageControl 27.5
            
            /// Большое описание машины
        case descriptions.count:
            return UITableView.automaticDimension
            
            /// Позвонить нам
        case descriptions.count + 1:
            return 40 + 16 * 2
        default:
            return 40
        }
    }
}

// MARK: - ImageAndButtonTableViewCellDelegate

extension DetailCarViewController: ImageAndButtonTableViewCellDelegate {
    func photoTapped(item: Int) {
        let fullImageVC = FullImageViewController(image: carModel.images?[item] ?? "")
        fullImageVC.modalPresentationStyle = .custom
        fullImageVC.transitioningDelegate = self
        present(fullImageVC, animated: true)
    }
    
    func orderButtonTapped() {
        let orderUnauthorizesVC = OrderUnauthorizedViewController(carModel: carModel, categoryPrice: categoryPrice)
        navigationController?.pushViewController(orderUnauthorizesVC, animated: true)
    }
}

// MARK: - CallUsDelegate

extension DetailCarViewController: CallUsDelegate {
    func callUs() {
        call()
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension DetailCarViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
