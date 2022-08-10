//
//  ForecastForDayDaysItem.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 10.08.2022.
//

import Foundation
import UIKit

class ForecastForDayDaysItem: UICollectionViewCell {
    
    static let identifire = "ForecastForDayDaysItem"
    
    private var forecast: Forecast?
    private lazy var label: UILabel = UILabel.getlabel(18)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     label.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent(_ forecast: Forecast) {
        self.forecast = forecast
        
        let date = Date(timeIntervalSince1970: TimeInterval(forecast.dateTs))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        
        let myCalendar = Calendar(identifier: .gregorian)
        
        let weekDay = myCalendar.component(.weekday, from: date)
        var stringDate = "" //dd MMMM
        
        stringDate = dateFormatter.string(from: date)
       
        switch weekDay {
        case 1: stringDate += ", ВС "
        case 2: stringDate += ", ПН "
        case 3: stringDate += ", ВТ "
        case 4: stringDate += ", СР "
        case 5: stringDate += ", ЧТ "
        case 6: stringDate += ", ПТ "
        case 7: stringDate += ", СБ "
        default: break
        }
        
        label.text = stringDate
    }
    
    func switchSelected() {
        if isSelected {
            label.backgroundColor = ConstValue.backgroundColor
            label.textColor = .white
        } else {
            label.backgroundColor = .white
            label.textColor = .black
        }
    }
}

