//
//  Fact.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 02.08.2022.
//

import Foundation

class Fact: Decodable, Storable {
    
    /// Температура в С
    var temp: Int = 0
    
    /// Ощущаемая температура в С
    var feelsLike: Int = 0
    
    /// Описание погоды
    var condition: String = ""
    
    /// Картинка
    var wheatherIcon: WheatherIcon {
        switch condition {
        case "clear": return .clear
        case "partly-cloudy": return .partlyCloudy
        case "cloudy": return .cloudy
        case "overcast": return .overcast
        case "drizzle": return .drizzle
        case "light-rain": return .lightRain
        case "rain": return .rain
        case "moderate-rain": return .moderateRain
        case "heavy-rain": return .heavyRain
        case "showers": return .showers
        case "wet-snow": return .wetSnow
        case "light-snow": return .lightSnow
        case "snow": return .snow
        case "snow-showers": return .snowShowers
        case "hail": return .hail
        case "thunderstorm": return .thunderstorm
        case "thunderstorm-with-rain": return .thunderstormWithRain
        case "thunderstorm-with-hail": return .thunderstormWithHail
        default: return .clear
        }
    }
    
    /// Скорость ветра м/с
    var windSpeed: Double = 0
    
    /// Скорость порывов ветра м/с
    var windGust: Double = 0
    
    /// Направление ветра код
    var windDirKey: String = ""
    
    /// Направление ветра
    var windDir: WindDir {
        switch windDirKey {
        case "nw": return .nw
        case "n": return .n
        case "ne": return .ne
        case "e": return .e
        case "se": return .se
        case "s": return .s
        case "sw": return .sw
        case "w": return .w
        case "с": return .c
        default: return .c
        }
    }
    
    /// Давление (в мм рт. ст.)
    var pressure: Int = 0
    
    /// Влажность воздуха (в процентах)
    var humidity: Int = 0
    
    /// Время суток код
    var daytimeKey: String = ""
    
    /// Время суток
    var daytime: DateTime {
        switch daytimeKey{
        case "d": return .day
        default: return .night
        }
    }
    
    /// Полярное время суток
    var polar: Bool = false
    
    /// Сезон код
    var seasonKey: String = ""
    
    /// Сезон
    var season: Season {
        switch seasonKey {
        case "summer": return .summer
        case "autumn": return .autumn
        case "winter": return .winter
        default: return .summer
        }
    }
    
    /// Тип осадков код
    var precTypeKey: Int = 0
    
    /// Тип осадков
    var precType: PrecType {
        switch precTypeKey {
        case 0: return .noPrec
        case 1: return .rain
        case 2: return .rainWithSnow
        case 3: return .snow
        case 4: return .deg
        default: return .noPrec
        }
    }
    
    /// Сила осадков код
    var precStrengthKey: Double = 0
    
    /// Сила осадков
    var precStrenght: precStrenght {
        switch precStrengthKey {
        case ..<0.24: return .noPrec
        case 0.25..<0.5: return .lightRain
        case 0.5..<0.75: return .rain
        case 0.75..<1: return .heavyRain
        default: return .veryHeavyRain
        }
    }
    
    ///  Признак грозы
    var isThunder: Bool = false
    
    /// Облачность код
    var cloudnessKey: Double = 0
    
    /// Облачность
    var cloudness: Сloudness {
        switch cloudnessKey {
        case 0..<0.24: return .clear
        case 0.25..<0.5: return .partlyCloudy
        case 0.5..<1: return .cloudyWithClearings
        default: return .overcast
        }
    }
    
    /// Время замера unix
    var obsTime: Int = 0
    
    var wheather: Wheather?
    
    var keyedValues: [String: Any] {
        return [
            "temp": self.temp,
            "condition": self.condition,
            "humidity": self.humidity,
            "polar": self.polar,
            "feelsLike": self.feelsLike,
            "windSpeed": self.windSpeed,
            "windGust": self.windGust,
            "windDirKey": self.windDirKey,
            "pressure": self.pressure,
            "daytimeKey": self.daytimeKey,
            "seasonKey": self.seasonKey,
            "precTypeKey": self.precTypeKey,
            "precStrengthKey": self.precStrengthKey,
            "isThunder": self.isThunder,
            "cloudnessKey": self.cloudnessKey,
            "obsTime": self.obsTime
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case temp, condition, humidity, polar
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDirKey = "wind_dir"
        case pressure = "pressure_mm"
        case daytimeKey = "daytime"
        case seasonKey = "season"
        case precTypeKey = "prec_type"
        case precStrengthKey = "prec_strength"
        case isThunder = "is_thunder"
        case cloudnessKey = "cloudness"
        case obsTime = "obs_time"
    }
    
    init(_ fact: FactModel) {
        self.temp = Int(fact.temp)
        self.condition = fact.condition ?? ""
        self.humidity = Int(fact.humidity)
        self.polar = fact.polar
        self.feelsLike = Int(fact.feelsLike)
        self.windSpeed = fact.windSpeed
        self.windGust = fact.windGust
        self.windDirKey = fact.windDirKey ?? ""
        self.pressure = Int(fact.pressure)
        self.daytimeKey = fact.daytimeKey ?? ""
        self.seasonKey = fact.seasonKey ?? ""
        self.precTypeKey = Int(fact.precTypeKey)
        self.precStrengthKey = fact.precStrengthKey
        self.isThunder = fact.isThunder
        self.cloudnessKey = fact.cloudnessKey
        self.obsTime = Int(fact.obsTime)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decode(Int.self, forKey: .temp)
        self.condition = try container.decode(String.self, forKey: .condition)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.polar = try container.decode(Bool.self, forKey: .polar)
        self.feelsLike = try container.decode(Int.self, forKey: .feelsLike)
        self.windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        self.windGust = try container.decode(Double.self, forKey: .windGust)
        self.windDirKey = try container.decode(String.self, forKey: .windDirKey)
        self.pressure = try container.decode(Int.self, forKey: .pressure)
        self.daytimeKey = try container.decode(String.self, forKey: .daytimeKey)
        self.seasonKey = try container.decode(String.self, forKey: .seasonKey)
        self.precTypeKey = try container.decode(Int.self, forKey: .precTypeKey)
        self.precStrengthKey = try container.decode(Double.self, forKey: .precStrengthKey)
        self.isThunder = try container.decode(Bool.self, forKey: .isThunder)
        self.cloudnessKey = try container.decode(Double.self, forKey: .cloudnessKey)
        self.obsTime = try container.decode(Int.self, forKey: .obsTime)
    }
    
}
