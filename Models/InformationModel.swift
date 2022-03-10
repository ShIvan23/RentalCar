//
//  StockModel.swift
//  RentalCar
//
//  Created by Ivan on 20.02.2022.
//

import UIKit

struct InformationModel: Model {
    let name: String
    let image: UIImage
    
    static func makeMockStocks() -> [InformationModel] {
        var model = [InformationModel]()
        for _ in 1...4 {
            model.append(InformationModel(name: "С воскресенья по среду на весь автопарк -30% скидка", image: UIImage(named: "stock1")!))
        }
        return model
    }
    
    static func makeMockConditions() -> [InformationModel] {
        var model = [InformationModel]()
        model.append(InformationModel(name: "Физ лица", image: UIImage(named: "person")!))
        model.append(InformationModel(name: "Юр лица", image: UIImage(named: "company")!))
        return model
    }
}
