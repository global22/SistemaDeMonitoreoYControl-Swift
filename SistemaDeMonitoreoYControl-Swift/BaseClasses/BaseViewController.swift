//
//  BaseViewController.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/13/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import SideMenu

class BaseViewController: UIViewController {
	
	let menuButtonImage = #imageLiteral(resourceName: "menu.png")
	let headerImageView = UIImageView(image: #imageLiteral(resourceName: "sedena360.png"))
	lazy var menuButton = UIBarButtonItem(image: menuButtonImage.resizeImage(newWidth: 30), style: .plain, target: self, action: #selector(handleMenu))
	lazy var navigationHeaderView = UIBarButtonItem(customView: headerImageView.withSize(.init(width: 200, height: 40)))
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        navigationItem.title = "Sistema de Monitoreo y Control"
		navigationItem.hidesBackButton = true
		navigationItem.rightBarButtonItem = menuButton
		navigationItem.leftBarButtonItem = navigationHeaderView
	}
	
	@objc func handleMenu() {
		let menu = SideMenuNavigationController(rootViewController: MenuController())
		menu.settings.menuWidth = UIScreen.main.bounds.width / 3
		menu.presentationStyle = .menuSlideIn
		menu.statusBarEndAlpha = 0
		present(menu, animated: true, completion: nil)
	}
}
