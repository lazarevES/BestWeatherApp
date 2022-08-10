//
//  Parts.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 07.08.2022.
//

import Foundation

struct Parts: Decodable {
    
    var day: DayPart
    var nignt: DayPart
    
    enum CodingKeys: String, CodingKey {
        case day =  "day_short"
        case nignt =  "night_short"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.day = try container.decode(DayPart.self, forKey: .day)
        self.day.isDay = true
        self.nignt = try container.decode(DayPart.self, forKey: .nignt)
    }
    
}


