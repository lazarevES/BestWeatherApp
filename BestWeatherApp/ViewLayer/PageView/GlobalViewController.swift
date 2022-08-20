//
//  GlobalViewController.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 11.08.2022.
//

import Foundation
import UIKit

class GlobalViewController: UIViewController {
    
    var pageController: PageViewController
    var settingsController: SettingsView!
    var isMove: Bool = false
    
    init(citys: [City], coreDataCoordinator: CoreDataProtocol) {
       
        
        self.pageController = PageViewController(citys: citys, coreDataCoordinator: coreDataCoordinator)
        super.init(nibName: nil, bundle: nil)
        
        pageController.globalViewController = self
        pageController.view.frame = view.frame
        
        view.addSubview(pageController.view)
        addChild(pageController)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func configureSettingsViewControler() {
        if settingsController == nil {
            settingsController = SettingsView()
            settingsController.pageController = pageController
            view.insertSubview(settingsController.view, at: 0)
            addChild(settingsController)
        }
    }
    
    func toggleMenu() {
        configureSettingsViewControler()
        isMove.toggle()
        showSettingsViewControler(isMove)
        
    }
    
    func showSettingsViewControler(_ shouldMove: Bool) {
        if shouldMove {
            settingsController.updateTable()
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.pageController.view.frame.origin.x = self.pageController.view.frame.width - 70
            } completion: { finished in
                
            }
            
            
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.pageController.view.frame.origin.x = 0
            } completion: { finished in
                
            }
        }
    }
}
