//
//  Wheather.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 30.07.2022.
//

import Foundation
import UIKit

struct Wheather: Decodable {
    
    var forecasts: [Forecast]
    
    struct Forecast: Decodable {
        /// Дата
        var date: String
        /// Дата Unixtime
        var dateTs: Int
        /// Неделя
        var week: Int
        /// Время рассвета
        var sunrise: String
        /// Время заката
        var sunset: String
        ///Фаза луны код
        var moonCode: Int
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
        /// Погода по часам
        var hours: [Hour]
        
        struct Hour: Decodable {
            /// Час
            var hour: String
            /// Час Unixtime
            var hourTs: Int
            /// Температура в С
            var temp: Int
            /// Ощущаемая температура в С
            var feelsLike: Int
            /// Описание погоды
            var condition: String
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
            var windSpeed: Double
            /// Скорость порывов ветра м/с
            var windGust: Double
            /// Направление ветра код
            var windDirKey: String
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
            var pressure: Int
            /// Влажность воздуха (в процентах)
            var humidity: Int
            /// Прогнозируемое количество осадков (в мм)
            var precMM: Int
            /// Прогнозируемый период осадков (в минутах)
            var precPeriod: Int
            /// Тип осадков код
            var precTypeKey: Int
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
            var precStrengthKey: Double
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
            var isThunder: Bool
            /// Облачность код
            var cloudnessKey: Double
            /// Облачность
            var cloudness: Сloudness {
                switch cloudnessKey {
                case 0..<0.24: return .clear
                case 0.25..<0.5: return .partlyCloudy
                case 0.5..<1: return .cloudyWithClearings
                default: return .overcast
                }
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
            
            init(from decoder: Decoder) throws {
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
                self.precMM = try container.decode(Int.self, forKey: .precMM)
                self.precPeriod = try container.decode(Int.self, forKey: .precPeriod)
                self.precTypeKey = try container.decode(Int.self, forKey: .precTypeKey)
                self.precStrengthKey = try container.decode(Double.self, forKey: .precStrengthKey)
                self.isThunder = try container.decode(Bool.self, forKey: .isThunder)
            }
            
        }
        
        enum CodingKeys: String, CodingKey {
            case date, week, sunrise, sunset, moon, hours
            case moonCode =  "moon_code"
            case dateTs = "date_ts"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.date = try container.decode(String.self, forKey: .date)
            self.dateTs = try container.decode(Int.self, forKey: .dateTs)
            self.week = try container.decode(Int.self, forKey: .week)
            self.sunrise = try container.decode(String.self, forKey: .sunrise)
            self.sunset = try container.decode(String.self, forKey: .sunset)
            self.moonCode = try container.decode(Int.self, forKey: .moonCode)
            self.hours = try container.decode([Hour].self, forKey: .hours)
        }
        
    }
    
    enum CodingKeys: String, CodingKey {
        case forecasts
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.forecasts = try container.decode([Forecast].self, forKey: .forecasts)
    }
    
}

enum Moon: String {
    case fullMoon = "Полнолуние"
    case waningMoon = "Убывающая луна"
    case lastQuarter = "Последняя четверть"
    case newMoon = "Новолуние"
    case growingMoon = "Растущая луна"
    case firstQuarter = "Первая четверть"
}

enum WheatherIcon: String {
    case clear = "Ясно"                             //"clear"
    case partlyCloudy = "Малооблачно"               //"partly-cloudy"
    case cloudy = "Облачно с прояснениями"          //"cloudy"
    case overcast = "Пасмурно"                      //"overcast"
    case drizzle = "Морось"                         //"moderate-rain"
    case lightRain = "Небольшой дождь."             //"moderate-rain"
    case rain = "Дождь"                             //"rain"
    case moderateRain = "Умеренно сильный дождь."   //"moderate-rain"
    case heavyRain = "Сильный дождь"                //"rain"
    case showers = "Ливень"                         //"showers"
    case wetSnow = "Дождь со снегом"                //"showers"
    case lightSnow = "Небольшой снег"               //"moderate-rain"
    case snow = "Снег"                              //"rain"
    case snowShowers = "Снегопад"                   //"showers"
    case hail = "Град"                              //"showers"
    case thunderstorm = "Гроза"                     //"thunderstorm"
    case thunderstormWithRain = "Дождь с грозой"    //"thunderstorm"
    case thunderstormWithHail = "Гроза с градом"    //"thunderstorm"
    
    func getImage() -> UIImage? {
        switch self {
        case .clear:
            return UIImage(named: "clear")
        case .partlyCloudy:
            return UIImage(named: "partly-cloudy")
        case .cloudy:
            return UIImage(named: "cloudy")
        case .overcast:
            return UIImage(named: "overcast")
        case .drizzle:
            return UIImage(named: "moderate-rain")
        case .lightRain:
            return UIImage(named: "moderate-rain")
        case .rain:
            return UIImage(named: "rain")
        case .moderateRain:
            return UIImage(named: "moderate-rain")
        case .heavyRain:
            return UIImage(named: "rain")
        case .showers:
            return UIImage(named: "showers")
        case .wetSnow:
            return UIImage(named: "showers")
        case .lightSnow:
            return UIImage(named: "moderate-rain")
        case .snow:
            return UIImage(named: "rain")
        case .snowShowers:
            return UIImage(named: "showers")
        case .hail:
            return UIImage(named: "showers")
        case .thunderstorm:
            return UIImage(named: "thunderstorm")
        case .thunderstormWithRain:
            return UIImage(named: "thunderstorm")
        case .thunderstormWithHail:
            return UIImage(named: "thunderstorm")
        }
    }
}

enum WindDir: String {
    case nw = "Cеверо-западное"
    case n = "Северное"
    case ne = "Северо-восточное"
    case e = "Восточное"
    case se = "Юго-восточное"
    case s = "Южное"
    case sw = "Юго-западное"
    case w = "Западное"
    case c = "Штиль"
}

enum PrecType: String {
    case noPrec = "Без осадков"
    case rain = "Дождь"
    case rainWithSnow = "Дождь со снегом"
    case snow = "Снег"
    case deg = "Град"
}

enum precStrenght: String {
    case noPrec = "Без осадков"
    case lightRain = "Слабый дождь/слабый снег"
    case rain = "Дождь/снег"
    case heavyRain = "Сильный дождь/сильный снег"
    case veryHeavyRain = "Сильный ливень/очень сильный снег"
}

enum Сloudness: String {
    case clear = "Ясно"
    case partlyCloudy = "Малооблачно"
    case cloudyWithClearings = "Облачно с прояснениями"
    case overcast = "Пасмурно"
}
