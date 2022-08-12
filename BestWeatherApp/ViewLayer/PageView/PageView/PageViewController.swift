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
    var globalViewController: GlobalViewController?
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.toAutoLayout()
        control.currentPage = 1
        control.numberOfPages = 1
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .darkGray
        return control
    }()
    
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
        view.backgroundColor = .white
        view.addSubviews(pageControl)
        
        navigationItem.largeTitleDisplayMode = .always
        setViewControllers([coordinator.getViewController(city: citys.first, index: 0)], direction: .forward, animated: true)
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "set"),
                                         landscapeImagePhone: UIImage(named: "set"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(openSettings))
        globalViewController?.navigationItem.leftBarButtonItem  = leftButton
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "geo"),
                                          landscapeImagePhone: UIImage(named: "geo"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(foundCity))
        globalViewController?.navigationItem.rightBarButtonItem  = rightButton
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            pageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
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
        
        pageControl.numberOfPages = citys.count
        
        if let index = index {
            parent?.title = city.name + ", " + city.country
            setViewControllers([coordinator.getViewController(city: city, index: index)], direction: .forward, animated: true)
            pageControl.currentPage = index
        }
    }
    
    @objc func openSettings() {
        globalViewController?.toggleMenu()
    }
    
    @objc func foundCity() {
        
        let founController = FoundViewController { [weak self] city in
            guard let self = self else { return }
            
            DispatchQueue.global().async {
                self.coordinator.addCityToPageView(city)
            }
        }
        
        founController.delegate = coordinator
        
        navigationController?.present(founController, animated: true)
        
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
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let vc = viewControllers?.first as? WheatherViewController
        if let vc = vc {
            parent?.title = citys[vc.index].name + ", " + citys[vc.index].country
            pageControl.currentPage = vc.index
        }
    }
    
}

