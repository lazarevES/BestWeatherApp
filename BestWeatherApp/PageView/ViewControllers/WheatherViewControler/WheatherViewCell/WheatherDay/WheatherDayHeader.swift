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
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Ежедневный прогноз"
        label.toAutoLayout()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.fontRubik(18)

        return label
    }()
    
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
