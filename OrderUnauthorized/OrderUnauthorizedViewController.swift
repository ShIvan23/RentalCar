//
//  OrderUnauthorizedViewController.swift
//  RentalCar
//
//  Created by Ivan on 10.02.2022.
//

import SnapKit
import UIKit

final class OrderUnauthorizedViewController: UIViewController {
    
    private var carModel: CarModel
    private let locationModel = ["Офис(Волгоградский пр-т) *Бесплатно", "Аэропорт/Вокзал", "Другое место"]
    private var selectedLocation = ""
    private var selectedDate = ""
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
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
        label.textColor = UIColor(hexString: "#C7C7CD")
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
        label.textColor = UIColor(hexString: "#C7C7CD")
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите фамилию и имя"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var nameTextField = TextField(placeholder: "Ваши фамилия и имя")
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите ваш номер телефона"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var telephoneTextField = TextField(placeholder: "Ваш номер телефона", keyboardType: .numberPad)
    
    private lazy var priceOneDay: UILabel = {
        let label = UILabel()
        let text = "Цена за сутки:"
        let mutableText = NSMutableAttributedString(string: text + " " + "\(carModel.personPrice) ₽")
        mutableText.setFont(font: .boldSystemFont(ofSize: 18), forText: text)
        label.attributedText = mutableText
        return label
    }()
    
    private lazy var pricePeriodLabel: UILabel = {
        let label = UILabel()
        label.attributedText = makePeriodPrice()
        return label
    }()
    
    private lazy var orderButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSAttributedString(string: "Отправить заказ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(orderButtonAction), for: .touchUpInside)
        return button
    }()
    
    init(carModel: CarModel) {
        self.carModel = carModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeView()
        layout()
        addLocationGesture()
        addTextFieldsDelegate()
        addGestureToHideKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        orderButton.setCustomGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide() {
        scrollView.contentInset.bottom = 0
        scrollView.setContentOffset(.zero, animated: true)
        scrollView.isScrollEnabled = false
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        /// тут есть расчет высоты клавиатуры
        /// Можно захардкодить высоту scrollView. И тогда из высоты экрана вычитать высоту клавиатуры, вычитать высоту scrollView. И это значение нужно будет добавить к scrollView.contentInset.bottom
        
//                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                    if nameTextField.isFirstResponder || telephoneTextField.isFirstResponder {
                        scrollView.contentInset.bottom = 100
                        scrollView.isScrollEnabled = true
//                    }
//                }
    }
    
    @objc private func orderButtonAction() {
        print("Отправить письмо на бэк")
    }
    
    private func addTextFieldsDelegate() {
        nameTextField.delegate = self
        telephoneTextField.delegate = self
    }
    
    private func makePeriodPrice(_ daysCount: Int = 1, price: Int? = nil) -> NSMutableAttributedString {
        let text = "Цена за весь период:"
        let currentPrice = (price ?? carModel.personPrice) * daysCount
        let mutableText = NSMutableAttributedString(string: text + " " + "\(currentPrice) ₽")
        mutableText.setFont(font: .boldSystemFont(ofSize: 18), forText: text)
        return mutableText
    }
    
    private func addGestureToHideKeyboard() {
        view.addTapGestureToHideKeyboard()
    }
    
    private func resignResponders() {
        nameTextField.resignFirstResponder()
        telephoneTextField.resignFirstResponder()
    }
    
    private func customizeView() {
        view.backgroundColor = .white
        navigationItem.title = "Заказ " + carModel.marka + " " + carModel.model
    }
    
    private func addLocationGesture() {
        let tapLocationGesture = UITapGestureRecognizer(target: self, action: #selector(tapLocationGestureAction))
        locationView.addGestureRecognizer(tapLocationGesture)
        
        let tapDateGesture = UITapGestureRecognizer(target: self, action: #selector(tapDateGestureAction))
        dateView.addGestureRecognizer(tapDateGesture)
    }
    
    private func layout() {
        /// Scroll View
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.bottom.left.right.equalToSuperview()
        }
        
        /// Content view
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        
        /// Location
        [locationLabel,
         locationView,
         placeholderLocationLabel,
         /// Date
         dateLabel,
         dateView,
         placeholderDateLabel,
         /// Name
         nameLabel,
         nameTextField,
         /// Telephone number
         numberLabel,
         telephoneTextField,
         /// Price
         priceOneDay,
         pricePeriodLabel,
        /// Order button
         orderButton]
            .forEach { contentView.addSubview($0) }
        
        /// Location
        locationLabel.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().offset(16)
            make.left.right.equalTo(contentView).inset(16)
        }
        
        locationView.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(8)
            make.left.right.equalTo(contentView).inset(16)
            make.height.equalTo(40)
        }
        
        placeholderLocationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationView.snp.centerY)
            make.left.right.equalTo(locationView).inset(8)
        }
        
        /// Date
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(locationView.snp.bottom).offset(20)
            make.left.right.equalTo(contentView).inset(16)
        }
        
        dateView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.left.right.equalTo(contentView).inset(16)
            make.height.equalTo(40)
        }
        
        placeholderDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateView.snp.centerY)
            make.left.right.equalTo(dateView).inset(8)
        }
        
        /// Name
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(dateView.snp.bottom).offset(20)
            make.left.right.equalTo(contentView).inset(16)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.right.equalTo(contentView).inset(16)
            make.height.equalTo(40)
        }
        
        /// Telephone number
        numberLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.left.right.equalTo(contentView).inset(16)
        }
        
        telephoneTextField.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(8)
            make.left.right.equalTo(contentView).inset(16)
            make.height.equalTo(40)
        }
        
        /// Price
        priceOneDay.snp.makeConstraints { make in
            make.top.equalTo(telephoneTextField.snp.bottom).offset(20)
            make.left.right.equalTo(contentView).inset(16)
        }
        
        pricePeriodLabel.snp.makeConstraints { make in
            make.top.equalTo(priceOneDay.snp.bottom).offset(20)
            make.left.right.equalTo(contentView).inset(16)
        }
        
        /// Order Button
        orderButton.snp.makeConstraints { make in
            make.top.equalTo(pricePeriodLabel.snp.bottom).offset(20)
            make.left.right.equalTo(contentView).inset(16)
            make.height.equalTo(40)
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
        resignResponders()
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
        resignResponders()
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
        placeholderLocationLabel.textColor = .black
        placeholderLocationLabel.text = place
        selectedLocation = place
    }
}

