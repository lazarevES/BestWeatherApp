//
//  NetworkService.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 31.07.2022.
//

import Foundation

enum NetworkError: Error {
    case `default`
    case serverError
    case parseError(reason: String)
    case unknownError
}

protocol NetworkServiceProtocol {
    func request(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void)
    func request(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

final class NetworkService {
    
    private let mainQueue = DispatchQueue.main
}

extension NetworkService: NetworkServiceProtocol {
    
    func request(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard error == nil else {
                completion(.failure(.default))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }
            
            completion(.success(data))
        })
        
        task.resume()
    }
    
    func request(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                completion(.failure(.default))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }
            
            completion(.success(data))
        })
        
        task.resume()
    }
}
