//
//  RentalManager.swift
//  RentalCar
//
//  Created by Ivan on 11.03.2022.
//

import Alamofire
import Foundation
import UIKit

protocol RentalManager {
    func fetchCars(completion: @escaping (Result<CarsModel, Error>) -> Void)
    func postOrder(order: Order, completion: @escaping (Result<OrderResult, Error>) -> Void)
    func fetchPromos(completion: @escaping (Result<Promos, Error>) -> Void)
    func postRegisterUser(user: UserRegister, completion: @escaping (Result<RegisterResult, Error>) -> Void)
    func postConfirmUser(user: UserConfirm, completion: @escaping (Result<UserConfirmResult, Error>) -> Void)
    func postAgainConfirmCode(user: AgainConfirmCode, completion: @escaping (Result<AgainConfirmCodeResult, Error>) -> Void)
    func login(user: Login, completion: @escaping (Result<LoginResult, Error>) -> Void)
    func logout(completion: @escaping (Result<Logout, Error>) -> Void)
    func postChangePwassword(password: ChangePassword, completion: @escaping (Result<ChangePasswordResult, AppError>) -> Void)
    func postDropPassword(email: DropPassword, completion: @escaping (Result<DropPasswordResult, AppError>) -> Void)
}

final class RentalManagerImp: RentalManager {
    
    private let networkManager: NetworkManager = NetworkManagerImp()
    private let networkAlamofire: NetworkManager = NetworkAlamofire()
    private let requestManager: RequestManager = RequestManagerImp()
    
    func fetchCars(completion: @escaping (Result<CarsModel, Error>) -> Void) {
        guard let request = requestManager.getAllAuto() else { return }
        networkManager.fetch(request: request, completion: completion)
    }
    
    func postOrder(order: Order, completion: @escaping (Result<OrderResult, Error>) -> Void) {
        guard let request = requestManager.postOrder(body: order) else { return }
        networkManager.fetch(request: request, completion: completion)
    }
    
    func fetchPromos(completion: @escaping (Result<Promos, Error>) -> Void) {
        guard let request = requestManager.getPromos() else { return }
        networkManager.fetch(request: request, completion: completion)
    }
    
    func postRegisterUser(user: UserRegister, completion: @escaping (Result<RegisterResult, Error>) -> Void) {
        guard let request = requestManager.postUserRegister(body: user) else { return }
        networkManager.fetch(request: request, completion: completion)
    }
    
    func postConfirmUser(user: UserConfirm, completion: @escaping (Result<UserConfirmResult, Error>) -> Void) {
        guard let request = requestManager.postUserConfirm(body: user) else { return }
        networkManager.fetch(request: request, completion: completion)
    }
    
    func postAgainConfirmCode(user: AgainConfirmCode, completion: @escaping (Result<AgainConfirmCodeResult, Error>) -> Void) {
        guard let request = requestManager.postAgainConfirmCode(body: user) else { return }
        networkManager.fetch(request: request, completion: completion)
    }
    
    func login(user: Login, completion: @escaping (Result<LoginResult, Error>) -> Void) {
        guard let request = requestManager.postLogin(body: user) else { return }
        networkManager.fetch(request: request, completion: completion)
    }
    
    func postImages(_ images: [UIImage], completion: @escaping (DataResponse<PostImagesResult, AFError>) -> Void) {
        let stringUrl = requestManager.postDocuments()
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Accept" : "*/*",
            "Authorization" : "Bearer \(AppState.shared.token)"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            images.forEach { image in
                guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
                multipartFormData.append(imageData, withName: "documents", fileName: "brbr.jpeg", mimeType: "image/jpeg")
                
            }
        },
                  to: stringUrl,
                  usingThreshold: UInt64(),
                  method: .post,
                  headers: header)
        .uploadProgress(queue: .main, closure: { progress in
            print("Upload progress = \(progress.fractionCompleted)")
        })
        .responseDecodable(completionHandler: completion)
    }
    
    func logout(completion: @escaping (Result<Logout, Error>) -> Void) {
        guard let request = requestManager.postLogout() else { return }
        networkManager.fetch(request: request, completion: completion)
    }
    
    func postChangePwassword(password: ChangePassword, completion: @escaping (Result<ChangePasswordResult, AppError>) -> Void) {
        guard let request = requestManager.postChangePassword(body: password) else { return }
        networkAlamofire.fetch(request: request, completion: completion)
    }
    
    func postDropPassword(email: DropPassword, completion: @escaping (Result<DropPasswordResult, AppError>) -> Void) {
        guard let request = requestManager.postDropPasswoed(body: email) else { return }
        networkAlamofire.fetch(request: request, completion: completion)
    }
}
