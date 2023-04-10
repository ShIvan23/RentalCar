//
//  PromoDelegate.swift
//  RentalCar
//
//  Created by Shishkin Ivan Sergeevich on 04.04.2023.
//

import UIKit

final class PromoDelegate: HorizontalFlowLayout {
    
    override var model: [Model] {
        get { return promoModel }
        set {
            guard let promoModel = newValue as? [Promo] else { return }
            self.promoModel = promoModel
        }
    }
    
    private var promoModel: [Promo] = []
    private var coordinator: ICoordinator
    
    init(coordinator: ICoordinator) {
        self.coordinator = coordinator
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Ничего не происходит при нажатии на акцию
        AnalyticEvent.tappedDetailPromo.send()
        return
    }
}
