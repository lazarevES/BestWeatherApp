//
//  WheatherToDayInfoCell.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 02.08.2022.
//

import Foundation
import UIKit

class WheatherToDayInfoCell: UITableViewCell {
    
    static let identifire = "WheatherToDayInfoCell"
    
    private lazy var ellipseImage: UIImageView = UIImageView.getImage("Ellipse")
    
    private lazy var sunriseImage: UIImageView = {
        let image = UIImageView.getImage("sunriseImage")
        let templateImage = image.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        image.image = templateImage
        image.tintColor = ConstValue.yelowColor
        return image
    }()
    
    private lazy var sunsetImage: UIImageView = {
        let image = UIImageView.getImage("sunsetImage")
        let templateImage = image.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        image.image = templateImage
        image.tintColor = ConstValue.yelowColor
        return image
    }()
    
    private lazy var cloudnessImage: UIImageView = UIImageView.getImage("partly-cloudy")
    private lazy var windSpeedImage: UIImageView = UIImageView.getImage("wind")
    private lazy var humidityImage: UIImageView = UIImageView.getImage("rain")
    
    private lazy var temp: UILabel = UILabel.getlabel(16, .center, .white, "", true)
    private lazy var factTemp: UILabel = UILabel.getlabel(36, .center, .white, "", true)
    private lazy var conditionLabel: UILabel = UILabel.getlabel(16, .center, .white, "", true)
    private lazy var cloudinessLabel: UILabel = UILabel.getlabel(14, .center, .white, "", true)
    private lazy var windSpeedLabel: UILabel = UILabel.getlabel(14, .center, .white, "", true)
    private lazy var humidityLabel: UILabel = UILabel.getlabel(14, .center, .white, "", true)
    private lazy var timeLabel: UILabel = UILabel.getlabel(16, .center, ConstValue.yelowColor, "", true)
    private lazy var sunriseLabel: UILabel = UILabel.getlabel(14, .center, .white, "", true)
    private lazy var sunsetLabel: UILabel = UILabel.getlabel(14, .center, .white, "", true)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(ellipseImage, sunsetImage, sunriseImage, cloudnessImage, windSpeedImage, humidityImage, cloudinessLabel,
                         temp, factTemp, conditionLabel, windSpeedLabel, humidityLabel, timeLabel, sunsetLabel, sunriseLabel)
        
