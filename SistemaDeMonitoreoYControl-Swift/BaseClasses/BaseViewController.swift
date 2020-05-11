//
//  BaseViewController.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/13/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import SideMenu
import SDWebImage

class BaseViewController: UIViewController {
	
    let titulo = "Sistema de Monitoreo y Control"
    
	let menuButtonImage = #imageLiteral(resourceName: "menu.png")
	let headerImageView = UIImageView()
	lazy var menuButton = UIBarButtonItem(image: menuButtonImage.resizeImage(newWidth: 30), style: .plain, target: self, action: #selector(handleMenu))
	lazy var navigationHeaderView = UIBarButtonItem(customView: headerImageView.withSize(.init(width: 200, height: 40)))
    let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "background.jpg"), contentMode: .scaleAspectFill)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        view.insertSubview(backgroundImage, at: 0)
        backgroundImage.fillSuperview()
        
        let dependencia = UserDefaults.standard.string(forKey: Constants.dependencia)
        updateTitleView(title: titulo, subtitle: dependencia, baseColor: .black)
//        navigationItem.title = "Sistema de Monitoreo y Control"
        let imagenUrl = UserDefaults.standard.object(forKey: Constants.urlImagenDependencia) as? String
        headerImageView.sd_setImage(with: URL(string: imagenUrl ?? ""))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: headerImageView.withSize(.init(width: 200, height: 40)))
		navigationItem.hidesBackButton = true
		navigationItem.rightBarButtonItem = menuButton
//		navigationItem.leftBarButtonItem = navigationHeaderView
	}
	
	@objc func handleMenu() {
		let menu = SideMenuNavigationController(rootViewController: MenuController())
		menu.settings.menuWidth = UIScreen.main.bounds.width / 3
		menu.presentationStyle = .menuSlideIn
		menu.statusBarEndAlpha = 0
		present(menu, animated: true, completion: nil)
	}
    
    func reload() {
        let dependencia = UserDefaults.standard.string(forKey: Constants.dependencia)
        let imagenUrl = UserDefaults.standard.object(forKey: Constants.urlImagenDependencia) as? String
        headerImageView.sd_setImage(with: URL(string: imagenUrl ?? ""))
        UIView.animate(withDuration: 0.3) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.headerImageView.withSize(.init(width: 200, height: 40)))
            self.updateTitleView(title: self.titulo, subtitle: dependencia, baseColor: .black)
        }
    }
}
