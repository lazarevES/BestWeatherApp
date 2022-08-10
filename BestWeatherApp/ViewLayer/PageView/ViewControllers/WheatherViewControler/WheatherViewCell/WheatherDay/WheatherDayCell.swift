//
//  WheatherDayCell.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 02.08.2022.
//

import Foundation
import UIKit

class WheatherDayCell: UITableViewCell {
    
    static let identifire = "WheatherDayCell"
    
    private var forecast: Forecast?
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()
    
    private lazy var dayLabel: UILabel = UILabel.getlabel(16, .left, .lightGray, "", true)
    private lazy var humidityLabel: UILabel = UILabel.getlabel(12, .left, ConstValue.backgroundColor, "", true)
    private lazy var conditionLabel: UILabel = UILabel.getlabel(16, .left, .black, "", true)
    private lazy var tempLabel: UILabel = UILabel.getlabel(18, .left, .black, "", true)
    private lazy var image: UIImageView = UIImageView.getImage("")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(dayLabel, humidityLabel, conditionLabel, tempLabel, image)
        contentView.backgroundColor = ConstValue.backgroundColorLight
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 5
        
        useConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func useConstraint() {
        NSLayoutConstraint.activate([dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                                     dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                                     dayLabel.widthAnchor.constraint(equalToConstant: 60),
                                     image.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 5),
                                     image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                                     image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                                     image.widthAnchor.constraint(equalToConstant: 20),
                                     image.heightAnchor.constraint(equalToConstant: 20),
                                     humidityLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5),
                                     humidityLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 5),
                                     humidityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                                     conditionLabel.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 3),
                                     conditionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                                     conditionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
                                     conditionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -90),
                                     tempLabel.leadingAnchor.constraint(equalTo: conditionLabel.trailingAnchor, constant: 3),
                                     tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
                                     tempLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
                                     tempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -17)])
        
        
    }
    
    func setupContent(forecast: Forecast) {
        self.forecast = forecast
        if let dayForecast = forecast.dayForecast, let nightForecast = forecast.nightForecast {
            let date = Date(timeIntervalSince1970: Double(forecast.dateTs))
            self.dayLabel.text = dateFormatter.string(from: date)
            self.image.image = dayForecast.wheatherIcon.getImage()
            self.humidityLabel.text = String(dayForecast.humidity) + "%"
            self.conditionLabel.text = dayForecast.wheatherIcon.rawValue
            self.tempLabel.text = String(nightForecast.temp) + " - " + String(dayForecast.temp)
        }
    }
    
}
