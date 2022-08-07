//
//  PageViewController.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 30.07.2022.
//

import Foundation
import UIKit

final class PageViewController: UIPageViewController {
    
    let coordinator: PageViewCoordinator
    var isAppear: Bool = false
    var citys = [City]()
    
    init() {
        self.coordinator = PageViewCoordinator()
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        coordinator.pageViews = self
        dataSource = self
        delegate = self
        coordinator.loadingViewControllers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        setViewControllers([coordinator.getViewController(city: citys.first, index: 0)], direction: .forward, animated: true)
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "set"),
                                         landscapeImagePhone: UIImage(named: "set"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(openSettings))
        self.navigationItem.leftBarButtonItem  = leftButton
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "geo"),
                                          landscapeImagePhone: UIImage(named: "geo"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(geoLocation))
        self.navigationItem.rightBarButtonItem  = rightButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isAppear = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isAppear = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activeViewController(_ city: City) {
        let index = citys.firstIndex(of: city)
        
        if let index = index {
            title = city.name + " / " + city.country
            setViewControllers([coordinator.getViewController(city: city, index: index)], direction: .forward, animated: true)
        }
    }
    
    @objc func openSettings() {
        
    }
    
    @objc func geoLocation() {
        coordinator.GetGeoStatus()
    }
    
    func updateCity(_ city: City) {
       let vc = viewControllers?.first as? WheatherViewController
        vc?.upLoadWheather()
    }
    
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
   
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if citys.isEmpty {
            return nil
        }
        
        let index = ((viewController as? ViewControllerProtocol)?.index ?? 0) - 1
        
        if index < 0 {
            return nil
        }
        
        return self.coordinator.getViewController(city: citys[index], index: index)

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if citys.isEmpty {
            return nil
        }
        
        let index = ((viewController as? ViewControllerProtocol)?.index ?? 0) + 1
        
        if index >= citys.count {
            return nil
        }
        
        return self.coordinator.getViewController(city: citys[index], index: index)
    }
    
}

