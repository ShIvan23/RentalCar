//
//  NetworkManager.swift
//  RentalCar
//
//  Created by Ivan on 10.03.2022.
//

import Foundation

typealias JSONCompletionHandler = (Data?, HTTPURLResponse?, Error?) -> Void

protocol NetworkManager {
    func fetch<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
    func fetch<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, AppError>) -> Void)
    func postImages<T: Decodable>(_ images: [Data], stringUrl: String, completion: @escaping (Result<T, AppError>) -> Void)
}

extension NetworkManager {
    func fetch<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {}
    func fetch<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, AppError>) -> Void) {}
    func postImages<T: Decodable>(_ images: [Data], stringUrl: String, completion: @escaping (Result<T, AppError>) -> Void) {}
}

final class NetworkManagerImp: NetworkManager {
    
    private let sessionConfiguration = URLSessionConfiguration.default
    private lazy var session = URLSession(configuration: sessionConfiguration)
    
    func fetch<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        
        let dataTask = JSONTask(request: request) { [weak self] data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                let unownedError = NSError()
                completion(.failure(unownedError))
                return
            }
            
            if let value = self?.decodeJSON(type: T.self, from: data) {
                completion(.success(value))
            } else {
                let error = NSError()
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    private func JSONTask(request: URLRequest, completion: @escaping JSONCompletionHandler) -> URLSessionTask {
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            guard let HTTPResponse = response as? HTTPURLResponse else {
                let error = error
                completion(nil, nil, error)
                return
            }
            
            switch HTTPResponse.statusCode {
            case 200:
                completion(data, HTTPResponse, nil)
            case 422:
                print("error = \(error)")
                completion(data, HTTPResponse, error)
            default:
                completion(data, HTTPResponse, error)
            }
        }
        return dataTask
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        
        let decoder = JSONDecoder()
        
        guard let data = from else { return nil }
        
        do {
            let object = try decoder.decode(T.self, from: data)
            return object
        }
        
        catch DecodingError.dataCorrupted(let context) {
            print(DecodingError.dataCorrupted(context))
        } catch DecodingError.keyNotFound(let key, let context) {
            print(DecodingError.keyNotFound(key,context))
        } catch DecodingError.typeMismatch(let type, let context) {
            print(DecodingError.typeMismatch(type,context))
        } catch DecodingError.valueNotFound(let value, let context) {
            print(DecodingError.valueNotFound(value,context))
        } catch let error{
            print(error)
        }
        return nil
    }
}
