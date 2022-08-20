//
//  PreviewController.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 12.08.2022.
//

import Foundation
import UIKit

class PreviewController: UIViewController {
    
    
    private lazy var claudImage1 = UIImageView.getImage("cloud1")
    private lazy var claudImage2 = UIImageView.getImage("cloud2")
    private lazy var claudImage3 = UIImageView.getImage("cloud3")
    private lazy var onBoardingImage = UIImageView.getImage("onBoardingImage")
    
    private var locationManager = LocationCoordinator()
    private var dataBaseCoordinator = CoreDataCoordinator.CreateDataBase()
    private var citys = [City]()
    private var geoStatus = false
    private var dataStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onBoardingImage.contentMode = .scaleAspectFit
        view.backgroundColor = ConstValue.backgroundColor
        view.addSubviews(claudImage1, claudImage2, claudImage3, onBoardingImage)
        
        locationManager.rootViewController = self
        locationManager.callback = { [weak self] in
            self?.geoStatus = true
            self?.complitionPreview()
        }
        
        loadingCitys()
        
        NSLayoutConstraint.activate([
            onBoardingImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            onBoardingImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            onBoardingImage.widthAnchor.constraint(equalToConstant: 300),
            onBoardingImage.heightAnchor.constraint(equalToConstant: 300),
            
            claudImage1.trailingAnchor.constraint(equalTo: view.leadingAnchor),
            claudImage1.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            
            claudImage2.leadingAnchor.constraint(equalTo: view.trailingAnchor),
            claudImage2.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 170),
            
            claudImage3.trailingAnchor.constraint(equalTo: view.leadingAnchor),
            claudImage3.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 2,
                       delay: 0,
                       usingSpringWithDamping: 1.2,
                       initialSpringVelocity: 0,
                       options: .curveEaseIn) {
            self.claudImage1.frame.origin.x = self.view.frame.origin.x
            self.claudImage2.frame.origin.x = self.view.frame.width - self.claudImage2.frame.width
            self.claudImage3.frame.origin.x = self.view.frame.origin.x
        } completion: { finished in
            if self.locationManager.GetGeoStatus() != nil {
                self.geoStatus = true
                self.complitionPreview()
            }
        }
    }
    
    func complitionPreview() {
        if geoStatus && dataStatus {
            let globalViewController = GlobalViewController(citys: citys, coreDataCoordinator: dataBaseCoordinator)
            navigationController?.setViewControllers([globalViewController], animated: true)
        }
    }
    
    func loadingCitys() {
                
        let task = DispatchQueue.global(qos: .background)
        task.async {
            self.dataBaseCoordinator.fetchAll { result in
                switch result {
                case .success(let CitysM):
                    
                    self.citys = CitysM.map { city -> City in
                        city.isNew = false
                        return city
                    }
                    
                case .failure(_):
                    break
                }
                
                self.dataStatus = true
                self.complitionPreview()
            }
        }
        
        task.resume()
    }
        
}
