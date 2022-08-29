//
//  City.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 30.07.2022.
//

import Foundation

protocol ValidateModel {
    var keyedValues: [String: Any] { get }
}

class City: ValidateModel {
    
    var id: String
    var name: String
    var country: String
    var lat: String
    var lon: String
    var isNew: Bool = true
    var wheather: Wheather? {
        didSet {
            if let wheather = wheather {
                wheather.setupParent(self)
            }
        }
    }
    
    var keyedValues: [String: Any] {
        return [
            "id": self.id,
            "name": self.name,
            "country": self.country,
            "lat": self.lat,
            "lon": self.lon,
            "wheather": self.wheather?.keyedValues ?? []
        ]
    }
    
    init(id: String, name: String, country: String, lat: String, lon: String) {
        self.name = name
        self.country = country
        self.lat = lat
        self.lon = lon
        self.id = id == "" ? name + "_" + country : id
    }
    
    init(_ city: CityModel) {
        self.name = city.name ?? ""
        self.country = city.country ?? ""
        self.lat = city.lat ?? ""
        self.lon = city.lon ?? ""
        self.id = city.id ?? ""
        self.id = self.id == "" ? self.name + "_" + self.country : self.id
        
        if let wheather = city.wheather {
            self.wheather = Wheather(wheather)
        }
        
        self.wheather?.setupParent(self)
    }
}

extension City: Equatable {
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
}