        contentView.backgroundColor = ConstValue.backgroundColor
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        useConstraint()
    }
        
    private func useConstraint() {
        NSLayoutConstraint.activate([
            ellipseImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ConstValue.longLeading + 5),
            ellipseImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: ConstValue.longTrailing - 5),
            ellipseImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ConstValue.indent),
            ellipseImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -65),
            
            sunriseImage.topAnchor.constraint(equalTo: ellipseImage.bottomAnchor, constant: 5),
            sunriseImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ConstValue.leading),
            sunriseImage.heightAnchor.constraint(equalToConstant: 25),
            sunriseImage.widthAnchor.constraint(equalToConstant: 25),
            
            sunriseLabel.topAnchor.constraint(equalTo: sunriseImage.bottomAnchor, constant: 5),
            sunriseLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            sunriseLabel.heightAnchor.constraint(equalToConstant: 20),
            sunriseLabel.widthAnchor.constraint(equalToConstant: 40),
           
            sunsetImage.topAnchor.constraint(equalTo: ellipseImage.bottomAnchor, constant: 5),
            sunsetImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: ConstValue.trailing),
            sunsetImage.heightAnchor.constraint(equalToConstant: 25),
            sunsetImage.widthAnchor.constraint(equalToConstant: 25),
            
            sunsetLabel.topAnchor.constraint(equalTo: sunriseImage.bottomAnchor, constant: 5),
            sunsetLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            sunsetLabel.heightAnchor.constraint(equalToConstant: 20),
            sunsetLabel.widthAnchor.constraint(equalToConstant: 40),
            
            temp.topAnchor.constraint(equalTo: ellipseImage.topAnchor, constant: 15),
            temp.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            temp.widthAnchor.constraint(equalToConstant: 60),
            
            factTemp.topAnchor.constraint(equalTo: temp.bottomAnchor, constant: 5),
            factTemp.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            factTemp.widthAnchor.constraint(equalToConstant: 60),
            
            conditionLabel.topAnchor.constraint(equalTo: factTemp.bottomAnchor, constant: 5),
            conditionLabel.leadingAnchor.constraint(equalTo: ellipseImage.leadingAnchor, constant: ConstValue.leading),
            conditionLabel.trailingAnchor.constraint(equalTo: ellipseImage.trailingAnchor, constant: ConstValue.trailing),
            
            cloudnessImage.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 5),
            cloudnessImage.leadingAnchor.constraint(equalTo: ellipseImage.leadingAnchor, constant: 45),
            cloudnessImage.heightAnchor.constraint(equalToConstant: 20),
            cloudnessImage.widthAnchor.constraint(equalToConstant: 20),
            
            cloudinessLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 5),
            cloudinessLabel.leadingAnchor.constraint(equalTo: cloudnessImage.trailingAnchor, constant: 5),
            cloudinessLabel.heightAnchor.constraint(equalToConstant: 20),
            cloudinessLabel.widthAnchor.constraint(equalToConstant: 45),
            
            windSpeedImage.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 5),
            windSpeedImage.leadingAnchor.constraint(equalTo: cloudinessLabel.trailingAnchor, constant: 10),
            windSpeedImage.heightAnchor.constraint(equalToConstant: 20),
            windSpeedImage.widthAnchor.constraint(equalToConstant: 20),
            
            windSpeedLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 5),
            windSpeedLabel.leadingAnchor.constraint(equalTo: windSpeedImage.trailingAnchor, constant: 5),
            windSpeedLabel.heightAnchor.constraint(equalToConstant: 20),
            windSpeedLabel.widthAnchor.constraint(equalToConstant: 45),
            
            humidityImage.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 5),
            humidityImage.leadingAnchor.constraint(equalTo: windSpeedLabel.trailingAnchor, constant: 10),
            humidityImage.heightAnchor.constraint(equalToConstant: 20),
            humidityImage.widthAnchor.constraint(equalToConstant: 20),
            
            humidityLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 5),
            humidityLabel.leadingAnchor.constraint(equalTo: humidityImage.trailingAnchor, constant: 5),
            humidityLabel.heightAnchor.constraint(equalToConstant: 20),
            humidityLabel.widthAnchor.constraint(equalToConstant: 45),
            
            timeLabel.topAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor, constant: 10),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            timeLabel.leadingAnchor.constraint(equalTo: sunriseLabel.trailingAnchor, constant: 30),
            timeLabel.trailingAnchor.constraint(equalTo: sunsetLabel.leadingAnchor, constant: -30),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent(fact: Fact, forecast: Forecast) {
        sunriseLabel.text = forecast.sunrise
        sunsetLabel.text = forecast.sunset
        temp.text = String(forecast.dayForecast!.tempMin) + "º/" + String(forecast.dayForecast!.temp) + "º"
        factTemp.text = String(fact.temp) + "º"
        conditionLabel.text = fact.wheatherIcon.rawValue
        cloudinessLabel.text = String(fact.cloudnessKey * 100) + "%"
        windSpeedLabel.text = String(Int(fact.windSpeed)) + " m\\c"
        humidityLabel.text = String(fact.humidity) + "%"
        timeLabel.text = getTodayDateString()
        
    }
    
    private func getTodayDateString() -> String {
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        var stringDate = "" //dd MMMM
        stringDate = dateFormatter.string(from: todayDate)
        switch weekDay {
        case 1: stringDate += ", вс "
        case 2: stringDate += ", пн "
        case 3: stringDate += ", вт "
        case 4: stringDate += ", ср "
        case 5: stringDate += ", чт "
        case 6: stringDate += ", пт "
        case 7: stringDate += ", сб "
        default: break
        }
        
        dateFormatter.dateFormat = "dd MMMM"
        stringDate += dateFormatter.string(from: todayDate)
        
        return stringDate
        
    }
    
}
