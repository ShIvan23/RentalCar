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
    
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }
}

extension Array {
    func makeAttributedString(stringArray: [String]) -> [NSMutableAttributedString] {
        let forMutableArray = ["Цена:", "Цена водителя:", "Объем двигателя:", "Кол-во мест:", "Привод:", "Год выпуска:", "Коробка:", "Кол-во дверей:"]
        var mutableAttributedStrings = [NSMutableAttributedString]()
        for (index, string) in stringArray.enumerated() {
            if stringArray[index].isEmpty {
                continue
            }
            let mutableAttributedString = NSMutableAttributedString(string: forMutableArray[index] + " " + string + (index == 0 ? " ₽ / сутки" : "") + (index == 1 ? " ₽ / час" : ""))
            mutableAttributedString.setFont(font: .boldSystemFont(ofSize: 20), forText: forMutableArray[index])
            mutableAttributedStrings.append(mutableAttributedString)
        }
        return mutableAttributedStrings
    }
}
