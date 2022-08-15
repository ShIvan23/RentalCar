//
//  UserId.swift
//  RentalCar
//
//  Created by Ivan on 11.08.2022.
//

import Foundation
import YandexMobileMetrica

final class UserId: AnalyticProtocol {
    
    var name: String = "ID юзера"
    var param: String = ""
    
    static let shared: AnalyticProtocol = UserId()
    
    private init() {
        checkUserId()
        setUserProfuleId()
    }
    
    private func generateUserId() {
        let uuid = UUID().uuidString
        param = uuid
        UserDefaults.standard.set(uuid, forKey: name)
    }
    
    private func checkUserId() {
        guard let userId = UserDefaults.standard.string(forKey: name) else {
            generateUserId()
            return
        }
        param = userId
    }
    
    private func setUserProfuleId() {
        let profile = YMMMutableUserProfile()
        profile.apply(from: [YMMProfileAttribute.customString(name).withValue(param)])
        YMMYandexMetrica.report(profile)
        YMMYandexMetrica.setUserProfileID(param)
    }
}
