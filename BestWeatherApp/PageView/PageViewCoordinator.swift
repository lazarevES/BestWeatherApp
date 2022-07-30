//
//  PageViewCoordinator.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 30.07.2022.
//

import Foundation
import UIKit
import CoreLocation

final class PageViewCoordinator: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    private var status: StatusApp
    private var dataBaseCoordinator: CoreDataProtocol
    private var networkService: NetworkServiceProtocol
    weak var pageViews: PageViewController?
    
    
    override init() {
        
        if locationManager.authorizationStatus != .denied
            && locationManager.authorizationStatus != .notDetermined {
            self.status = .geoAccept
        } else if locationManager.authorizationStatus == .notDetermined {
            self.status = .onBoard
        } else {
            self.status = .geoReject
        }
        
        print(locationManager.authorizationStatus.rawValue)
        
        self.dataBaseCoordinator = CoreDataCoordinator.CreateDataBase()
        self.networkService = NetworkService()
        
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func GetGeoStatus() {
        
        switch status {
        case .onBoard:
            
            if !pageViews!.isAppear {
                break
            }
            
            let onBoarding = OnBoardingViewController() { [weak self] in
                if let self = self {
                    if self.locationManager.authorizationStatus == .denied
                        || self.locationManager.authorizationStatus == .notDetermined {
                        self.status = .geoReject
                    }
                    print(self.locationManager.authorizationStatus.rawValue)
                }
            }
            onBoarding.coordinator = self
            pageViews?.navigationController?.present(onBoarding, animated: true)
            
        case .geoReject:
            print(self.locationManager.authorizationStatus.rawValue)
            return
        case .geoAccept:
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        pageViews?.navigationController?.dismiss(animated: true)
        
        if self.locationManager.authorizationStatus == .denied {
            self.status = .geoReject
        } else if self.locationManager.authorizationStatus == .notDetermined {
            self.status = .onBoard
        } else {
            self.status = .geoAccept
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count == 0 {
            return
        }
        
        do {
            let coordinates = locations[0]
            locationManager.stopUpdatingLocation()
            foundCityData(location: coordinates)
        }  catch {
            return
        }
    }
    
    func loadingViewControllers() {
        
        if status == .onBoard {
            return
        }
        
        print("грузим контроллеры")
    }
    
    func foundCityData(location: CLLocation) {
        
        let stringURL = "https://geocode-maps.yandex.ru/1.x?apikey=1c2c0a14-73c0-4a9f-a447-0bf7be0dfb59&format=json&geocode=" + String(location.coordinate.longitude) + "," + String(location.coordinate.latitude)
        let url = URL(string: stringURL)
        if let url = url {
            networkService.request(url: url) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
                        self.parseCityByCoordinates(dictionary)
                        
                    } catch let error {
                        if let error = error as? NetworkError {
                            print(error.localizedDescription)
                        } else {
                            print("Не известная ошибка")
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                    
                }
            }
        }
    }
    
    func parseCityByCoordinates(_ dictionary: [String: Any]) {
        guard let response = dictionary["response"] as? [String: Any] else { return }
        guard let geoObjectCollection = response["GeoObjectCollection"] as? [String: Any] else { return }
        guard let featureMember = geoObjectCollection["featureMember"] as? [[String: Any]] else { return }
        guard let geoObject = featureMember[0]["GeoObject"] as? [String: Any] else { return }
        guard let metaDataProperty = geoObject["metaDataProperty"] as? [String: Any] else { return }
        guard let geocoderMetaData = metaDataProperty["GeocoderMetaData"] as? [String: Any] else { return }
        guard let addressDetails = geocoderMetaData["AddressDetails"] as? [String: Any] else { return }
        guard let country = addressDetails["Country"] as? [String: Any] else { return }
        guard let administrativeArea = country["AdministrativeArea"] as? [String: Any]  else { return }
        guard let subAdministrativeArea = administrativeArea["SubAdministrativeArea"] as? [String: Any]  else { return }
        guard let locality = subAdministrativeArea["Locality"] as? [String: Any]  else { return }
        guard let Point = geoObject["Point"] as? [String: Any]  else { return }
        
        
        guard let localityName = locality["LocalityName"] as? String  else { return }
        guard let countryName = country["CountryName"] as? String else { return }
        guard let Pos = Point["pos"] as? String  else { return }
        
        let PosArr = Pos.components(separatedBy: " ")
        
        let lon = PosArr[0]
        let lat = PosArr[1]
        
        let city = City(name: localityName, description: countryName, lat: lat, lon: lon)
        
        if let pageViews = self.pageViews {
            if pageViews.city.contains(city) {
                DispatchQueue.main.async {
                    pageViews.activeViewController(city)
                }
            } else {
                self.downloadingWheatherData(city: city)
            }
        }
    }
    
    func downloadingWheatherData(city: City) {
        
        let stringURL = "https://api.weather.yandex.ru/v2/forecast?lat=" + city.lat + "&lon=" + city.lon + "&extra=true"
        let url = URL(string: stringURL)
        if let url = url {
            var request = URLRequest(url: url)
            request.addValue("f8652bbe-960b-4bf2-ad2d-caee5f61c5c0", forHTTPHeaderField: "X-Yandex-API-Key")
            networkService.request(request: request) { [weak self, city]  result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let decodeData = try decoder.decode(Wheather.self, from: data)
                        self.saveWheather(city: city, wheather: decodeData)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                    
                }
            }
        }
    }
    
    func saveWheather(city: City, wheather: Wheather) {
        
        //День 1 тут я заебался!
        
    }
}

