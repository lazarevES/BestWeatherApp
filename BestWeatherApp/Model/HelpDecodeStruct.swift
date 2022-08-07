//
//  HelpDecodeStruct.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 07.08.2022.
//

import Foundation

struct Parts: Decodable {
    
    var dayShort: DayShort
    
    enum CodingKeys: String, CodingKey {
        case dayShort =  "day_short"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dayShort = try container.decode(DayShort.self, forKey: .dayShort)
    }
    
}

struct DayShort: Decodable {
    
    /// Средняя температура
    var temp: Int = 0
    
    ///  Минимальная температура
    var tempMin: Int = 0
    
    /// Ощущаемая температура
    var feelsLike: Int = 0
    
    /// Описание погоды
    var condition: String = ""
    
    /// Скорость ветра м/с
    var windSpeed: Double = 0
    
    /// Скорость порывов ветра м/с
    var windGust: Double = 0
    
    /// Направление ветра код
    var windDirKey: String = ""
    
    /// Влажность воздуха (в процентах)
    var humidity: Int = 0
    
    /// Тип осадков код
    var precTypeKey: Int = 0
    
    /// Сила осадков код
    var precStrengthKey: Double = 0
    
    /// Облачность код
    var cloudnessKey: Double = 0
    
    enum CodingKeys: String, CodingKey {
        case temp, condition, humidity
        case windSpeed =  "wind_speed"
        case tempMin =  "temp_min"
        case feelsLike =  "feels_like"
        case windDirKey = "wind_dir"
        case windGust = "wind_gust"
        case precTypeKey = "prec_type"
        case precStrengthKey = "prec_strength"
        case cloudnessKey = "cloudness"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decode(Int.self, forKey: .temp)
        self.condition = try container.decode(String.self, forKey: .condition)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        self.tempMin = try container.decode(Int.self, forKey: .tempMin)
        self.feelsLike = try container.decode(Int.self, forKey: .feelsLike)
        self.windDirKey = try container.decode(String.self, forKey: .windDirKey)
        self.windGust = try container.decode(Double.self, forKey: .windGust)
        self.precTypeKey = try container.decode(Int.self, forKey: .precTypeKey)
        self.precStrengthKey = try container.decode(Double.self, forKey: .precStrengthKey)
        self.cloudnessKey = try container.decode(Double.self, forKey: .cloudnessKey)
    }
    
}
