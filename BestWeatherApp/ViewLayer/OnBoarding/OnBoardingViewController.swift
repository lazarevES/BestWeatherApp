//
//  OnBoardingViewController.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 30.07.2022.
//

import UIKit
import CoreLocation

class OnBoardingViewController: UIViewController {
    
    var callback: (() -> Void)
    weak var coordinator: PageViewCoordinator?
    
    private lazy var image = UIImageView.getImage("onBoardingImage")
    
    private lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.text = "Разрешить приложению Weather использовать данные о местоположении вашего устройства"
        label.toAutoLayout()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.fontRubik(16)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.text = "Чтобы получить более точные прогнозы погоды во время движения или путешествия"
        label.toAutoLayout()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.fontRubik(14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var thirdLabel: UILabel = {
        let label = UILabel()
        label.text = "Вы можете изменить свой выбор в любое время из меню приложения"
        label.toAutoLayout()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.fontRubik(14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var acceptButton: UIButton = {
        
        let button = UIButton()
        button.toAutoLayout()
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitle("ИСПОЛЬЗОВАТЬ МЕСТОПОЛОЖЕНИЕ УСТРОЙСТВА", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.fontRubik(12)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(acceptGeo), for: .touchUpInside)
        button.addTarget(self, action: #selector(preAcceptGeo), for: .touchDown)
        button.backgroundColor = UIColor(named: "ButtonColorNormal")

        return button
    }()
    
    private lazy var rejectButton: UIButton = {
        
        let button = UIButton()
        button.toAutoLayout()
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitle("НЕТ, Я БУДУ ДОБАВЛЯТЬ ЛОКАЦИИ", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.fontRubik(16)
        button.contentHorizontalAlignment = .right
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(rejectGeo), for: .touchUpInside)
        button.backgroundColor = ConstValue.backgroundColor

        return button
    }()
    
    init(callback: @escaping () -> Void) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.backgroundColor
        view.addSubviews(image, firstLabel, secondLabel, thirdLabel, acceptButton, rejectButton)
        useConsraint()
    }
    
    private func useConsraint() {
        NSLayoutConstraint.activate([image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     image.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     image.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                     firstLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: ConstValue.longIndent),
                                     firstLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ConstValue.leading),
                                     firstLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: ConstValue.trailing),
                                     secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: ConstValue.longIndent),
                                     secondLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ConstValue.leading),
                                     secondLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: ConstValue.trailing),
                                     thirdLabel.topAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: ConstValue.smallindent),
                                     thirdLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ConstValue.leading),
                                     thirdLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: ConstValue.trailing),
                                     acceptButton.topAnchor.constraint(equalTo: thirdLabel.bottomAnchor, constant: ConstValue.toLongIndent),
                                     acceptButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ConstValue.leading),
                                     acceptButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: ConstValue.trailing),
                                     rejectButton.topAnchor.constraint(equalTo: acceptButton.bottomAnchor, constant: 25),
                                     rejectButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ConstValue.leading),
                                     rejectButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: ConstValue.trailing),
        ])
    }
    
    @objc func preAcceptGeo() {
        acceptButton.backgroundColor = UIColor(named: "ButtonColorFocus")
    }
    
    @objc func acceptGeo() {
        acceptButton.backgroundColor = UIColor(named: "ButtonColorNormal")
        coordinator?.locationManager.requestWhenInUseAuthorization()
    }
    
    @objc func rejectGeo() {
        callback()
        dismiss(animated: true)
    }
    
}



