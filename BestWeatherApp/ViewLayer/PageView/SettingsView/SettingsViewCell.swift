//
//  SettingsViewCell.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 11.08.2022.
//

import Foundation
import UIKit

class SettingsViewCell: UITableViewCell {
    static let identifire = "SettingsViewCell"
    
    lazy var image = UIImageView.getImage("hot")
    lazy var label = UILabel.getlabel(14, .left, .white, "тестики", true)
    lazy var valueLabel = UILabel.getlabel(14, .right, .white, "", true)
    lazy var switcher: UISwitch = {
        let switcher = UISwitch(frame: .zero)
        switcher.toAutoLayout()
        switcher.transform = CGAffineTransform(scaleX: 0.55, y: 0.5)
        switcher.backgroundColor = .gray
        switcher.layer.cornerRadius = switcher.frame.height * 0.8
        switcher.layer.masksToBounds = true
        switcher.isUserInteractionEnabled = false
        return switcher
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = ConstValue.backgroundColor
        contentView.addSubviews(image, label, valueLabel, switcher)
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            image.heightAnchor.constraint(equalToConstant: 15),
            image.widthAnchor.constraint(equalToConstant: 15),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: 10),
            
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            valueLabel.widthAnchor.constraint(equalToConstant: 60),
            
            switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            switcher.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent(imageName: String, text: String, value: String?, switcher: Bool = false) {
       
        self.image.image = UIImage(named: imageName)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image.tintColor = .white
        
        self.label.text = text
        if let value = value {
            if value == "" {
                self.switcher.isHidden = false
                self.valueLabel.isHidden = true
                self.switcher.isOn = switcher
            } else {
                self.valueLabel.isHidden = false
                self.switcher.isHidden = true
                self.valueLabel.text = value
            }
        } else {
            self.valueLabel.isHidden = true
            self.switcher.isHidden = true
        }
    }
}
