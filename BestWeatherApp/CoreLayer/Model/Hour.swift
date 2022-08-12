//
//  Hour.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 02.08.2022.
//

import Foundation

class Hour: Decodable, Storable {
    
    /// Час
    var hour: String = ""
    var hourString: String {
        if Settings.sharedSettings.time == .full {
            return hour + ".00"
        } else {
            return hour + (Int(hour) ?? 0 > 12 ? " p.m." : " a.m.")
        }
    }
    
    /// Час Unixtime
    var hourTs: Int = 0
    
    /// Температура в С
    var temp: Int = 0
    var tempString: String {
        if Settings.sharedSettings.temp == .celsius {
            return String(temp) + "º"
        } else {
            return String(Int(Double(temp) * 1.8) + 32)
        }
    }
    
    /// Ощущаемая температура в С
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
    
    /// Давление (в мм рт. ст.)
    var pressure: Int = 0
    
    /// Влажность воздуха (в процентах)
    var humidity: Int = 0
    
    /// Прогнозируемое количество осадков (в мм)
    var precMM: Double = 0
    
    /// Прогнозируемый период осадков (в минутах)
    var precPeriod: Int = 0
    
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
    
    /// Признак грозы.
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
    
    var forecast: Forecast?
    
    var keyedValues: [String: Any] {
        return [
            "hour": self.hour,
            "temp": self.temp,
            "condition": self.condition,
            "humidity": self.humidity,
            "hourTs": self.hourTs,
            "feelsLike": self.feelsLike,
            "windSpeed": self.windSpeed,
            "windGust": self.windGust,
            "windDirKey": self.windDirKey,
            "pressure": self.pressure,
            "cloudnessKey": self.cloudnessKey,
            "precMM": self.precMM,
            "precPeriod": self.precPeriod,
            "precTypeKey": self.precTypeKey,
            "precStrengthKey": self.precStrengthKey,
            "isThunder": self.isThunder
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case hour, temp, condition, humidity
        case hourTs = "hour_ts"
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDirKey = "wind_dir"
        case pressure = "pressure_mm"
        case cloudnessKey = "cloudness"
        case precMM = "prec_mm"
        case precPeriod = "prec_period"
        case precTypeKey = "prec_type"
        case precStrengthKey = "prec_strength"
        case isThunder = "is_thunder"
    }
    
    init(_ hour: HourModel) {
        self.hour = hour.hour ?? ""
        self.temp = Int(hour.temp)
        self.condition = hour.condition ?? ""
        self.pressure = Int(hour.pressure)
        self.humidity = Int(hour.humidity)
        self.cloudnessKey = hour.cloudnessKey
        self.hourTs = Int(hour.hourTs)
        self.feelsLike = Int(hour.feelsLike)
        self.windSpeed = hour.windSpeed
        self.windGust = hour.windGust
        self.windDirKey = hour.windDirKey ?? ""
        self.precMM = hour.precMM
        self.precPeriod = Int(hour.precPeriod)
        self.precTypeKey = Int(hour.precTypeKey)
        self.precStrengthKey = hour.precStrengthKey
        self.isThunder = hour.isThunder
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hour = try container.decode(String.self, forKey: .hour)
        self.temp = try container.decode(Int.self, forKey: .temp)
        self.condition = try container.decode(String.self, forKey: .condition)
        self.pressure = try container.decode(Int.self, forKey: .pressure)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.cloudnessKey = try container.decode(Double.self, forKey: .cloudnessKey)
        self.hourTs = try container.decode(Int.self, forKey: .hourTs)
        self.feelsLike = try container.decode(Int.self, forKey: .feelsLike)
        self.windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        self.windGust = try container.decode(Double.self, forKey: .windGust)
        self.windDirKey = try container.decode(String.self, forKey: .windDirKey)
        self.precMM = try container.decode(Double.self, forKey: .precMM)
        self.precPeriod = try container.decode(Int.self, forKey: .precPeriod)
        self.precTypeKey = try container.decode(Int.self, forKey: .precTypeKey)
        self.precStrengthKey = try container.decode(Double.self, forKey: .precStrengthKey)
        self.isThunder = try container.decode(Bool.self, forKey: .isThunder)
    }
    
}
