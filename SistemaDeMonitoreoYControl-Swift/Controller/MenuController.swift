//
//  MenuController.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 1/20/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools
import SideMenu
import JGProgressHUD

class MenuController: UIViewController {
    
    // MARK: - Properties
    
    var tableView: UITableView!
    
    lazy var signoutButton: UIButton = .init(title: "Cerrar sesión", titleColor: .red, font: .boldSystemFont(ofSize: 16), backgroundColor: .white, target: self, action: #selector(handleSignout))
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewComponents()
    }
    
    // MARK: - Helper Functions
    
    fileprivate func setupViewComponents() {
        view.backgroundColor = .white
        navigationItem.title = "Operador"
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        tableView.withHeight(view.frame.height/2)
        tableView.isScrollEnabled = false
        
        view.addSubview(signoutButton)
        signoutButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        signoutButton.withHeight(70)
        signoutButton.layer.borderWidth = 0.5
        signoutButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func handleSignout() {
        let navController = UINavigationController(rootViewController: LoginController())
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true) {
            UserDefaults.standard.removeObject(forKey: "user")
        }
    }
    
}

// MARK: - Extension UITableViewDelegate UITableViewDataSource

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let menuOption = Menu(rawValue: indexPath.row)
        cell.textLabel?.text = menuOption?.description
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let options = indexPath.row
        switch options {
        case 0:
            navigationController?.pushViewController(AdminController(), animated: true)
            dismiss(animated: true, completion: nil)
        case 1:
            navigationController?.pushViewController(MonitoreoUnidadesController(), animated: true)
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
}
