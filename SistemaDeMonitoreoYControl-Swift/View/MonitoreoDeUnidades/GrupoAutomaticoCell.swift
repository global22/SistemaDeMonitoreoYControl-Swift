//
//  GrupoAutomaticoCell.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/16/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

class GrupoAutomaticoCell: GrupoCell<GrupoAutomatico> {
    
    override var item: GrupoAutomatico! {
        didSet {
            nameLabel.text = item.nombre
            
            selectedSwitch.isOn = item.isSelected! ? true : false
            
            if item.integrantes.isEmpty {
                phoneButton.isHidden = true
                messageButton.isHidden = true
            } else {
                phoneButton.isHidden = false
                messageButton.isHidden = false
            }
        }
    }
	
    override func setupViewComponents() {
        super.setupViewComponents()
		
		let stackView = hstack(selectedSwitch,
							   nameLabel.withWidth(140),
							   hstack(phoneButton,
									  messageButton,
                                      UIView(),
									  spacing: 4),
							   spacing: 4).padLeft(4).padRight(4)
		
		addSubview(stackView)
		stackView.centerYToSuperview()
	}
	
    override func mostrarIntegrantes(_ sender: UISwitch) {
        super.mostrarIntegrantes(sender)
        if sender.isOn {
            delegate?.grupoCell(self, mostroGrupoDelIndice: indice)
        } else {
            delegate?.grupoCell(self, ocultoGrupoDelIndice: indice)
        }
    }
    
}
