//
//  NSMutableAttributedString+Extension.swift
//  RentalCar
//
//  Created by Ivan on 10.02.2022.
//

import UIKit

extension NSMutableAttributedString {
    func setFont(font: UIFont, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(
            NSAttributedString.Key.font,
            value: font,
            range: range
        )
    }
}

extension Array {
    func makeAttributedString(stringArray: [String]) -> [NSMutableAttributedString] {
        let forMutableArray = ["Объем двигателя:", "Кол-во мест:", "Привод:", "Год выпуска:", "Коробка:", "Кол-во дверей:", "Кондиционер:", "Описание автомобиля:"]
        var mutableAttributedStrings = [NSMutableAttributedString]()
        for (index, string) in stringArray.enumerated() {
            let mutableAttributedString = NSMutableAttributedString(string: forMutableArray[index] + " " + string)
            mutableAttributedString.setFont(font: .boldSystemFont(ofSize: 20), forText: forMutableArray[index])
            mutableAttributedStrings.append(mutableAttributedString)
        }
        return mutableAttributedStrings
    }
}