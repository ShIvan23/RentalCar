//
//  CollectionAndSearchViewController.swift
//  RentalCar
//
//  Created by Ivan on 25.03.2023.
//

import SnapKit

final class CollectionAndSearchViewController: BaseCollectionViewControllerV2 {
    
    // MARK: - Properties
    
    private var carBrands = [String]()
    
    // MARK: - UI
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    
    private lazy var searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(hexString: "#000000", alpha: 0.65).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.text = "Найти машину"
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Войти", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var callUsButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Позвонить нам", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(callUsButtonAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        addSearchGesture()
    }
    
    // MARK: - Private
    
    @objc private func loginButtonAction() {
        if AppState.shared.userWasLogin {
            showProfileViewController()
        } else {
            let loginViewController = LoginViewController()
            // TODO: - Зачем делегат?
//            loginViewController.delegate = self
            navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
    @objc private func callUsButtonAction() {
        call()
    }
    
    private func showProfileViewController() {
        let profileViewController = ProfileViewController()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    private func addSearchGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchTapGesture))
        searchView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func searchTapGesture() {
        let popoverTableView = PopoverTableViewController(model: carBrands, popoverType: .searchCar)
        popoverTableView.modalPresentationStyle = .popover
        popoverTableView.popoverPresentationController?.delegate = self
        popoverTableView.popoverPresentationController?.sourceView = searchView
        popoverTableView.popoverPresentationController?.sourceRect = CGRect(x: searchView.bounds.midX, y: searchView.bounds.maxY, width: 0, height: 0)
        popoverTableView.preferredContentSize = CGSize(width: ScreenSize.width, height: CGFloat(carBrands.count * 40))
        popoverTableView.delegate = self
        present(popoverTableView, animated: true)
        AnalyticEvent.searchCarTapped.send()
    }
    
    private func layout() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.bottomMargin.left.right.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.width.equalTo(scrollView)
        }
        
        [searchView, searchImageView, searchLabel, loginButton, collectionView, callUsButton].forEach { contentView.addSubview($0) }
        
        searchView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.left.equalToSuperview().inset(8)
            make.height.equalTo(34)
        }
        
        searchImageView.snp.makeConstraints { make in
            make.left.equalTo(searchView.snp.left).offset(10)
            make.height.width.equalTo(16)
            make.centerY.equalTo(searchView.snp.centerY)
        }
        
        searchLabel.snp.makeConstraints { make in
            make.left.equalTo(searchImageView.snp.right).offset(6)
            make.centerY.equalTo(searchView.snp.centerY)
        }
        
        loginButton.snp.makeConstraints { make in
            make.left.equalTo(searchView.snp.right).offset(8)
            make.right.equalToSuperview().inset(8)
            make.height.equalTo(searchView.snp.height)
            make.centerY.equalTo(searchView.snp.centerY)
            make.width.equalTo(100)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(CGFloat.cellHeight * 2 + CGFloat.sideInset * 3)
        }
        
        callUsButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.bottom.equalTo(contentView.snp.bottom).inset(20)
        }
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension CollectionAndSearchViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - PopoverTableViewControllerDelegate

extension CollectionAndSearchViewController: PopoverTableViewControllerDelegate {
    func selectedValue(type: PopoverType, text: String) {
        print("ty ty")
    }
}
