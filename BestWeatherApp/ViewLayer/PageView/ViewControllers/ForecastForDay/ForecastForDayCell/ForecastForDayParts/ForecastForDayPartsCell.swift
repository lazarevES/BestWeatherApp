//
//  ForecastForDayPartsCell.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 10.08.2022.
//

import Foundation
import UIKit

class ForecastForDayPartsCell: UITableViewCell {
    
    static let identifire = "ForecastForDayPartsCell"
    
    private lazy var image = UIImageView.getImage("")
    private lazy var title = UILabel.getlabel(14, .left, .black, "", true)
    private lazy var date = UILabel.getlabel(18, .right, .black, "", true)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(image, title, date)
        contentView.backgroundColor = ConstValue.backgroundColorLight
        useConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func useConstraint() {
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            image.heightAnchor.constraint(equalToConstant: 35),
            image.widthAnchor.constraint(equalToConstant: 25),
            
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 25),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            title.widthAnchor.constraint(equalToConstant: 110),
            
            date.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            date.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            date.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            date.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 5)
        ])
    }
    
    func setupContent(_ cell: (image: String, title: String, data: String)){
        image.image = UIImage(named: cell.image)
        title.text = cell.title
        date.text = cell.data        
    }
    
}
