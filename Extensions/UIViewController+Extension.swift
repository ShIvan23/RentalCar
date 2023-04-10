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
    
    func call(city: CityNumber) {
        guard let url = URL(string: "tel://\(city.rawValue)") else { return }
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
let progressView = UIProgressView(progressViewStyle: .default)
let progressLabel = UILabel(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: 40))

extension UIViewController {
    func lockView(progress: Bool = false) {
        view.addSubview(blackView)
        view.addSubview(activityIndicator)
        if progress {
            view.addSubview(progressLabel)
            view.addSubview(progressView)
            progressLabel.center = CGPoint(x: view.center.x, y: view.center.y + 30)
            progressView.center = CGPoint(x: view.center.x, y: view.center.y + 50)
        }
        blackView.backgroundColor = .black
        blackView.alpha = 0.0
        
        progressView.alpha = 0.0
        progressView.progressTintColor = UIColor(hexString: "#4ec378")
        
        progressLabel.font = .systemFont(ofSize: 20)
        progressLabel.textColor = .white
        progressLabel.alpha = 0.0
        progressLabel.textAlignment = .center
        
        activityIndicator.center = view.center
        activityIndicator.color = .white
        
        UIView.animate(withDuration: 0.25) {
            blackView.alpha = 0.75
            activityIndicator.startAnimating()
            if progress {
                progressView.alpha = 1.0
                progressLabel.alpha = 1.0
            }
        }
    }
    
    func unlock() {
        UIView.animate(withDuration: 0.25) {
            blackView.alpha = 0.0
            activityIndicator.stopAnimating()
            progressView.alpha = 0.0
            progressLabel.alpha = 0.0
        } completion: { _ in
            blackView.removeFromSuperview()
            activityIndicator.removeFromSuperview()
            progressView.removeFromSuperview()
            progressLabel.removeFromSuperview()
        }
    }
}
