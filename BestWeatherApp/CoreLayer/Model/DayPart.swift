//
//  DayPart.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 09.08.2022.
//

import Foundation

class DayPart: Decodable, Storable {
   
    /// Средняя температура
    var temp: Int = 0
    var tempString: String {
        if Settings.sharedSettings.temp == .celsius {
            return String(temp) + "º"
        } else {
            return String(Int(Double(temp) * 1.8) + 32)
        }
    }
    
    ///  Минимальная температура
    var tempMin: Int = 0
    var tempMinString: String {
        if Settings.sharedSettings.temp == .celsius {
            return String(tempMin) + "º"
        } else {
            return String(Int(Double(tempMin) * 1.8) + 32)
        }
    }
    
    /// Ощущаемая температура
    var feelsLike: Int = 0
    var feelsLikeString: String {
        if Settings.sharedSettings.temp == .celsius {
            return String(temp) + "º"
        } else {
            return String(Int(Double(temp) * 1.8) + 32) + "ºF"
        }
    }
    
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
    var windSpeedString: String {
        if Settings.sharedSettings.speed == .metric {
            return String(windSpeed) + " m/s"
        } else {
            return String(Int(windSpeed * 1.09361)) + " ya/s"
        }
    }
    
    /// Скорость порывов ветра м/с
    var windGust: Double = 0
    var windGustString: String {
        if Settings.sharedSettings.speed == .metric {
            return String(windGust) + " m/s"
        } else {
            return String(Int(windGust * 1.09361)) + " ya/s"
        }
    }
    
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
    
    /// Влажность воздуха (в процентах)
    var humidity: Int = 0
    
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
    
    var isDay: Bool = false
    
    var forecast: Forecast?
    
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
    
    var keyedValues: [String : Any] {
        return [
            "temp": self.temp,
            "tempMin": self.tempMin,
            "feelsLike": self.feelsLike,
            "condition": self.condition,
            "windSpeed": self.windSpeed,
            "windGust": self.windGust,
            "windDirKey": self.windDirKey,
            "humidity": self.humidity,
            "precTypeKey": self.precTypeKey,
            "precStrengthKey": self.precStrengthKey,
            "cloudnessKey": self.cloudnessKey,
            "isDay": self.isDay
        ]
    }
    
    init(_ dayPart: DayPartsModel) {
        self.temp = Int(dayPart.temp)
        self.tempMin = Int(dayPart.tempMin)
        self.feelsLike = Int(dayPart.feelsLike)
        self.condition = dayPart.condition ?? ""
        self.windSpeed = dayPart.windSpeed
        self.windGust = dayPart.windGust
        self.windDirKey = dayPart.windDirKey ?? ""
        self.humidity = Int(dayPart.humidity)
        self.precTypeKey = Int(dayPart.precTypeKey)
        self.precStrengthKey = dayPart.precStrengthKey
        self.cloudnessKey = dayPart.cloudnessKey
        self.isDay = dayPart.isDay
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decode(Int.self, forKey: .temp)
        self.condition = try container.decode(String.self, forKey: .condition)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        do {
            self.tempMin = try container.decode(Int.self, forKey: .tempMin)
        } catch {
            self.tempMin = self.temp
        }
        self.feelsLike = try container.decode(Int.self, forKey: .feelsLike)
        self.windDirKey = try container.decode(String.self, forKey: .windDirKey)
        self.windGust = try container.decode(Double.self, forKey: .windGust)
        self.precTypeKey = try container.decode(Int.self, forKey: .precTypeKey)
        self.precStrengthKey = try container.decode(Double.self, forKey: .precStrengthKey)
        self.cloudnessKey = try container.decode(Double.self, forKey: .cloudnessKey)
    }
    
}
