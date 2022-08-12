//
//  FoundViewController.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 11.08.2022.
//

import Foundation
import UIKit

class FoundViewController: UIViewController {
    
    let callback: (_ city: City) -> Void
    var delegate: PageViewCoordinator?
    var citys = [City]()
    
    private lazy var textView: UITextField = {
        let textView = UITextField()
        textView.font = UIFont.fontRubik(24)
        textView.toAutoLayout()
        textView.textColor = .black
        textView.layer.borderColor = ConstValue.backgroundColor.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        textView.tintColor = ConstValue.backgroundColor
        textView.backgroundColor = ConstValue.backgroundColorLight
        textView.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textView.frame.height))
        textView.leftViewMode = .always
        textView.placeholder = "Город"
        textView.returnKeyType = UIReturnKeyType.default
        textView.delegate = self
        return textView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.toAutoLayout()
        tableView.refreshControl = UIRefreshControl()
        tableView.isScrollEnabled = true
        tableView.isUserInteractionEnabled = true
        tableView.refreshControl?.addTarget(self, action: #selector(updateTable), for: .editingChanged)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    init(callback: @escaping (_ city: City) -> Void) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        
        view.addSubviews(textView,tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FoundViewControllerCell")
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalToConstant: 30),
            tableView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateTable() {
        if let text = textView.text, let delegate = delegate, text != "" {
            DispatchQueue.global().async {
                delegate.foundCityData(name: text) { [weak self] citys in
                    guard let self = self else { return }
                    self.citys = citys
                    self.tableView.reloadData()
                    self.endUpdateTabel()
                }
            }
        }
    }
    
    private func endUpdateTabel() {
        tableView.refreshControl?.endRefreshing()
    }
    
}

extension FoundViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoundViewControllerCell",
                                                 for: indexPath)
        let city = citys[indexPath.row]
        cell.textLabel?.text = city.id
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = citys[indexPath.row]
        callback(city)
        dismiss(animated: true)
    }
}

extension FoundViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.refreshControl?.beginRefreshing()
        updateTable()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
}
