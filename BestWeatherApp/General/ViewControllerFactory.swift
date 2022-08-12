//
//  ViewControllerFactory.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 30.07.2022.
//

import Foundation
import UIKit

enum StatusApp: Int {
    case onBoard = 1
    case geoAccept = 2
    case geoReject = 3
}

final class ViewControllerFactory {
    
    func startApp() -> UINavigationController {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        
        let viewController = GlobalViewController()
        viewController.view.backgroundColor = .white
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.titleTextAttributes = [ .foregroundColor: UIColor.black]
        navigationController.navigationBar.barTintColor = UIColor.white
        navigationController.navigationBar.isHidden = true
        navigationController.navigationBar.standardAppearance = appearance;
        navigationController.navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance
        
        return navigationController
    }
}
