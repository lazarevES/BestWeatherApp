//
//  Settings.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 11.08.2022.
//

import Foundation

protocol SettingsProtocol {
    var rawValue: Int { get }
}

class Settings {
    
    static let sharedSettings = Settings()
            
    var temp: Temp {
        didSet {
            saveValue(value: temp, key: "temp")
        }
    }
    
    var speed: Speed {
        didSet {
            saveValue(value: speed, key: "speed")
        }
    }
    
    var time: Time {
        didSet {
            saveValue(value: time, key: "time")
        }
    }
    
    var notifications: Notifications {
        didSet {
            saveValue(value: notifications, key: "notifications")
        }
    }
    
    private init() {
        let userDefaults = UserDefaults.standard
        temp = Temp.init(rawValue: userDefaults.integer(forKey: "temp"))  ?? .celsius
        speed = Speed.init(rawValue: userDefaults.integer(forKey: "speed"))  ?? .metric
        time = Time.init(rawValue: userDefaults.integer(forKey: "time"))  ?? .full
        notifications = Notifications.init(rawValue: userDefaults.integer(forKey: "notifications"))  ?? .off
    }
    
    func saveValue(value: SettingsProtocol, key: String) {
        UserDefaults.standard.set(value.rawValue, forKey: key)
    }
    
    enum Notifications: Int, SettingsProtocol {
        case off = 1
        case on = 0
    }
    
    enum Time: Int, SettingsProtocol {
        case full = 1
        case partial = 0
    }
    
    enum Speed: Int, SettingsProtocol {
        case metric = 0
        case imperium = 1
    }
    
    enum Temp: Int, SettingsProtocol {
        case celsius = 0
        case fahrenheit = 1
    }
    
}
