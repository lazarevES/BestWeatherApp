//
//  Extension.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 30.07.2022.
//

import Foundation
import UIKit

extension NSNotification.Name {
    static let foundCityLocation = NSNotification.Name("foundCityLocation")
}

extension String {
    
    static let empty = ""
    static let whitespace: Character = " "
    
    var isFirstCharacterWhitespace: Bool {
        return self.first == Self.whitespace
    }

    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
    /// Замена паттерна строкой.
    /// - Parameters:
    ///   - pattern: Regex pattern.
    ///   - replacement: Строка, на что заменить паттерн.
    func replace(_ pattern: String, replacement: String) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        return regex.stringByReplacingMatches(in: self,
                                              options: [.withTransparentBounds],
                                              range: NSRange(location: 0, length: self.count),
                                              withTemplate: replacement)
    }
    
    static func randomString(length: Int = 36) -> Self {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
      return String((0..<length).compactMap { _ in letters.randomElement() })
    }
}

extension UIView {

    func toAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }

}

extension UIColor {
    
    convenience init(hex:String, a: CGFloat = 1.0) {

        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(red: 255, green: 255, blue: 255, alpha: a)
            return
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: a
        )
    }
}

extension UIFont {
    static func fontRubik(_ size: CGFloat) -> UIFont {
       let font = UIFont(name: "Rubik", size: size)
        if let font = font {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}

extension UIAlertController {
    
    static func create(preferredStyle: UIAlertController.Style,
                       title: String, message: String? = nil,
                       hasAction: Bool = false, actionInfo: (title: String?, style: UIAlertAction.Style)? = nil,
                       hasCancel: Bool = false,
                       actionCompletionHandler: ((UIAlertAction) -> Void)? = nil,
                       cancelCompletionHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if hasAction {
            let action = UIAlertAction(title: actionInfo?.title ?? .empty, style: actionInfo?.style ?? .default) { action in
                actionCompletionHandler?(action)
            }
            alertController.addAction(action)
        }
        if hasCancel {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                cancelCompletionHandler?(action)
            }
            alertController.addAction(cancelAction)
        }
        
        return alertController
    }
}

extension UILabel {
    static func getlabel(_ size: CGFloat = 16,
                         _ textAlignment: NSTextAlignment = .center,
                         _ color: UIColor = .black,
                         _ text: String = "",
                         _ toAutoLayot: Bool = true) -> UILabel {
        let label = UILabel()
        if toAutoLayot{
            label.toAutoLayout()
        }
        label.textAlignment = textAlignment
        label.textColor = color
        label.text = text
        label.font = UIFont.fontRubik(size)
        return label
    }
}

extension UIImageView {
    
    static func getImage(_ name: String, toAutoLayot: Bool = true) -> UIImageView {
        
        let image: UIImageView
        if name.isEmpty {
            image = UIImageView()
        } else {
            image = UIImageView(image: UIImage(named: name))
        }
        
        if toAutoLayot{
            image.toAutoLayout()
        }
        return image
    }
    
}

