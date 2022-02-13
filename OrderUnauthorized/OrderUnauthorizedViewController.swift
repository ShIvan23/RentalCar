//
//  OrderUnauthorizedViewController.swift
//  RentalCar
//
//  Created by Ivan on 10.02.2022.
//

import UIKit

class OrderUnauthorizedViewController: UIViewController {
    
    private let locationModel = ["Офис(Волгоградский пр-т) *Бесплатно", "Аэропорт/Вокзал", "Другое место"]
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "Место подачи"
        return label
    }()
    
    private let locationView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemGray6
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let placeholderLocationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.text = "Выберите место"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeView()
        layout()
        addLocationGesture()
    }
    
    private func customizeView() {
        view.backgroundColor = .white
        navigationItem.title = "Заказ"
    }
    
    private func addLocationGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLocationGestureAction))
        locationView.addGestureRecognizer(tapGesture)
    }
    
    private func layout() {
        [locationLabel, locationView, placeholderLocationLabel].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            locationView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            locationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            locationView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            placeholderLocationLabel.centerYAnchor.constraint(equalTo: locationView.centerYAnchor),
            placeholderLocationLabel.leadingAnchor.constraint(equalTo: locationView.leadingAnchor, constant: 8),
            placeholderLocationLabel.trailingAnchor.constraint(equalTo: locationView.trailingAnchor, constant: -8)
        ])
    }
    
    @objc private func tapLocationGestureAction() {
        let popoverLocationTableVC = PopoverLocationTableViewController(model: locationModel)
        popoverLocationTableVC.modalPresentationStyle = .popover
        popoverLocationTableVC.popoverPresentationController?.delegate = self
        popoverLocationTableVC.popoverPresentationController?.sourceView = locationView
        popoverLocationTableVC.popoverPresentationController?.sourceRect = CGRect(x: locationView.bounds.midX, y: locationView.bounds.maxY, width: 0, height: 0)
        popoverLocationTableVC.preferredContentSize = CGSize(width: ScreenSize.width - 32, height: CGFloat(locationModel.count * 40))
        popoverLocationTableVC.delegate = self
        present(popoverLocationTableVC, animated: true)
    }
    
}

// MARK: - UIPopoverPresentationControllerDelegate

extension OrderUnauthorizedViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension OrderUnauthorizedViewController: PopoverLocationTableViewControllerDelegate {
    func selectedLocation(place: String) {
        placeholderLocationLabel.text = place
    }
}
