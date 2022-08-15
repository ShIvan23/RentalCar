//
//  EventName.swift
//  RentalCar
//
//  Created by Ivan on 11.08.2022.
//

import Foundation

enum EventName: String {
    case
    orderButton = "Кнопка заказать",
    paymentButton = "Кнопка оплатить",
    userHasRegistered = "Зарегистрировался",
    userHasConfirnedCode = "Подтвердил код регистрации",
    userHasDeletedAccount = "Удалил аккаунт",
    userHasLogout = "Разлогинился",
    userHasSentDocuments = "Отправил документы",
    callButtonTapped = "Кнопка позвонить нам",
    searchCarTapped = "Кнопка поиск машины",
    vipTapped = "Категория VIP",
    businessTapped = "Категория бизнес",
    comfortTapped = "Категория комфорт",
    standartTapped = "Категория стандарт",
    userTappedCar = "Выбрал машину",
    sendOrderButton = "Отправил заказ",
    orderComment = "Комментарий к заказу",
    personTapped = "Вкладка физ лица",
    commercialTapped = "Вкладка юр лица",
    promoTapped = "Вкладка акции",
    conditionTapped = "Вкладка условия",
    contactTapped = "Вкладка контакты",
    withNDSTapped = "С НДС",
    withoutNDSTapped = "Без НДС",
    permanentPromo = "Постоянные акции",
    promoOfMonth = "Акции месяца",
    tappedDetailPromo = "Детальная инфа по акции",
    personCondition = "Условия для физ лиц",
    commercialCondition = "Условия для юр лиц",
    adressCopied = "Скопировал адрес",
    emailCopied = "Скопировал почту",
    goToWhatsApp = "Переход в WhatsApp",
    goToTelegramm = "Переход в Телеграм"
}
