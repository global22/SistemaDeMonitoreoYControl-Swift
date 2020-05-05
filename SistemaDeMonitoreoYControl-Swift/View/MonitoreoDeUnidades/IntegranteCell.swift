//
//  IntegranteCell.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/13/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

// MARK: - Protocol IntegranteDelegate

protocol IntegranteDelegate: class {
	func seleccionoIntegrante(_ integrante: Integrante, enElIndice indice: IndexPath)
}

class IntegranteCell: UITableViewCell {
	
	// MARK: - Properties
	
	weak var delegate: IntegranteDelegate?
	
	var integrante: Integrante? {
		didSet {
			if let integrante = integrante {
				nameLabel.text = "\(integrante.nombre) \(integrante.apellidoPaterno) \(integrante.aliasServicio)"
				if integrante.getLat() != 0.0 {
					nameLabel.font = .boldSystemFont(ofSize: 14)
					nameLabel.textColor = .white
					selectionStyle = .default
				} else {
					nameLabel.font = .systemFont(ofSize: 14)
					nameLabel.textColor = #colorLiteral(red: 0.5019999743, green: 0.5019999743, blue: 0.5019999743, alpha: 1)
					selectionStyle = .none
				}
			}
		}
	}
	
	let nameLabel = UILabel(text: "Name", font: .boldSystemFont(ofSize: 14), textColor: .white)
	lazy var calendarButton = UIButton(image: #imageLiteral(resourceName: "calendario.png").resizeImage(newWidth: 25)!, tintColor: #colorLiteral(red: 0.5019999743, green: 0.5019999743, blue: 0.5019999743, alpha: 1), target: self, action: #selector(mostrarRuta))
	
	var indice: IndexPath!
	
	
	// MARK: - Init
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		setupViewComponents()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Helpers
	
	fileprivate func setupViewComponents() {
		backgroundColor = .clear
		
		let stackView = hstack(nameLabel.withWidth(250),
							   calendarButton,
							   spacing: 8).padLeft(8).padRight(4)
		
		addSubview(stackView)
		stackView.centerYToSuperview()
	}
	
	// MARK: - Selectors
	
	@objc func mostrarRuta() {
		if let integrante = integrante {
			delegate?.seleccionoIntegrante(integrante, enElIndice: indice)
		}
	}
}
