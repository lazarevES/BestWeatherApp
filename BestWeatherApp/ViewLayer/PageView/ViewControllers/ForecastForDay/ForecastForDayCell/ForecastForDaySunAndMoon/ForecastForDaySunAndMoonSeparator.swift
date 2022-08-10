//
//  ForecastForDaySunAndMoonSeparator.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 10.08.2022.
//

import Foundation
import UIKit

class ForecastForDaySunAndMoonSeparator: UICollectionViewCell {
    
    static let identifire = "ForecastForDaySunAndMoonSeparator"
    
    private lazy var view: UIView = {
        let view = UIView()
        view.toAutoLayout()
        view.backgroundColor = ConstValue.backgroundColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
