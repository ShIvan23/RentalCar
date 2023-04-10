//
//  BaseDataSource.swift
//  RentalCar
//
//  Created by Ivan on 25.03.2023.
//

import UIKit

protocol IBaseDataSource: UICollectionViewDataSource {
    var model: [Model] { get }
    func setupModel(_ model: [Model])
}
