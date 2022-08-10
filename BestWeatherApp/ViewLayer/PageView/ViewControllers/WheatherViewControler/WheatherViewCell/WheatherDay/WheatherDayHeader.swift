//
//  WheatherDayHeader.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 07.08.2022.
//

import Foundation
import UIKit

class WheatherDayHeader: UITableViewHeaderFooterView {
    
    static let identifire = "WheatherDayHeader"
    
    private lazy var label: UILabel = UILabel.getlabel(18, .left, .black, "Ежедневный прогноз", true)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ConstValue.leading),
                                     label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: ConstValue.trailing),
                                     label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                                     label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
