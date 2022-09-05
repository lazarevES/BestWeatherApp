//
//  DetailsGraphicCell.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 09.08.2022.
//

import Foundation
import UIKit

class DetailsGraphicCell: UITableViewCell {
    
    static let identifire = "DetailsGraphicCell"

    private lazy var graphicView: GraphicView = {
        let view = GraphicView()
        view.toAutoLayout()
        view.backgroundColor = ConstValue.backgroundColorLight
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(graphicView)
        
        NSLayoutConstraint.activate([graphicView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     graphicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                     graphicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     graphicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     graphicView.heightAnchor.constraint(equalToConstant: 180)])
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent(_ forecast: [(date: String, hour: Hour)]) {
        graphicView.setupConten(forecast)
    }
    
}
