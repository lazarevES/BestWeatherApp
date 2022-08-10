//
//  WheatherToDayHourHeader.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 07.08.2022.
//

import Foundation
import UIKit

class WheatherToDayHourHeader: UITableViewHeaderFooterView {
    
    static let identifire = "WheatherToDayHourHeader"
    private var callback: (()->Void)?
    
    private lazy var label: UILabel = {
        let label = UILabel.getlabel(16, .right, .black, "", true)
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "Подробнее на 24 часа")
        attributeString.addAttribute(NSAttributedString.Key.underlineStyle,
                                     value: 1,
                                     range: NSRange(location: 0, length: attributeString.length))
        label.attributedText = attributeString
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapToLabel))
        label.addGestureRecognizer(gestureRecognizer)
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
    
    func setupContent(callback: @escaping ()->Void) {
        self.callback = callback
    }
    
    @objc func tapToLabel() {
        if let callback = callback {
            callback()
        }
        
    }
    
}

