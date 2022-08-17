//
//  DateFormatters+Extension.swift
//  RentalCar
//
//  Created by Ivan on 11.08.2022.
//

import Foundation

enum DateFormat: String {
    
    case shortTimeFormat = "HH:mm:ss"
    case defaultDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    case shortDateFormat = "yyyy-MM-dd"
    case shortDateWithPoint = "dd.MM.yyyy"
    case shortDateWithYear = "dd.MM.yy"
    case dayAndFullMonth = "d MMMM"
    case dayAndShortMonth = "d MMM"
    case dayAndMonth = "d MM"
    case dayMonthAndTime = "d MMMM, HH:mm"
    case time = "HH:mm"
    case imagePickerDateFormat = "yyyy:MM:dd HH:mm:ss"
    case documentPhotoDateFormat = "d.MM HH:mm"
    case detailTime = "H:mm:ss"
    case dayMonthYear = "d MMMM yyyy" // 1 апреля 2018
    case dayDotMonth = "dd.MM"
    case monthYear = "LLLL yyyy" // апрель 2018
    case standart = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case withWeekday = "EEEE, d MMMM"
    case day = "dd"
    case weekDay = "EEEE"
}

extension DateFormatter {
    static var formattersDictionary = [String: DateFormatter]()
    
    // MARK: - Methods
    
    class func formatter(dateFormat: DateFormat) -> DateFormatter {
        let formatString = dateFormat.rawValue
        guard let formatter = DateFormatter.formattersDictionary[formatString] else {
            
            let formatter = DateFormatter()
            
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = dateFormat.rawValue
            formatter.timeZone = .current
            DateFormatter.formattersDictionary[formatString] = formatter
            
            return formatter
        }
        return formatter
    }
}

extension Date {
    
    var milliseconds: Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    func string(dateFormat: DateFormat) -> String {
        let formatter = DateFormatter.formatter(dateFormat: dateFormat)
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: self)
    }
    
    func dayNumberOfWeek() -> Int {
        return Calendar(identifier: .gregorian).component(.weekday, from: self) - 1

    }
}

extension String {
    
    func date(dateFormat: DateFormat) -> Date? {
        let formatter = DateFormatter.formatter(dateFormat: dateFormat)
        return formatter.date(from: self)
    }
}
