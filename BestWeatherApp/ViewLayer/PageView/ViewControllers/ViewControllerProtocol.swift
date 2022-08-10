//
//  ViewControllerProtocol.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 02.08.2022.
//

import Foundation
import UIKit

protocol ViewControllerProtocol: UIViewController {
    var city: City? { get set }
    var delegate: PageViewCoordinator? { get set }
    var index: Int { get set }
    var isAppear: Bool { get set }
    
    func setupCity(city: City, index: Int)
    func upLoadWheather()
}
