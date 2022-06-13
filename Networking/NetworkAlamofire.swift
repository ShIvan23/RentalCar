//
//  NetworkAlamofire.swift
//  RentalCar
//
//  Created by Ivan on 13.06.2022.
//

import Foundation
import Alamofire

final class NetworkAlamofire: NetworkManager {
    func fetch<T>(request: URLRequest, completion: @escaping (Result<T, AppError>) -> Void) where T : Decodable {
        let request = AF.request(request)
        
        request.responseDecodable(of: APIValue<T>.self) { response in
            
            guard let code = response.response?.statusCode else { return }
            
            switch code {
            case 200...299:
                guard let value = response.value?.data else { return }
                completion(.success(value))
            case 422:
                let message = response.value?.message ?? "Текст ошибки пустой"
                completion(.failure(AppError.error422(message: message)))
            default:
                // TODO: - Убрать из продакшена
                print("Ошибка отличная от 422. Надо обработать")
                fatalError()
                // break
            }
        }
    }
}
