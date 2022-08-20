//
//  PageViewCoordinator.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 30.07.2022.
//

import Foundation
import UIKit
import CoreLocation

final class PageViewCoordinator {
    
    private let locationCoordinator = LocationCoordinator()
    private var dataBaseCoordinator: CoreDataProtocol
    private var networkService: NetworkServiceProtocol
    weak var pageViews: PageViewController?
    
    init(coreDataCoordinator: CoreDataProtocol) {
        
        self.dataBaseCoordinator = coreDataCoordinator
        self.networkService = NetworkService()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(foundCityLocation(_:)),
                                               name: .foundCityLocation,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    func GetGeoStatus() {
        if locationCoordinator.GetGeoStatus() == true {
            locationCoordinator.GetGeoPosition()
        }
    }
    
    @objc func foundCityLocation(_ notification: NSNotification) {
        if let location = notification.userInfo?["coordinates"] as? CLLocation {
            DispatchQueue.global().async {
                self.foundCityData(location: location)
            }
        }
    }
        
    func foundCityData(location: CLLocation) {
        
        networkService.request(location: location) {[weak self] result in
            switch result {
            case .success(let city):
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
        networkService.request(city: city) {[weak self] result in
            switch result {
            case .success(let city):
                self?.saveToDataBase(city: city)
            case .failure(let error):
                print(error)
                self?.pageViews?.updateCity(city)
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
    
    func removeFromDatabase(city: City) {
        let predicate = NSPredicate(format: "id == %@", argumentArray: [city.id])
        dataBaseCoordinator.delete(predicate: predicate) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            default:
                break
            }
        }
    }
}

