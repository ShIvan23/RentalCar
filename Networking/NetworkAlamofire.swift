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
            case 401:
                let message = response.value?.message ?? "Текст ошибки пустой"
                completion(.failure(AppError.error401(message: message)))
            case 422:
                let message = response.value?.message ?? "Текст ошибки пустой"
                completion(.failure(AppError.error422(message: message)))
            default:
                // TODO: - Убрать из продакшена
                #if DEBUG
                debugPrint("Ошибка отличная от 422. Надо обработать")
                debugPrint("code = \(code)")
                assertionFailure()
                #endif
                 break
            }
        }
    }
    
    func postImages<T>(_ images: [Data], stringUrl: String, progress: @escaping ((Double) -> Void), completion: @escaping (Result<T, AppError>) -> Void) where T : Decodable {
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Accept" : "*/*",
            "Authorization" : "Bearer \(AppState.shared.token)"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            images.forEach { imageData in
                multipartFormData.append(imageData, withName: "documents[]", fileName: "image.png", mimeType: "image/png")
                
            }
        },
                  to: stringUrl,
                  method: .post,
                  headers: header)
        .uploadProgress(closure: { prog in
            progress(prog.fractionCompleted)
        })
        .responseDecodable(of: APIValue<T>.self) { response in
            
            guard let code = response.response?.statusCode else { return }
            
            switch code {
            case 200...299:
                guard let value = response.value?.data else { return }
                completion(.success(value))
            case 422:
                let message = response.value?.message ?? "Текст ошибки пустой"
                completion(.failure(AppError.error422(message: message)))
            case 500:
                let message = response.value?.message ?? "Текст ошибки пустой"
                completion(.failure(AppError.error500(message: message)))
            default:
                // TODO: - Убрать из продакшена
#if DEBUG
                debugPrint("Ошибка отличная от 422 и 500. Надо обработать")
                assertionFailure()
#endif
                break
            }
        }
    }
}
