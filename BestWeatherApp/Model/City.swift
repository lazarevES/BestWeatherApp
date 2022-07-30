//
//  City.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 30.07.2022.
//

import Foundation

class City: Equatable{
    
    var name: String
    var description: String
    var lat: String
    var lon: String
    
    var keyedValues: [String: Any] {
        return [
            "name": self.name,
            "description": self.description,
            "lat": self.lat,
            "lon": self.lon
        ]
    }
    
    public init(name: String, description: String, lat: String, lon: String) {
        self.name = name
        self.description = description
        self.lat = lat
        self.lon = lon
    }
    
    init(cityDBModel: CityDBModel) {
        self.name = cityDBModel.name!
        self.description = cityDBModel.country!
        self.lat = cityDBModel.lat!
        self.lon = cityDBModel.lon!
    }
    
    static func ==(lhs: City, rhs: City) -> Bool {
        return lhs.name == rhs.name && lhs.description == rhs.description
    }
    
}

