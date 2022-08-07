//
//  NetworkService.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 31.07.2022.
//

import Foundation
import CoreLocation

enum NetworkError: Error {
    case `default`
    case serverError
    case parseError(reason: String)
    case unknownError
}

protocol NetworkServiceProtocol {
    func request(location: CLLocation, completion: @escaping (Result<City, NetworkError>) -> Void)
    func request(city: City, completion: @escaping (Result<City, NetworkError>) -> Void)
}

final class NetworkService {
    
    private let mainQueue = DispatchQueue.main
}

extension NetworkService: NetworkServiceProtocol {
    func request(city: City, completion: @escaping (Result<City, NetworkError>) -> Void) {
        
        let stringURL = "https://api.weather.yandex.ru/v2/forecast?lat=" + city.lat + "&lon=" + city.lon + "&extra=true&hours=true"
        let url = URL(string: stringURL)
        if let url = url {
            var request = URLRequest(url: url)
            request.addValue("f8652bbe-960b-4bf2-ad2d-caee5f61c5c0", forHTTPHeaderField: "X-Yandex-API-Key")
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, response, error in
                
                guard error == nil else {
                    completion(.failure(.default))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.unknownError))
                    return
                }
                
                let wheather = self?.decodeWithDecoder(data)
                
                if let wheather = wheather {
                    city.wheather = wheather
                    city.wheather?.setupParent(city)
                    completion(.success(city))
                } else {
                    completion(.failure(.parseError(reason: "Ошибка декодинга json")))
                }
            })
            
            task.resume()
        }
    }
    
    func request(location: CLLocation, completion: @escaping (Result<City, NetworkError>) -> Void) {
        
        let stringURL = "https://geocode-maps.yandex.ru/1.x?apikey=1c2c0a14-73c0-4a9f-a447-0bf7be0dfb59&format=json&geocode=" + String(location.coordinate.longitude) + "," + String(location.coordinate.latitude)
       
        let url = URL(string: stringURL)
        if let url = url {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
                
                guard error == nil else {
                    completion(.failure(.default))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.unknownError))
                    return
                }
                
                let city = self?.decodeWithSerializator(data)
                
                if let city = city {
                    completion(.success(city))
                } else {
                    completion(.failure(.parseError(reason: "Ошибка сериализации json")))
                }
            })
            task.resume()
        }
    }

    func decodeWithSerializator(_ data: Data) -> City? {
        
        do {
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> else { return nil }
            guard let response = dictionary["response"] as? [String: Any] else { return nil }
            guard let geoObjectCollection = response["GeoObjectCollection"] as? [String: Any] else { return nil }
            guard let featureMember = geoObjectCollection["featureMember"] as? [[String: Any]] else { return nil }
            guard let geoObject = featureMember[0]["GeoObject"] as? [String: Any] else { return nil }
            guard let metaDataProperty = geoObject["metaDataProperty"] as? [String: Any] else { return nil }
            guard let geocoderMetaData = metaDataProperty["GeocoderMetaData"] as? [String: Any] else { return nil }
            guard let addressDetails = geocoderMetaData["AddressDetails"] as? [String: Any] else { return nil }
            guard let country = addressDetails["Country"] as? [String: Any] else { return nil }
            guard let administrativeArea = country["AdministrativeArea"] as? [String: Any]  else { return nil }
            guard let subAdministrativeArea = administrativeArea["SubAdministrativeArea"] as? [String: Any]  else { return nil }
           
            var localityName = ""
            if let locality = subAdministrativeArea["Locality"] as? [String: Any]  {
                localityName = locality["LocalityName"] as? String ?? ""
            } else {
                localityName = subAdministrativeArea["SubAdministrativeAreaName"] as? String  ?? ""
            }
            
            if localityName == "" {
                return nil
            }
            
            guard let Point = geoObject["Point"] as? [String: Any]  else { return nil }
            guard let id = geoObject["description"] as? String else { return nil }
            guard let countryName = country["CountryName"] as? String else { return nil }
            guard let Pos = Point["pos"] as? String  else { return nil }
            
            let PosArr = Pos.components(separatedBy: " ")
            
            let lon = PosArr[0]
            let lat = PosArr[1]
            
            let city = City(id: id, name: localityName, country: countryName, lat: lat, lon: lon)
            
            return city
            
        } catch {
            return nil
        }
    }
    
    func decodeWithDecoder(_ data: Data) -> Wheather? {
        do {
            let decoder = JSONDecoder()
            let decodeData = try decoder.decode(Wheather.self, from: data)
            return decodeData
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
