//
//  OrderUnauthorizedViewController.swift
//  RentalCar
//
//  Created by Ivan on 10.02.2022.
//

import SnapKit
import UIKit

final class OrderUnauthorizedViewController: UIViewController {
    
    private let locationModel = ["Офис(Волгоградский пр-т) *Бесплатно", "Аэропорт/Вокзал", "Другое место"]
    private var selectedLocation = ""
    private var selectedDate = ""
    
    private let locationLabel: UILabel = {
        let label = UILabel()
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
        return view
    }()
    
    private let placeholderLocationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "Выберите место"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата начала и конца аренды"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let dateView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemGray6
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let placeholderDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "Выберите даты"
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
        let tapLocationGesture = UITapGestureRecognizer(target: self, action: #selector(tapLocationGestureAction))
        locationView.addGestureRecognizer(tapLocationGesture)
        
        let tapDateGesture = UITapGestureRecognizer(target: self, action: #selector(tapDateGestureAction))
        dateView.addGestureRecognizer(tapDateGesture)
    }
    
    private func layout() {
        /// - Location
        [locationLabel, locationView, placeholderLocationLabel].forEach { view.addSubview($0) }
        
        locationLabel.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        locationView.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        placeholderLocationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationView.snp.centerY)
            make.left.right.equalTo(locationView).inset(8)
        }
        
        /// - Date
        [dateLabel, dateView, placeholderDateLabel].forEach { view.addSubview($0) }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(locationView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        
        dateView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        placeholderDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateView.snp.centerY)
            make.left.right.equalTo(dateView).inset(8)
        }
        
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
    
    @objc private func tapDateGestureAction() {
        let calendarVC = CalendarViewController()
        calendarVC.modalPresentationStyle = .popover
        calendarVC.popoverPresentationController?.delegate = self
        calendarVC.popoverPresentationController?.sourceView = dateView
        calendarVC.popoverPresentationController?.sourceRect = CGRect(x: dateView.bounds.midX, y: dateView.bounds.maxY, width: 0, height: 0)
        calendarVC.preferredContentSize = CGSize(width: ScreenSize.width - 32, height: CGFloat(345))
        calendarVC.delegate = self
        present(calendarVC, animated: true)
    }
    
}

// MARK: - UIPopoverPresentationControllerDelegate

extension OrderUnauthorizedViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - PopoverLocationTableViewControllerDelegate

extension OrderUnauthorizedViewController: PopoverLocationTableViewControllerDelegate {
    func selectedLocation(place: String) {
        placeholderLocationLabel.text = place
        selectedLocation = place
    }
}

// MARK: - CalendarViewControllerDelegate

extension OrderUnauthorizedViewController: CalendarViewControllerDelegate {
    func dateSelected(_ dateString: String) {
        placeholderDateLabel.text = dateString
        selectedDate = dateString
    }
}
