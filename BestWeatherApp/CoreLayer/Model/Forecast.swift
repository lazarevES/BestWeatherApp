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
        
    /// Погода по часам
    var hours = [Hour]()
    
    var dayForecast: DayPart?
    var nightForecast: DayPart?
    var wheather: Wheather?
    
    func setupParent(_ wheather: Wheather) {
        self.wheather = wheather
        hours.forEach({ hour in hour.forecast = self })
        dayForecast?.forecast = self
        nightForecast?.forecast = self
    }
    
    var keyedValues: [String: Any] {
        return [
            "date": self.date,
            "week": self.week,
            "sunrise": self.sunrise,
            "sunset": self.sunset,
            "moonCode": self.moonCode,
            "dateTs": self.dateTs
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
        
        forecast.dayparts.forEach { part in
            let dayPart = DayPart(part as! DayPartsModel)
            if dayPart.isDay {
                self.dayForecast = dayPart
            } else {
                self.nightForecast = dayPart
            }
        }
        
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
        self.dayForecast = parts.day
        self.nightForecast = parts.nignt
    }
    
}
