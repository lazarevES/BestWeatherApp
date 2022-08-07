//
//  WheatherToDayHourItem.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 07.08.2022.
//

import Foundation
import UIKit

class WheatherToDayHourItem: UICollectionViewCell {
    
    static let identifire = "WheatherToDayHourItem"
    var hour: Hour? {
        didSet {
            if let hour = hour {
                timeLabel.text = hour.hour.count == 1 ? "0" + hour.hour + ".00" : hour.hour + ".00"
                image.image = hour.wheatherIcon.getImage()
                tempLabel.text = String(hour.temp) + "º"
            }
        }
    }
    
    var isActualHour: Bool = false
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.fontRubik(14)
        return label
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        return image
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.fontRubik(18)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = ConstValue.hourCornerRadius
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = ConstValue.backgroundColor.cgColor
        
        contentView.addSubviews(timeLabel, image, tempLabel)
        useConstraint()
    }
    
        
   private func useConstraint() {
       NSLayoutConstraint.activate([timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                    timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                    timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                                    timeLabel.heightAnchor.constraint(equalToConstant: 30),
                                    image.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
                                    image.heightAnchor.constraint(equalToConstant: ConstValue.smallSizeIcon),
                                    image.widthAnchor.constraint(equalToConstant: ConstValue.smallSizeIcon),
                                    image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                                    tempLabel.topAnchor.constraint(equalTo: image.bottomAnchor),
                                    tempLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                    tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                    tempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent(hour: Hour) {
        self.hour = hour
    }
    
    func switchActualHour(_ isActualHour: Bool) {
        self.isActualHour = isActualHour
        timeLabel.textColor = isActualHour ? .white : .black
        tempLabel.textColor = isActualHour ? .white : .black
        contentView.backgroundColor = isActualHour ? ConstValue.backgroundColor : .white
    }
    
}
