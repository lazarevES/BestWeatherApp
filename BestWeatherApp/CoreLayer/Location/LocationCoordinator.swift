//
//  LocationCoordinator.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 20.08.2022.
//

import Foundation
import CoreLocation
import UIKit

class LocationCoordinator: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    private var onBoardingIsAppear = false
    private var status: StatusApp
    weak var rootViewController: UIViewController?
    var callback: (()->Void)?
    
    override init() {
        
        if locationManager.authorizationStatus != .denied
            && locationManager.authorizationStatus != .notDetermined {
            self.status = .geoAccept
        } else if locationManager.authorizationStatus == .notDetermined {
            self.status = .onBoard
        } else {
            self.status = .geoReject
        }
        
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func GetGeoStatus() -> Bool? {
        
        switch status {
        case .onBoard:
            if let rootViewController = self.rootViewController {
                let onBoarding = OnBoardingViewController() { [weak self] in
                    if let self = self {
                        if self.locationManager.authorizationStatus == .denied
                            || self.locationManager.authorizationStatus == .notDetermined {
                            self.status = .geoReject
                        }
                    }
                }
                onBoarding.coordinator = self
                self.onBoardingIsAppear = true
                rootViewController.navigationController?.present(onBoarding, animated: true)
            } else {
                return false
            }
            return nil
        case .geoReject:
            return false
        case .geoAccept:
           return true
        }
    }
    
    func GetGeoPosition() {
        locationManager.startUpdatingLocation()
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
            self.rootViewController?.navigationController?.dismiss(animated: true)
            self.onBoardingIsAppear = false
            if let callback = callback {
                callback()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count == 0 {
            return
        }
        locationManager.stopUpdatingLocation()
        let coordinates = locations[0]
        
        let userInfo = ["coordinates": coordinates]
        NotificationCenter.default.post(name: .foundCityLocation, object: nil, userInfo: userInfo)
    }
    
}
