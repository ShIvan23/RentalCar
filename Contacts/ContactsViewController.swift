//
//  ContactsViewController.swift
//  RentalCar
//
//  Created by Ivan on 11.03.2022.
//

import YandexMapsMobile
import SnapKit
import UIKit

final class ContactsViewController: UIViewController, ToastViewShowable {
   
    var showingToast: ToastView?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mapView = YMKMapView()
    /// Для тестов на реальном устройстве
//    private let mapView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .red
//        return view
//    }()
    
    private var mapObjects: YMKMapObjectCollection {
        return mapView.mapWindow.map.mapObjects
    }
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.text = "Москва, Волгоградский проспект, д. 32, корпус 1, ТЦ Фэвори, 1-й этаж"
        return label
    }()
    
    private lazy var copyAddressButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "copy"), for: .normal)
        button.addTarget(self, action: #selector(copyAction), for: .touchUpInside)
        button.tintColor = .systemGray2
        return button
    }()
    
    private let workTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Работаем eжедневно с 9:00 до 21:00"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let telephoneLabel: UILabel = {
        let label = UILabel()
        label.text = "+7 (495) 431-11-11"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    private lazy var callUsButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Позвонить нам", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(callUsButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let whatsAppImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "whatsapp")
        return imageView
    }()
    
    private lazy var writeWhatsAppButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Написать в WhatsApp", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(openMessenger), for: .touchUpInside)
        return button
    }()
    
    private let telegramImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "telegram")
        return imageView
    }()
    
    private lazy var writeTelegramButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Написать в Telegram", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(openMessenger), for: .touchUpInside)
        return button
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "prokaavto@mail.ru"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var copyEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "copy"), for: .normal)
        button.addTarget(self, action: #selector(copyAction), for: .touchUpInside)
        button.tintColor = .systemGray2
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeView()
        layout()
        setupMap()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        callUsButton.setCustomGradient()
        writeWhatsAppButton.setCustomGradient()
        writeTelegramButton.setCustomGradient()
    }
    
    @objc private func callUsButtonAction() {
        call()
    }
    
    @objc private func openMessenger(button: UIButton) {
        let number = "+79163864866"
        switch button {
        case writeWhatsAppButton:
            guard let url = URL(string: "https://api.whatsapp.com/send?phone=\(number)") else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case writeTelegramButton:
            guard let url = URL(string: "https://t.me/\(number)") else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        default:
            break
        }
    }
    
    @objc private func copyAction(button: UIButton) {
        switch button {
        case copyAddressButton:
            UIPasteboard.general.string = "Москва, Волгоградский проспект, д. 32, корпус 1"
            animate(copyButton: copyAddressButton)
            showSuccessToast(with: "Адрес скопирован")
        case copyEmailButton:
            UIPasteboard.general.string = emailLabel.text
            animate(copyButton: copyEmailButton)
            showSuccessToast(with: "Почта скопирована")
        default:
            break
        }
    }
    
    private func animate(copyButton: UIButton) {
        UIView.animate(withDuration: 0.1) {
            copyButton.alpha = 0.3
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                copyButton.alpha = 1.0
            }
        }
    }
    
    private func setupMap() {
        let point = YMKPoint(latitude: 55.723828, longitude: 37.688591)
        mapView.mapWindow.map.move(with: YMKCameraPosition(target: point, zoom: 15.5, azimuth: 0, tilt: 0))

        mapObjects.addPlacemark(with: point, image: UIImage(named: "120")!)
    }
    
    private func customizeView() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        [scrollView, mapView].forEach { view.addSubview($0) }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.bottom.left.right.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.width.equalTo(scrollView)
        }
        
        [addressLabel, copyAddressButton, workTimeLabel, telephoneLabel, callUsButton, whatsAppImageView, writeWhatsAppButton, telegramImageView, writeTelegramButton, emailLabel, copyEmailButton].forEach { contentView.addSubview($0) }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.height.width.equalTo(ScreenSize.width)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16 + 30 + 6) // отступ кнопки + ширина кнопки + отступ от кнопки
        }
        
        copyAddressButton.snp.makeConstraints { make in
            make.centerY.equalTo(addressLabel.snp.centerY)
            make.right.equalToSuperview().inset(16)
            make.height.width.equalTo(30)
        }
        
        workTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
        }
        
        telephoneLabel.snp.makeConstraints { make in
            make.top.equalTo(workTimeLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        callUsButton.snp.makeConstraints { make in
            make.top.equalTo(telephoneLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        whatsAppImageView.snp.makeConstraints { make in
            make.top.equalTo(callUsButton.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        writeWhatsAppButton.snp.makeConstraints { make in
            make.top.equalTo(whatsAppImageView)
            make.height.equalTo(40)
            make.left.equalTo(whatsAppImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        telegramImageView.snp.makeConstraints { make in
            make.top.equalTo(writeWhatsAppButton.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        writeTelegramButton.snp.makeConstraints { make in
            make.top.equalTo(telegramImageView)
            make.height.equalTo(40)
            make.left.equalTo(telegramImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(writeTelegramButton.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16 + 30 + 10) // отступ кнопки + ширина кнопки + отступ от кнопки
        }

        copyEmailButton.snp.makeConstraints { make in
            make.centerY.equalTo(emailLabel.snp.centerY)
            make.right.equalToSuperview().inset(16)
            make.height.width.equalTo(30)
            make.bottom.equalTo(contentView.snp.bottom).inset(20)
        }
    }
}
