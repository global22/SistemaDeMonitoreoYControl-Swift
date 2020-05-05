//
//  GrupoCell.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/16/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

// MARK: - Protocol GrupoCellDelegate

protocol GrupoDelegate: class {
	func grupoCell<T: UITableViewCell>(_ grupoCell: T, mostroGrupoDelIndice indice: IndexPath)
	func grupoCell<T: UITableViewCell>(_ grupoCell: T, ocultoGrupoDelIndice indice: IndexPath)
}

class GrupoCell<T>: UITableViewCell {
	
	open var item: T!
	
	weak var delegate: GrupoDelegate?
	
	var indice: IndexPath!
	lazy var selectedSwitch = UISwitch()
	let nameLabel = UILabel(text: "Nombre", font: .systemFont(ofSize: 12), textColor: .white)
	lazy var plusButton = UIButton(image: #imageLiteral(resourceName: "mas.png").resizeImage(newWidth: 25)!, tintColor: .white, target: self, action: #selector(agregarIntegrantes))
	lazy var phoneButton = UIButton(image: #imageLiteral(resourceName: "telefono.png").resizeImage(newWidth: 25)!, tintColor: .white, target: self, action: #selector(llamarIntegrantes))
	lazy var messageButton = UIButton(image: #imageLiteral(resourceName: "chat").resizeImage(newWidth: 25)!, tintColor: .white, target: self, action: #selector(mensajeAIntegrantes))
	lazy var pencilButton = UIButton(image: #imageLiteral(resourceName: "editar.png").resizeImage(newWidth: 25)!, tintColor: .white, target: self, action: #selector(editarGrupo))
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		setupViewComponents()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	open func setupViewComponents() {
		backgroundColor = #colorLiteral(red: 0, green: 0.5879999995, blue: 0.6629999876, alpha: 1)
		
		selectedSwitch.transform = .init(scaleX: 0.75, y: 0.75)
		selectedSwitch.addTarget(self, action: #selector(mostrarIntegrantes), for: .valueChanged)
        
        
	}
	
	@objc open func agregarIntegrantes() {}
	
	@objc open func llamarIntegrantes() {}
	
	@objc open func mensajeAIntegrantes() {}
	
	@objc open func editarGrupo() {}
	
	@objc open func mostrarIntegrantes(_ sender: UISwitch) {}
}
