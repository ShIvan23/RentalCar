//
//  ContactModel.swift
//  RentalCar
//
//  Created by Shishkin Ivan Sergeevich on 04.04.2023.
//

import Foundation

enum CityNumber: String {
    case moscow = "+74954311111"
    case kazan = "+78432111255"
}

struct ContactModel: Model {
    let city: String
    let address: String
    let phoneNumber: String
    let phoneNumberForCalling: CityNumber
    let phoneNumberForMessangers: String
    let email: String
    let latitude: Double
    let longitude: Double
}

extension ContactModel {
    static func makeContactsModel() -> [ContactModel] {
        var model = [ContactModel]()
        model.append(ContactModel(
            city: "Москва",
            address: "Москва, Волгоградский проспект, д. 32, корпус 1, ТЦ Фэвори, 1-й этаж",
            phoneNumber: "+7 (495) 431-11-11",
            phoneNumberForCalling: CityNumber.moscow,
            phoneNumberForMessangers: "+79163864866",
            email: "prokaavto@mail.ru",
            latitude: 55.723828,
            longitude: 37.688591)
        )
        
        model.append(ContactModel(
            city: "Казань",
            address: "Казань, ул. Галиаскара Камала, д. 41, офис 106",
            phoneNumber: "+7 (843) 211-12-55",
            phoneNumberForCalling: CityNumber.kazan,
            phoneNumberForMessangers: "+79178787586",
            email: "prokaavto@mail.ru",
            latitude: 55.781266,
            longitude: 49.105417)
        )
        
        return model
    }
}
