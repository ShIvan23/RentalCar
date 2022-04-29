//
//  AppState.swift
//  RentalCar
//
//  Created by Ivan on 16.04.2022.
//

import Foundation

protocol AppStateProtocol {
    var wasSentRegisterCode: Bool { get }
    var wasFinishedRegistration: Bool { get }
    var userWasLogin: Bool { get }
    
    var userEmail: String { get set }
    
    var token: String { get }
    var refreshToken: String { get }
    
    func saveToUserDefaults(key: AppStateKeys, value: Bool)
    func saveTokens(model: LoginResult)
    func removeTokens()
}

enum AppStateKeys: String {
    case wasSentRegisterCodeKey
    case wasFinishedRegistration
    case userWasLogin
}

enum TokenKeys: String {
    case token
    case refreshToken
}

final class AppState: AppStateProtocol {
    
    static var shared: AppStateProtocol = AppState()
    
    private init() {
       // goToDefault()
        loadFromUserDefaults()
    }
    
    /// States
    var wasSentRegisterCode: Bool = false
    var wasFinishedRegistration: Bool = false
    var userWasLogin: Bool = false
    
    /// User email
    var userEmail: String = ""
    
    /// Tokens
    var token: String = ""
    var refreshToken: String = ""
    
    func saveTokens(model: LoginResult) {
        token = model.data.token
        refreshToken = model.data.refreshToken
        saveTokens()
    }
    
    func removeTokens() {
        let userDefaults = UserDefaults.standard
        
        token = ""
        refreshToken = ""
        userDefaults.removeObject(forKey: TokenKeys.token.rawValue)
        userDefaults.removeObject(forKey: TokenKeys.refreshToken.rawValue)
    }
    
    func saveToUserDefaults(key: AppStateKeys, value: Bool) {
        let userDefaults = UserDefaults.standard
        
        switch key {
        case .wasSentRegisterCodeKey:
            wasSentRegisterCode = value
            userDefaults.setValue(value, forKey: AppStateKeys.wasSentRegisterCodeKey.rawValue)
            
        case .wasFinishedRegistration:
            wasFinishedRegistration = value
            userDefaults.set(value, forKey: AppStateKeys.wasFinishedRegistration.rawValue)
            
        case .userWasLogin:
            userWasLogin = value
            userDefaults.set(value, forKey: AppStateKeys.userWasLogin.rawValue)
        }
    }
    
    private func saveTokens() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.setValue(token, forKey: TokenKeys.token.rawValue)
        userDefaults.setValue(refreshToken, forKey: TokenKeys.refreshToken.rawValue)
    }
    
    private func loadFromUserDefaults() {
        let userDefaults = UserDefaults.standard
        
        wasSentRegisterCode = userDefaults.bool(forKey: AppStateKeys.wasSentRegisterCodeKey.rawValue)
        wasFinishedRegistration = userDefaults.bool(forKey: AppStateKeys.wasFinishedRegistration.rawValue)
        userWasLogin = userDefaults.bool(forKey: AppStateKeys.userWasLogin.rawValue)
        
        token = userDefaults.string(forKey: TokenKeys.token.rawValue) ?? ""
        refreshToken = userDefaults.string(forKey: TokenKeys.refreshToken.rawValue) ?? ""
    }
    
    // For tests
    
    private func goToDefault() {
        saveToUserDefaults(key: AppStateKeys.wasSentRegisterCodeKey, value: false)
    }
}
