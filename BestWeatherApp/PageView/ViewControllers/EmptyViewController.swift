//
//  EmptyViewController.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 30.07.2022.
//

import Foundation
import UIKit

class EmptyViewController: UIViewController, ViewControllerProtocol {
    
    var city: City?
    var delegate: PageViewCoordinator?
    var index: Int = 0
    var isAppear: Bool = false
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "➕"
        label.font = UIFont.fontRubik(100)
        label.toAutoLayout()
        label.textAlignment = .center
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                                     label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isAppear = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isAppear = false
    }
    
    func setupCity(city: City, index: Int) {
        return
    }
    
    func upLoadWheather() {
        return
    }
}
