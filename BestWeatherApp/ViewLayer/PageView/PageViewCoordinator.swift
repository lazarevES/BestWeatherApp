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
    private var onBoardingIsAppear = false
    
    override init() {
        
        if locationManager.authorizationStatus != .denied
            && locationManager.authorizationStatus != .notDetermined {
            self.status = .geoAccept
        } else if locationManager.authorizationStatus == .notDetermined {
            self.status = .onBoard
        } else {
            self.status = .geoReject
        }
        
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
                }
            }
            onBoarding.coordinator = self
            pageViews?.navigationController?.present(onBoarding, animated: true)
            self.onBoardingIsAppear = true
            
        case .geoReject:
            return
        case .geoAccept:
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
                
        if self.locationManager.authorizationStatus == .denied {
            self.status = .geoReject
        } else if self.locationManager.authorizationStatus == .notDetermined {
            self.status = .onBoard
        } else {
            self.status = .geoAccept
        }
        
        if onBoardingIsAppear {
            self.pageViews?.navigationController?.dismiss(animated: true)
            self.onBoardingIsAppear = false
            self.GetGeoStatus()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count == 0 {
            return
        }
        locationManager.stopUpdatingLocation()
        let coordinates = locations[0]
        DispatchQueue.global().async {
            self.foundCityData(location: coordinates)
        }
    }
    
    func loadingViewControllers() {
                
        let task = DispatchQueue.global(qos: .background)
        task.async {
            print("Начата загрузка из бд")
            self.dataBaseCoordinator.fetchAll { result in
                switch result {
                case .success(let CitysM):
                    
                    print("Загружено из бд")
                    let citys = CitysM.map { city -> City in
                        city.isNew = false
                        return city
                    }
                    
                    if citys.isEmpty {
                        break
                    }
                   
                    if let pageViews = self.pageViews {
                        citys.forEach { city in
                            
                            if !pageViews.citys.contains(city) {
                                pageViews.citys.append(city)
                            }
                        }
                        pageViews.activeViewController(citys.first!)
                    }
    
                case .failure(_):
                    break
                }
                print("Начато обновление гео статуса")
                self.GetGeoStatus()
            }
        }
        
        task.resume()
    }
    
    func foundCityData(location: CLLocation) {
        
        networkService.request(location: location) {[weak self] result in
            switch result {
            case .success(let city):
                print("Город найден")
                self?.addCityToPageView(city)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func foundCityData(name: String, _ callback: @escaping ([City]) -> Void) {
        
        networkService.request(name: name, completion: { result in
            switch result {
            case .success(let citys):
                print("Города найдены")
                DispatchQueue.main.async {
                    callback(citys)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func addCityToPageView(_ city: City) {
    
        if let pageViews = self.pageViews {
            
            if pageViews.citys.contains(city) {
                city.isNew = false
                print("Город уже есть")
                
                DispatchQueue.main.async {
                    let vs = pageViews.viewControllers?.first as? ViewControllerProtocol
                    if let vs = vs {
                        if vs.city != city && vs.isAppear {
                            pageViews.activeViewController(city)
                        }
                    }
                }
            } else {
                pageViews.citys.append(city)
                DispatchQueue.main.async {
                    pageViews.activeViewController(city)
                }
            }
            self.downloadingWheatherData(city: city)
        }
    }
    
    func downloadingWheatherData(city: City) {
        print("Начата загрузка погоды")
        networkService.request(city: city) {[weak self] result in
            switch result {
            case .success(let city):
                print("Погода загружена")
                self?.saveToDataBase(city: city)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func saveToDataBase(city: City) {
        if city.isNew {
            dataBaseCoordinator.create(city) { [weak self] result in
                switch result {
                case .success(let city):
                    city.isNew.toggle()
                    DispatchQueue.main.async {
                        self?.pageViews?.updateCity(city)
                    }
                    print("Сохранено в бд")
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }
        } else {
            let predicate = NSPredicate(format: "id == %@", argumentArray: [city.id])
            dataBaseCoordinator.update(city, predicate: predicate) { [weak self] result in
                switch result {
                case .success(let city):
                    DispatchQueue.main.async {
                        self?.pageViews?.updateCity(city)
                    }
                    print("Обновлено в бд")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getViewController(city: City?, index: Int) -> ViewControllerProtocol{
        if let city = city {
            let vc = WheatherViewController()
            vc.setupCity(city: city, index: index)
            vc.delegate = self
            return vc
        } else {
            return EmptyViewController()
        }
    }
}

