//
//  OrderUnauthorizedViewController.swift
//  RentalCar
//
//  Created by Ivan on 10.02.2022.
//

import SnapKit
import UIKit

final class OrderUnauthorizedViewController: UIViewController, ToastViewShowable {
    
    var showingToast: ToastView?
    
    private lazy var rentalManager: RentalManager = RentalManagerImp()
    private var carModel: CarModel2
    private var categoryPrice: CategoryPrice 
    private let locationModel = ["Офис", "Аэропорт/Вокзал", "Другое место"]
    private var selectedLocation = ""
    private var selectedDate = ""
    private var selectedDaysCount = 1
    private var currentPrice: Price?
    private var currentCoast = 0
    private var isNeedDriver = false
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
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
    
    private let driverLabel: UILabel = {
        let label = UILabel()
        label.text = "Нужен водитель"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let driverSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(driverSwitcherAction), for: .valueChanged)
        return switcher
    }()
    
    private lazy var priceOneDay: UILabel = {
        let label = UILabel()
        label.attributedText = makeOneDayPrice()
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
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Зарегистрироваться и оплатить", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(registerButtonAction), for: .touchUpInside)
        return button
    }()
    
    init(
        carModel: CarModel2,
        categoryPrice: CategoryPrice,
        currentPrice: Price?
    ) {
        self.carModel = carModel
        self.categoryPrice = categoryPrice
        self.currentPrice = currentPrice
        super.init(nibName: nil, bundle: nil)
        currentCoast = currentPrice?.price ?? 0
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
        registerButton.setCustomGradient()
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
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
        }
    }
    
    @objc private func orderButtonAction() {
//        print("Отправить письмо на бэк")
//        print("car = \(carModel.name)")
//        print("selectedLocation = \(selectedLocation)")
//        print("selectedDate = \(selectedDate)")
//        print("Name = \(nameTextField.text!)")
//        print("priceDay = \(priceOneDay.text!)")
//        print("pricePeriod = \(pricePeriodLabel.text!)")
//        print("needDriver = \(isNeedDriver ? "Да" : "Нет")")
        let order = Order(autoId: carModel.id ?? 0,
                          name: nameTextField.text ?? "",
                          location: selectedLocation,
                          rentalDate: selectedDate,
                          phone: telephoneTextField.text ?? "",
                          needDriver: isNeedDriver,
                          cost: Int(pricePeriodLabel.text ?? "") ?? 0)
        sendOrder(order)
    }
    
    @objc private func registerButtonAction() {
        print("register")
    }
    
    private func addTextFieldsDelegate() {
        nameTextField.delegate = self
        telephoneTextField.delegate = self
    }
    
    private func makeOneDayPrice() -> NSMutableAttributedString {
        let text = "Цена за сутки:"
        let currentPrice = isNeedDriver ? currentCoast + (currentPrice?.priceDriver ?? 0) : currentCoast
        let mutableText = NSMutableAttributedString(string: text + " " + "\(currentPrice) ₽")
        mutableText.setFont(font: .boldSystemFont(ofSize: 18), forText: text)
        return mutableText
    }
    
    private func makePeriodPrice(_ daysCount: Int = 1) -> NSMutableAttributedString {
        let text = "Цена за весь период:"
        let price = isNeedDriver ? currentCoast + (currentPrice?.priceDriver ?? 0) : currentCoast
        let sum = price * daysCount
        let mutableText = NSMutableAttributedString(string: text + " " + "\(sum) ₽")
        mutableText.setFont(font: .boldSystemFont(ofSize: 18), forText: text)
        return mutableText
    }
    
    private func makeCurrentPriceForDay(daysCount: Int) -> Int {
        var currentPriceForDay = 0
        if daysCount < 3 {
            currentPriceForDay = currentPrice?.price ?? 0
        } else if daysCount >= 3 && daysCount <= 6 {
            currentPriceForDay = currentPrice?.priceFrom3To6Days ?? 0
        } else if daysCount >= 7 && daysCount <= 13 {
            currentPriceForDay = currentPrice?.priceFrom7To13Days ?? 0
        } else if daysCount >= 14 && daysCount <= 29 {
            currentPriceForDay = currentPrice?.priceFrom14To29Days ?? 0
        } else if daysCount >= 30 {
            currentPriceForDay = currentPrice?.priceMonth ?? 0
        }
        return currentPriceForDay
    }
    
    private func sendOrder(_ order: Order) {
        rentalManager.postOrder(order: order) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.showSuccessToast(with: "Ваш заказ отправлен.\nМенеджер Вам перезвонит.")
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.showFailureToast(with: "Произошла ошибка.\nПопробуйте отправить еще раз!")
                }
            }
        }
    }
    
    private func updateCoast() {
        priceOneDay.attributedText = makeOneDayPrice()
        pricePeriodLabel.attributedText = makePeriodPrice(selectedDaysCount)
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
        navigationItem.title = "Заказ " + (carModel.name ?? "")
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
         /// Driver
         driverLabel,
         driverSwitcher,
         /// Price
         priceOneDay,
         pricePeriodLabel,
        /// Order button
         orderButton,
        /// Register button
         registerButton
         ]
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
        
        /// Driver
        driverSwitcher.snp.makeConstraints { make in
            make.top.equalTo(telephoneTextField.snp.bottomMargin).offset(25)
            make.right.equalTo(contentView.snp.right).inset(30)
        }
        
        driverLabel.snp.makeConstraints { make in
            make.centerY.equalTo(driverSwitcher.snp.centerY)
            make.left.equalTo(contentView).inset(16)
            make.right.equalTo(driverSwitcher.snp.left).inset(8)
        }
        
        /// Price
        priceOneDay.snp.makeConstraints { make in
            make.top.equalTo(driverLabel.snp.bottom).offset(20)
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
        
        /// Register button
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(orderButton.snp.bottom).offset(20)
            make.left.right.equalTo(contentView).inset(16)
            make.height.equalTo(40)
            make.bottom.equalTo(contentView.snp.bottom).inset(20)
        }
    }
    
    
    @objc private func tapLocationGestureAction() {
        let popoverLocationTableVC = PopoverTableViewController(model: locationModel)
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
    
    @objc private func driverSwitcherAction() {
        isNeedDriver.toggle()
        updateCoast()
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension OrderUnauthorizedViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - PopoverLocationTableViewControllerDelegate

extension OrderUnauthorizedViewController: PopoverTableViewControllerDelegate {
    func selectedValue(text: String) {
        placeholderLocationLabel.textColor = .black
        placeholderLocationLabel.text = text
        selectedLocation = text
    }
}

// MARK: - CalendarViewControllerDelegate

extension OrderUnauthorizedViewController: CalendarViewControllerDelegate {
    func dateSelected(_ dateString: String, daysCount: Int) {
        if dateString.isEmpty {
            placeholderDateLabel.text = "Выберите даты"
            placeholderDateLabel.textColor = UIColor(hexString: "#C7C7CD")
            selectedDate = ""
            selectedDaysCount = daysCount
            currentCoast =  makeCurrentPriceForDay(daysCount: daysCount)
            updateCoast()
        } else {
            placeholderDateLabel.textColor = .black
            placeholderDateLabel.text = dateString
            selectedDate = dateString
            selectedDaysCount = daysCount
            currentCoast = makeCurrentPriceForDay(daysCount: daysCount)
            updateCoast()
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
