//
//  AnalyticEvent.swift
//  RentalCar
//
//  Created by Ivan on 11.08.2022.
//

import Foundation

enum AnalyticEvent {
    case
    orderButtonTapped,
    paymentButtonTapped,
    userHasRegistered,
    userHasConfirnedCode,
    userHasDeletedAccount,
    userHasLogout,
    userHasSentDocuments,
    callButtonTapped,
    searchCarTapped,
    vipTapped,
    businessTapped,
    comfortTapped,
    standartTapped,
    userTappedCar(car: String),
    sendOrderButton,
    orderComment(comment: String),
    personTapped,
    commercialTapped,
    promoTapped,
    conditionTapped,
    contactTapped,
    withNDSTapped,
    withoutNDSTapped,
    permanentPromo,
    promoOfMonth,
    tappedDetailPromo,
    personCondition,
    commercialCondition,
    adressCopied,
    emailCopied,
    goToWhatsApp,
    goToTelegramm
}

extension AnalyticEvent {
    static private var userId = UserId.shared
    
    private var parameters: [AnalyticProtocol] {
        return [
            AnalyticEvent.userId,
            EventDate.date
        ]
    }
    
    func send() {
        switch self {
        case .orderButtonTapped:
            Logger.logEvent(.orderButton, parameters: parameters)
        case .paymentButtonTapped:
            Logger.logEvent(.paymentButton, parameters: parameters)
        case .userHasRegistered:
            Logger.logEvent(.userHasRegistered, parameters: parameters)
        case .userHasConfirnedCode:
            Logger.logEvent(.userHasConfirnedCode, parameters: parameters)
        case .userHasDeletedAccount:
            Logger.logEvent(.userHasDeletedAccount, parameters: parameters)
        case .userHasLogout:
            Logger.logEvent(.userHasLogout, parameters: parameters)
        case .userHasSentDocuments:
            Logger.logEvent(.userHasSentDocuments, parameters: parameters)
        case .callButtonTapped:
            Logger.logEvent(.callButtonTapped, parameters: parameters)
        case .searchCarTapped:
            Logger.logEvent(.searchCarTapped, parameters: parameters)
        case .vipTapped:
            Logger.logEvent(.vipTapped, parameters: parameters)
        case .businessTapped:
            Logger.logEvent(.businessTapped, parameters: parameters)
        case .comfortTapped:
            Logger.logEvent(.comfortTapped, parameters: parameters)
        case .standartTapped:
            Logger.logEvent(.standartTapped, parameters: parameters)
        case let .userTappedCar(car):
            Logger.logEvent(.userTappedCar, parameters: parameters + [CarNameEvent.selectedCar(car)])
        case .sendOrderButton:
            Logger.logEvent(.sendOrderButton, parameters: parameters)
        case let .orderComment(comment):
            Logger.logEvent(.orderComment, parameters: parameters + [CommentEvent.comment(text: comment)])
        case .personTapped:
            Logger.logEvent(.personTapped, parameters: parameters)
        case .commercialTapped:
            Logger.logEvent(.commercialTapped, parameters: parameters)
        case .promoTapped:
            Logger.logEvent(.promoTapped, parameters: parameters)
        case .conditionTapped:
            Logger.logEvent(.conditionTapped, parameters: parameters)
        case .contactTapped:
            Logger.logEvent(.contactTapped, parameters: parameters)
        case .withNDSTapped:
            Logger.logEvent(.withNDSTapped, parameters: parameters)
        case .withoutNDSTapped:
            Logger.logEvent(.withoutNDSTapped, parameters: parameters)
        case .permanentPromo:
            Logger.logEvent(.permanentPromo, parameters: parameters)
        case .promoOfMonth:
            Logger.logEvent(.promoOfMonth, parameters: parameters)
        case .tappedDetailPromo:
            Logger.logEvent(.tappedDetailPromo, parameters: parameters)
        case .personCondition:
            Logger.logEvent(.personCondition, parameters: parameters)
        case .commercialCondition:
            Logger.logEvent(.commercialCondition, parameters: parameters)
        case .adressCopied:
            Logger.logEvent(.adressCopied, parameters: parameters)
        case .emailCopied:
            Logger.logEvent(.emailCopied, parameters: parameters)
        case .goToWhatsApp:
            Logger.logEvent(.goToWhatsApp, parameters: parameters)
        case .goToTelegramm:
            Logger.logEvent(.goToTelegramm, parameters: parameters)
        }
    }
}
