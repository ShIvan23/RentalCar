//
//  PopoverLocationTableViewController.swift
//  RentalCar
//
//  Created by Ivan on 13.02.2022.
//

import UIKit

protocol PopoverTableViewControllerDelegate: AnyObject {
    func selectedValue(text: String)
}

final class PopoverTableViewController: UIViewController {
    
    private let model: [String]
    weak var delegate: PopoverTableViewControllerDelegate?
    
    private lazy var popoverLocationTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: DescriptionTableViewCell.self)
        /// Когда выставляю это параметр верстка ячейки отображаются хреново
//        tableView.isScrollEnabled = false
        return tableView
    }()
    
    init(model: [String]) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
    }
    
    private func layout() {
        view.addSubview(popoverLocationTableView)

        NSLayoutConstraint.activate([
            popoverLocationTableView.topAnchor.constraint(equalTo: view.topAnchor),
            popoverLocationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popoverLocationTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            popoverLocationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension PopoverTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DescriptionTableViewCell = tableView.dequeueCell(for: indexPath)
        let mutableArray = model.makeAttributedPlaceString(stringArray: model)
        cell.setupCell(mutableArray[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PopoverTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.selectedValue(text: model[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
