//
//  DetailCarViewController.swift
//  RentalCar
//
//  Created by Ivan on 05.02.2022.
//

import UIKit

final class DetailCarViewController: UIViewController {
    
    private var carModel: CarModel
    private var descriptions = [NSMutableAttributedString]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(cell: ImageAndButtonTableViewCell.self)
        tableView.register(cell: DescriptionTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        return tableView
    }()
    
    init(carModel: CarModel) {
        self.carModel = carModel
        super.init(nibName: nil, bundle: nil)
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
        stringArray.append(carModel.engineVolume)
        stringArray.append("\(carModel.numberOfSeats)")
        stringArray.append(carModel.frontDrive)
        stringArray.append("\(carModel.age)")
        stringArray.append(carModel.transmission)
        stringArray.append("\(carModel.numberOfDoors)")
        stringArray.append(carModel.hasConditioner ? "Да" : "Нет")
        stringArray.append(carModel.description)
        descriptions = stringArray.makeAttributedString(stringArray: stringArray)
    }
}

// MARK: - UITableViewDataSource

extension DetailCarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        descriptions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: ImageAndButtonTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setupCell(images: carModel.allImages)
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
        case descriptions.count:
            return UITableView.automaticDimension
        default:
            return 40
        }
    }
}

extension DetailCarViewController: ImageAndButtonTableViewCellDelegate {
    func orderButtonTapped() {
        print("tap")
    }
}
