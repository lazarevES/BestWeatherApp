//
//  WheatherEnum.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 02.08.2022.
//

import Foundation
import UIKit

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
    case lightRain = "Небольшой дождь"             //"moderate-rain"
    case rain = "Дождь"                             //"rain"
    case moderateRain = "Умеренно сильный дождь"   //"moderate-rain"
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
            return UIImage(named: "moderateRain")
        case .lightRain:
            return UIImage(named: "moderateRain")
        case .rain:
            return UIImage(named: "rain")
        case .moderateRain:
            return UIImage(named: "moderateRain")
        case .heavyRain:
            return UIImage(named: "rain")
        case .showers:
            return UIImage(named: "showers")
        case .wetSnow:
            return UIImage(named: "showers")
        case .lightSnow:
            return UIImage(named: "moderateRain")
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

enum DateTime: String {
    case day = "День"
    case night = "Ночь"
}

enum Season: String {
    case summer = "лето"
    case autumn = "осень"
    case winter = "зима"
    case spring = "весна"
}
