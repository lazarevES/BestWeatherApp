//
//  Wheather.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 30.07.2022.
//

import Foundation

class Wheather: Decodable, ValidateModel  {
    
    var fact: Fact?
    var forecasts = [Forecast]()
    var city: City?
    
    
    var keyedValues: [String: Any] {
        return [
            "fact": self.fact?.keyedValues ?? [],
            "forecasts": self.forecasts.map({ forecast in
                forecast.keyedValues
            })
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case forecasts, fact
    }
    
    func setupParent(_ city: City) {
        self.city = city
        self.forecasts.forEach { forecast in
            forecast.setupParent(self)
        }
        self.fact?.wheather = self
    }
    
    init(_ wheather: WheatherModel) {
       
        if let fact = wheather.fact {
            self.fact = Fact(fact)
        }
        
        self.forecasts = wheather.forecasts.map({forecast -> Forecast in
            Forecast(forecast as! ForecastModel)
        })
        
        self.forecasts = self.forecasts.sorted(by: { lforecast, rforecast in
            lforecast.date < rforecast.date
        })
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.forecasts = try container.decode([Forecast].self, forKey: .forecasts)
        self.fact = try container.decode(Fact.self, forKey: .fact)

    }
}
