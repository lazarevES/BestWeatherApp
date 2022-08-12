//
//  GlobalViewController.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 11.08.2022.
//

import Foundation
import UIKit

class GlobalViewController: UIViewController {
    
    var pageController: PageViewController!
    var settingsController: SettingsView!
    var isMove: Bool = false
    var preview: PreviewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configurePreview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configurePageViewControler()
    }
    
    func configurePreview() {
        let previewController = PreviewController()
        preview = previewController
        view.addSubview(previewController.view)
        preview.view.frame = view.frame
        addChild(previewController)
    }
    
    func configurePageViewControler() {
        if pageController == nil {
            let pageViewController = PageViewController()
            pageViewController.globalViewController = self
            pageController = pageViewController
            view.insertSubview(pageViewController.view, at: 0)
            pageViewController.view.frame = view.frame
            addChild(pageViewController)
        }
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
                print(self.pageController.view.frame)
            } completion: { finished in
                
            }
        }
    }
}
