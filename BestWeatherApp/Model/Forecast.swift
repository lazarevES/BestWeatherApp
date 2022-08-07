//
//  Forecast.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 02.08.2022.
//

import Foundation

class Forecast: Decodable, Storable {

    /// Дата формат гггг-мм-дд
    var date: String = ""
    
    /// Дата Unixtime
    var dateTs: Int = 0
    
    /// Неделя
    var week: Int = 0
    
    /// Время рассвета
    var sunrise: String = ""
    
    /// Время заката
    var sunset: String = ""
    
    ///Фаза луны код
    var moonCode: Int = 0
    
    /// Фаза луны
    var moon: Moon {
        switch moonCode {
        case 0: return .fullMoon
        case 1...3: return .waningMoon
        case 4: return .lastQuarter
        case 5...7: return .waningMoon
        case 8: return .newMoon
        case 9...11: return .growingMoon
        case 12: return .firstQuarter
        default: return .growingMoon
        }
    }
    
    /// Средняя температура
    var temp: Int = 0
    
    ///  Минимальная температура
    var tempMin: Int = 0
    
    /// Ощущаемая температура
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
        
    /// Погода по часам
    var hours = [Hour]()
    
    var wheather: Wheather?
    
    func setupParent(_ wheather: Wheather) {
        self.wheather = wheather
        hours.forEach({ hour in hour.forecast = self })
    }
    
    var keyedValues: [String: Any] {
        return [
            "date": self.date,
            "week": self.week,
            "sunrise": self.sunrise,
            "sunset": self.sunset,
            "moonCode": self.moonCode,
            "dateTs": self.dateTs,
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
            "cloudnessKey": self.cloudnessKey
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case date, week, sunrise, sunset, moon, hours, parts
        case moonCode =  "moon_code"
        case dateTs = "date_ts"
    }
    
    init(_ forecast: ForecastModel) {
        self.date = forecast.date ?? ""
        self.dateTs = Int(forecast.dateTs)
        self.week = Int(forecast.week)
        self.sunrise = forecast.sunrise ?? ""
        self.sunset = forecast.sunset ?? ""
        self.moonCode = Int(forecast.moonCode)
        self.temp = Int(forecast.temp)
        self.tempMin = Int(forecast.tempMin)
        self.feelsLike = Int(forecast.feelsLike)
        self.condition = forecast.condition ?? ""
        self.windSpeed = forecast.windSpeed
        self.windGust = forecast.windGust
        self.windDirKey = forecast.windDirKey ?? ""
        self.humidity = Int(forecast.humidity)
        self.precTypeKey = Int(forecast.precTypeKey)
        self.precStrengthKey = forecast.precStrengthKey
        self.cloudnessKey = forecast.cloudnessKey
        
        forecast.hours.forEach { hour in
            self.hours.append(Hour(hour as! HourModel))
        }
        self.hours = self.hours.sorted(by: { lhour, rhour in
            Int(lhour.hour) ?? 1 < Int(rhour.hour) ?? 2
        })
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        self.dateTs = try container.decode(Int.self, forKey: .dateTs)
        self.week = try container.decode(Int.self, forKey: .week)
        self.sunrise = try container.decode(String.self, forKey: .sunrise)
        self.sunset = try container.decode(String.self, forKey: .sunset)
        self.moonCode = try container.decode(Int.self, forKey: .moonCode)
        self.hours = try container.decode([Hour].self, forKey: .hours)
        
        let parts = try container.decode(Parts.self, forKey: .parts)
        self.temp = parts.dayShort.temp
        self.tempMin = parts.dayShort.tempMin
        self.feelsLike = parts.dayShort.feelsLike
        self.condition = parts.dayShort.condition
        self.windSpeed = parts.dayShort.windSpeed
        self.windGust = parts.dayShort.windGust
        self.windDirKey = parts.dayShort.windDirKey
        self.humidity = parts.dayShort.humidity
        self.precTypeKey = parts.dayShort.precTypeKey
        self.precStrengthKey = parts.dayShort.precStrengthKey
        self.cloudnessKey = parts.dayShort.cloudnessKey
    }
    
}
