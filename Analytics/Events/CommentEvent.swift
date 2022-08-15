//
//  CommentEvent.swift
//  RentalCar
//
//  Created by Ivan on 11.08.2022.
//

import Foundation

enum CommentEvent: AnalyticProtocol {
    
    var name: String { return "Комментарий к заказу" }
    var param: String { return value }
    
    case comment(text: String)
    
    var value: String {
        switch self {
        case .comment(let text):
            return text
        }
    }
}
