//
//  AppDelegate.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 30.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let factory = ViewControllerFactory()
        self.window?.rootViewController = factory.startApp()
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

