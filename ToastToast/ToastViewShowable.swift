//
//  ToastViewShowable.swift
//  RentalCar
//
//  Created by Ivan on 04.04.2022.
//

import UIKit

protocol ToastViewShowable: AnyObject {
    var showingToast: ToastView? { get set }
    func showSuccessToast(with text: String)
    func showFailureToast(with text: String)
}

extension ToastViewShowable where Self: UIViewController {
    func showSuccessToast(with text: String) {
        popToast()
        let toast = ToastView(text: text, type: .success)
        view.addSubview(toast)
        toast.layoutToaster(in: view)
        toast.animateShowingToaster()
        showingToast = toast
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            toast.animateDismissToaster(in: self.view)
        }
    }
    
    func showFailureToast(with text: String) {
        popToast()
        let toast = ToastView(text: text, type: .failure)
        view.addSubview(toast)
        toast.layoutToaster(in: view)
        toast.animateShowingToaster()
        showingToast = toast
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            toast.animateDismissToaster(in: self.view)
        }
    }
    
    private func popToast() {
        if showingToast != nil {
            showingToast!.animateDismissToaster(in: view)
            showingToast = nil
        }
    }
}
