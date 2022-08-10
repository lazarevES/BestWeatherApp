//
//  DetailsHourCell.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 09.08.2022.
//

import Foundation
import UIKit

class DetailsHourCell: UITableViewCell {
    
    static let identifire = "DetailsHourCell"
    
    private let dateFormatter: DateFormatter = {
        let formatter =  DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()

    private lazy var dateLabel: UILabel = UILabel.getlabel(18, .left, .black, "", true)
    private lazy var timeLabel: UILabel = UILabel.getlabel(14, .left, .lightGray, "", true)
    private lazy var tempLabel: UILabel = UILabel.getlabel(18, .left, .black, "", true)
    private lazy var conditionLabel: UILabel = UILabel.getlabel(14, .left, .black, "", true)
    private lazy var windLabel: UILabel = UILabel.getlabel(14, .left, .black, "Ветер", true)
    private lazy var windDataLabel: UILabel = UILabel.getlabel(14, .right, .lightGray, "", true)
    private lazy var precLabel: UILabel = UILabel.getlabel(14, .left, .black, "Атмосферные осадки", true)
    private lazy var precDataLabel: UILabel = UILabel.getlabel(14, .right, .lightGray, "", true)
    private lazy var cloudnessLabel: UILabel = UILabel.getlabel(14, .left, .black, "Облачность", true)
    private lazy var cloudnessDataLabel: UILabel = UILabel.getlabel(14, .right, .lightGray, "", true)
    
    private lazy var conditionImage: UIImageView = UIImageView.getImage("moon")
    private lazy var windImage: UIImageView = UIImageView.getImage("wind")
    private lazy var precImage: UIImageView = UIImageView.getImage("rain")
    private lazy var cloudnessImage: UIImageView = UIImageView.getImage("overcast")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = ConstValue.backgroundColorLight        
        contentView.addSubviews(dateLabel, timeLabel, tempLabel, conditionLabel, windLabel, windDataLabel, precLabel,
                                precDataLabel, cloudnessLabel, cloudnessDataLabel, conditionImage, windImage, precImage,
                                cloudnessImage)
        useConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func useConstraint() {
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            dateLabel.widthAnchor.constraint(equalToConstant: 100),
            
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            timeLabel.widthAnchor.constraint(equalToConstant: 40),
            
            tempLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            tempLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            tempLabel.widthAnchor.constraint(equalToConstant: 40),
            
            conditionImage.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            conditionImage.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 10),
            conditionImage.heightAnchor.constraint(equalToConstant: 15),
            conditionImage.widthAnchor.constraint(equalToConstant: 15),
            
            conditionLabel.leadingAnchor.constraint(equalTo: conditionImage.trailingAnchor, constant: 5),
            conditionLabel.topAnchor.constraint(equalTo: conditionImage.topAnchor),
            conditionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            windImage.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 10),
            windImage.leadingAnchor.constraint(equalTo: conditionImage.leadingAnchor),
            windImage.heightAnchor.constraint(equalToConstant: 15),
            windImage.widthAnchor.constraint(equalToConstant: 15),
            
            windLabel.leadingAnchor.constraint(equalTo: windImage.trailingAnchor, constant: 5),
            windLabel.topAnchor.constraint(equalTo: windImage.topAnchor),
            windLabel.widthAnchor.constraint(equalToConstant: 150),
            
            windDataLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            windDataLabel.topAnchor.constraint(equalTo: windLabel.topAnchor),
            windDataLabel.widthAnchor.constraint(equalToConstant: 150),
            
            precImage.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 10),
            precImage.leadingAnchor.constraint(equalTo: windImage.leadingAnchor),
            precImage.heightAnchor.constraint(equalToConstant: 15),
            precImage.widthAnchor.constraint(equalToConstant: 15),
            
            precLabel.leadingAnchor.constraint(equalTo: precImage.trailingAnchor, constant: 5),
            precLabel.topAnchor.constraint(equalTo: precImage.topAnchor),
            precLabel.widthAnchor.constraint(equalToConstant: 150),
            
            precDataLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            precDataLabel.topAnchor.constraint(equalTo: precLabel.topAnchor),
            precDataLabel.widthAnchor.constraint(equalToConstant: 150),
            
            cloudnessImage.topAnchor.constraint(equalTo: precLabel.bottomAnchor, constant: 10),
            cloudnessImage.leadingAnchor.constraint(equalTo: precImage.leadingAnchor),
            cloudnessImage.heightAnchor.constraint(equalToConstant: 15),
            cloudnessImage.widthAnchor.constraint(equalToConstant: 15),
            cloudnessImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            cloudnessLabel.leadingAnchor.constraint(equalTo: cloudnessImage.trailingAnchor, constant: 5),
            cloudnessLabel.topAnchor.constraint(equalTo: cloudnessImage.topAnchor),
            cloudnessLabel.widthAnchor.constraint(equalToConstant: 150),
            cloudnessLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            cloudnessDataLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            cloudnessDataLabel.topAnchor.constraint(equalTo: cloudnessLabel.topAnchor),
            cloudnessDataLabel.widthAnchor.constraint(equalToConstant: 150),
            cloudnessDataLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        
    }
    
    func setupContent(forecast: (date: String, hour: Hour)) {
        
        dateLabel.text = forecast.date
        timeLabel.text = (forecast.hour.hour.count == 1 ? "0" + forecast.hour.hour : forecast.hour.hour) + ".00"
        tempLabel.text = String(forecast.hour.temp) + "º"
        conditionLabel.text = forecast.hour.wheatherIcon.rawValue
        windDataLabel.text = String(Int(forecast.hour.windSpeed)) + " m/s " + forecast.hour.windDir.rawValue
        precDataLabel.text = forecast.hour.precStrenght.rawValue
        cloudnessDataLabel.text = forecast.hour.cloudness.rawValue
    }

}
