//
//  ForecastForDaySunAndMoonItemCell.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 10.08.2022.
//

import Foundation
import UIKit
import CloudKit


class ForecastForDaySunAndMoonItemCell: UITableViewCell {
    
    static let identifire = "ForecastForDaySunAndMoonItemCell"
    
    enum IdCells {
        case image
        case sunrise
        case sunset
    }
    
    private lazy var leftLabel = UILabel.getlabel(14, .left, .lightGray, "", true)
    private lazy var rightLabel = UILabel.getlabel(16, .right, .black, "", true)
    private lazy var backImage = UIImageView.getImage("clear")
    private lazy var forwardImage = UIImageView.getImage("moon")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews(leftLabel, rightLabel, backImage, forwardImage)
        useConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent(id: IdCells, data: String, sun: Bool) {
        rightLabel.text = data
        switch id {
        case .image:
            leftLabel.text = ""
        case .sunrise:
            leftLabel.text = "Восход"
        case .sunset:
            leftLabel.text = "Заход"
        }
        
        hiddenElement(id: id, sun: sun)
    }
    
    private func hiddenElement(id: IdCells, sun: Bool) {
        
        switch id {
        case .image:
            forwardImage.isHidden = sun
            backImage.isHidden = false
            leftLabel.isHidden = true
        default:
            leftLabel.isHidden = false
            backImage.isHidden = true
            forwardImage.isHidden = true
        }
        
    }
    
    private func useConstraint() {
        NSLayoutConstraint.activate([
            backImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            backImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            backImage.heightAnchor.constraint(equalToConstant: 15),
            backImage.widthAnchor.constraint(equalToConstant: 15),
            
            forwardImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            forwardImage.topAnchor.constraint(equalTo: backImage.topAnchor),
            forwardImage.widthAnchor.constraint(equalToConstant: 15),
            forwardImage.heightAnchor.constraint(equalToConstant: 15),
            
            leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            leftLabel.widthAnchor.constraint(equalToConstant: 50),
            
            rightLabel.leadingAnchor.constraint(equalTo: backImage.trailingAnchor, constant: 5),
            rightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            rightLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
            
            
        ])
    }
    
}
