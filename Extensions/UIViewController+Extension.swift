//
//  UIViewController+Extension.swift
//  RentalCar
//
//  Created by Ivan on 20.02.2022.
//

import UIKit

extension UIViewController {
    // TODO: - функция используется в одном месте. Нужна ли она вообще?
    func makeCurrentPriceWith(_ category: CategoryPrice, car: CarModel2) -> Price? {
        switch category {
        case .personPrice:
            return car.price?.withoutNDS
        case.commercialPriceWithNDS:
            return car.price?.withNDS
        case .commercialPriceWithoutNDS:
            return car.price?.withoutNDS
        }
    }
    
    func call() {
        let number = "+74954311111"
        guard let url = URL(string: "tel://\(number)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            AnalyticEvent.callButtonTapped.send()
        }
    }
    
    func showErrorAlert(with text: String) {
        let alert = UIAlertController(title: "Произошла ошибка", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Хорошо", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

let blackView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height))
let activityIndicator = UIActivityIndicatorView(style: .medium)

extension UIViewController {
    func lockView() {
        view.addSubview(blackView)
        view.addSubview(activityIndicator)
        blackView.backgroundColor = .black
        blackView.alpha = 0.0
        activityIndicator.center = view.center
        activityIndicator.color = .white
        UIView.animate(withDuration: 0.25) {
            blackView.alpha = 0.75
            activityIndicator.startAnimating()
        }
    }
    
    func unlock() {
        UIView.animate(withDuration: 0.25) {
            blackView.alpha = 0.0
            activityIndicator.stopAnimating()
        } completion: { _ in
            blackView.removeFromSuperview()
            activityIndicator.removeFromSuperview()
        }
    }
}
