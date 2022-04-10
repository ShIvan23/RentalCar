//
//  ProfileViewController.swift
//  RentalCar
//
//  Created by Ivan on 10.04.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // TODO: - Здесь нужно реализовать прикрепление фото
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "Для завершения регистрации необходимо прикрепить фото паспорта и водительского удостоверения"
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        layout()
    }
    
    private func customize() {
        view.backgroundColor = .white
    }

    private func layout() {
        
    }
}
