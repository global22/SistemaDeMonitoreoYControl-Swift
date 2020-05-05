//
//  GrupoPersonalizadoCell.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/13/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

class GrupoPersonalizadoCell: GrupoCell<GrupoPersonalizado> {
	
	// MARK: - Properties
	
	override var item: GrupoPersonalizado! {
		didSet {
			plusButton.isHidden = false
			pencilButton.isHidden = false
			phoneButton.isHidden = false
			messageButton.isHidden = false
			
			nameLabel.text = item.nombre
			
			selectedSwitch.isOn = item.isSelected! ? true : false
			
		}
	}
	
	// MARK: - Helpers
	
	override func setupViewComponents() {
		super.setupViewComponents()
		
		let stackView = hstack(selectedSwitch,
							   nameLabel.withWidth(140),
							   hstack(plusButton,
									  phoneButton,
									  messageButton,
									  pencilButton,
									  spacing: 4),
							   spacing: 4).padLeft(4).padRight(4)
		
		addSubview(stackView)
		stackView.centerYToSuperview()
	}
	
	// MARK: - Selectors
	
	override func mostrarIntegrantes(_ sender: UISwitch) {
		super.mostrarIntegrantes(sender)
    
		if sender.isOn {
			delegate?.grupoCell(self, mostroGrupoDelIndice: indice)
		} else {
			delegate?.grupoCell(self, ocultoGrupoDelIndice: indice)
		}
	}
}