// MARK: - CalendarViewControllerDelegate

extension OrderUnauthorizedViewController: CalendarViewControllerDelegate {
    func dateSelected(_ dateString: String, daysCount: Int) {
        if dateString.isEmpty {
            placeholderDateLabel.text = "Выберите даты"
            placeholderDateLabel.textColor = UIColor(hexString: "#C7C7CD")
            pricePeriodLabel.attributedText = makePeriodPrice()
            selectedDate = ""
        } else {
            placeholderDateLabel.textColor = .black
            placeholderDateLabel.text = dateString
            
            // - TODO: Добавить логику по изменению прайса в зависимости от количества дней
            var currentPice = 0
            switch daysCount {
            default:
                currentPice = carModel.personPrice
            }
            pricePeriodLabel.attributedText = makePeriodPrice(daysCount, price: currentPice)
            selectedDate = dateString
        }
    }
}

// MARK: - UITextFieldDelegate

extension OrderUnauthorizedViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        telephoneTextField.becomeFirstResponder()
        return true
    }
    
    /// Если пользователь перешел на ввод номера добавляем +7
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == telephoneTextField {
            textField.text = "+7"
        }
        return true
    }
    
    /// Маска для номера телефона
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == telephoneTextField {
            let char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if (isBackSpace == -92) && (textField.text?.count)! > 0 {
                if (textField.text?.count)! == 4 {
                    textField.text = "+7"
                    return false
                }
                if textField.text! == "+7" {
                    return false
                }
                textField.text!.removeLast()
                return false
            }
            
            if (textField.text?.count)! == 5 {
                let text = textField.text!.replacingOccurrences(of: "+7", with: "")
                textField.text = "+7(\(text)) "  //There we are ading () and space two things
            }
            else if (textField.text?.count)! == 11 {
                let text = textField.text!.replacingOccurrences(of: "+7", with: "")
                textField.text = "+7\(text)-" //there we are ading - in textfield
            }
            else if (textField.text?.count)! > 15 {
                return false
            }
        }
        return true
    }
}
