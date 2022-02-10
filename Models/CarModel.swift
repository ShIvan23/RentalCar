//
//  CarModel.swift
//  RentalCar
//
//  Created by Ivan on 27.01.2022.
//

import UIKit

protocol Model {}

struct CarClass: Model {
    let className: String
    let imageGroup: UIImage
    let carList: [CarModel]
    
    static func makeMockModel() -> [CarClass] {
        var model = [CarClass]()
        model.append(
            CarClass(
                className: "Стандарт",
                imageGroup: UIImage(named: "kiaRio")!,
                carList: CarModel.makeMockStandartModel()
            )
        )
        model.append(
            CarClass(
                className: "Комфорт",
                imageGroup: UIImage(named: "skodaKodiaq")!,
                carList: CarModel.makeMockComfortModel()
            )
        )
        model.append(
            CarClass(
                className: "Бизнес",
                imageGroup: UIImage(named: "mercedesBenzC200")!,
                carList: CarModel.makeMockBusinessModel()
            )
        )
        model.append(
            CarClass(
                className: "VIP",
                imageGroup: UIImage(named: "mercedesG500")!,
                carList: CarModel.makeMockVipModel()
            )
        )
        return model
    }
    
    static func makeMockLegalModel() -> [CarClass] {
        var model = [CarClass]()
        model.append(
            CarClass(
                className: "С НДС",
                imageGroup: UIImage(named: "withNDS")!,
                carList: []
            )
        )
        model.append(
            CarClass(
                className: "Без НДС",
                imageGroup: UIImage(named: "withoutNDS")!,
                carList: []
            )
        )
        
        return model
    }
}

struct CarModel: Model {
    let marka: String
    let model: String
    let age: Int
    let personPrice: Int
    let commercialPriceWithNDS: Int
    let commercialPriceWithoutNDS: Int
    let driverPriceImMoscow: Int
    let driverPriceInOblast: Int
    let previewImage: UIImage
    let engineVolume: String // объем двигателя
    let numberOfSeats: Int
    let frontDrive: String
    let transmission: String
    let numberOfDoors: Int
    let hasConditioner: Bool
    let allImages: [UIImage]
    let description: String
    
    static func makeMockStandartModel() -> [CarModel] {
        var model = [CarModel]()
        for _ in 0...10 {
            model.append(CarModel(
                marka: "KIA",
                model: "Rio",
                age: 2019,
                personPrice: 2450,
                commercialPriceWithNDS: 4000,
                commercialPriceWithoutNDS: 3500,
                driverPriceImMoscow: 2000,
                driverPriceInOblast: 3000,
                previewImage: UIImage(named: "kiaRio")!,
                engineVolume: "123 л.с.",
                numberOfSeats: 5,
                frontDrive: "Передний",
                transmission: "Автомат",
                numberOfDoors: 4,
                hasConditioner: true,
                allImages: [UIImage(named: "kiaRio1")!, UIImage(named: "kiaRio2")!, UIImage(named: "kiaRio3")!, UIImage(named: "kiaRio4")!],
                description: """
Новый седан Киа Рио – универсальный современный автомобиль для ежедневных задач. Оптимальная компоновка салона и максимально продуманная организация пространства подарит комфорт каждому пассажиру. Будьте уверены — места хватит всем. Оригинальный рисунок оптики украшает вид автомобиля сзади, что делает его еще более стильным. А яркий свет сделает Вас заметным в потоке даже в самый солнечный день.
"""
            ))
        }
        return model
    }
    
    static func makeMockComfortModel() -> [CarModel] {
        var model = [CarModel]()
        for _ in 0...10 {
            model.append(CarModel(
                marka: "Skoda",
                model: "Kodiaq",
                age: 2019,
                personPrice: 5200,
                commercialPriceWithNDS: 7000,
                commercialPriceWithoutNDS: 6500,
                driverPriceImMoscow: 2000,
                driverPriceInOblast: 3000,
                previewImage: UIImage(named: "skodaKodiaq")!,
                engineVolume: "1,4 л. /150 л.с.",
                numberOfSeats: 5,
                frontDrive: "Полный",
                transmission: "Автомат",
                numberOfDoors: 4,
                hasConditioner: true,
                allImages: [],
                description: """
Skoda Kodiaq — Чешский внедорожник Шкода Кодиак имеет солидные и одновременно практичные габариты. Слегка угловатый, но современный дизайн в консервативном стиле придает автомобилю ещё более серьёзный и мужественный вид. Внешность автомобиля также сочетает в себе ряд практичных черт, которые несомненно порадуют владельца. Салон авто радует глаз благодаря применению высококачественных материалов, стильному дизайну интерьера и продуманной эргономике пространства. Порадуется и ваш слух, ведь салон внедорожника получил одну из лучших систем звукоизоляции во всем классе. Даже при езде по бездорожью вы сможете наслаждаться музыкой, а не шумами извне
"""
            ))
        }
        return model
    }
    
    static func makeMockBusinessModel() -> [CarModel] {
        var model = [CarModel]()
        for _ in 0...10 {
            model.append(CarModel(
                marka: "Mercedes",
                model: "C 200",
                age: 2018,
                personPrice: 7000,
                commercialPriceWithNDS: 10000,
                commercialPriceWithoutNDS: 9500,
                driverPriceImMoscow: 2000,
                driverPriceInOblast: 3000,
                previewImage: UIImage(named: "mercedesBenzC200")!,
                engineVolume: "1,6 л. / 184 л.с",
                numberOfSeats: 5,
                frontDrive: "Полный",
                transmission: "Автомат",
                numberOfDoors: 4,
                hasConditioner: true,
                allImages: [],
                description: """
Mercedes-Benz C-Class – среднеразмерный седан премиального класса, являющийся самой продаваемой моделью в «конюшне» немецкого автоконцерна Daimler. Mercedes С-класса был и остаётся одним из самых востребованных и технологичных автомобилей в своём классе. Это автомобиль, предлагающий своему обладателю первоклассный салон, вместительный багажный отсек, отменную управляемость и максимальный уровень комфорта
"""
            ))
        }
        return model
    }
    
    static func makeMockVipModel() -> [CarModel] {
        var model = [CarModel]()
        for _ in 0...10 {
            model.append(CarModel(
                marka: "Mercedes",
                model: "G500",
                age: 2019,
                personPrice: 40000,
                commercialPriceWithNDS: 50000,
                commercialPriceWithoutNDS: 49500,
                driverPriceImMoscow: 2000,
                driverPriceInOblast: 3000,
                previewImage: UIImage(named: "mercedesG500")!,
                engineVolume: "422 л.с",
                numberOfSeats: 5,
                frontDrive: "Полный",
                transmission: "Автомат",
                numberOfDoors: 5,
                hasConditioner: true,
                allImages: [],
                description: """
Внешне от исходного Гелендвагена новый Mercedes-Benz G500 выделяется передним бампером от G63 AMG, светодиодными полосками на щитке над лобовым стеклом, расширенными колесными арками, серьезно возросшим дорожным просветом (клиренс увеличен с 210 до 450 мм) и вседорожными покрышками размерностью 325/55R22. В движение Mercedes G500 приводит 4,0-литровый V8 twin-turbo, который позаимствовали от купе Mercedes-AMG GT. На внедорожнике он выдает 422 л.с. и сочетается в паре с 7-диапазонной автоматической коробкой передач 7G-tronic с раздаткой и понижайкой.
В салоне Mercedes-Benz G500 щеголяет эксклюзивной отделкой со вставками из микрофибры. Дорого и дерзко, рекомендуем бронировать данный автомобиль заранее.
"""
            ))
        }
        return model
    }
}
