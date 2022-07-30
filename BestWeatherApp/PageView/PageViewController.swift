//
//  PageViewController.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 30.07.2022.
//

import Foundation
import UIKit

final class PageViewController: UIPageViewController {
    
    let model: PageViewCoordinator
    var isAppear: Bool = false
    var city = [City]()
    
    init() {
        self.model = PageViewCoordinator()
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
        model.pageViews = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.loadingViewControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isAppear = true
        model.GetGeoStatus()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isAppear = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activeViewController(_ city: City) {
        
    }
    
    
    
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
   
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
}
