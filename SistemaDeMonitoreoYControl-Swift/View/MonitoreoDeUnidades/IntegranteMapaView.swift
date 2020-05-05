//
//  IntegranteMapaView.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/15/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools
import SDWebImage

// MARK: - Protocol IntegranteMapaDelegate

protocol IntegranteMapaDelegate: class {
	func integranteMapaView(_ integranteMapaView: IntegranteMapaView, mostroLaRutaDelIntegrante integrante: IntegranteMapa)
    func integranteMapaView(_ integranteMapaView: IntegranteMapaView, ocultoLaRutaDelIntegrante integrante: IntegranteMapa)
}

class IntegranteMapaView: UIView {
	
	// MARK: - Properties
	
	weak var delegate: IntegranteMapaDelegate?
	
	var integranteMapa: IntegranteMapa! {
		didSet {
			servicioLabel.text = integranteMapa.servicio
			nombreLabel.text = "Nombre: \(integranteMapa.nombre) \(integranteMapa.apellidoPaterno) \(integranteMapa.apellidoMaterno)"
			telefonoLabel.text = "Teléfono: \(integranteMapa.idUsuario)"
			fechaLabel.attributedText = setAttributedText(title: "Fecha: ", body: integranteMapa.fecha)
			horaLabel.attributedText = setAttributedText(title: "Hora: ", body: integranteMapa.hora)
			perfilImageView.sd_setImage(with: URL(string: integranteMapa.img))
			
			if integranteMapa.estaEnRuta {
				ultimaPosicionLabel.isHidden = true
				mensajeButton.isHidden = false
				rutaButton.isHidden = false
				llamarButton.isHidden = false
			} else {
				ultimaPosicionLabel.isHidden = false
				mensajeButton.isHidden = true
				rutaButton.isHidden = true
				llamarButton.isHidden = true
			}
            
            if integranteMapa.muestraRuta {
                rutaButton.setTitle("Ocultar Ruta", for: .normal)
            } else {
                rutaButton.setTitle("Ver Ruta", for: .normal)
            }
		}
	}
	
	let servicioLabel = UILabel(text: "Servicio", font: .boldSystemFont(ofSize: 14), textColor: #colorLiteral(red: 0.1840000004, green: 0.4390000105, blue: 0.6589999795, alpha: 1), textAlignment: .center)
	let dividerView = UIView(backgroundColor: #colorLiteral(red: 0.1840000004, green: 0.4390000105, blue: 0.6589999795, alpha: 1))
	let perfilImageView = UIImageView()
	let nombreLabel = UILabel(text: "Nombre: ApPaterno ApMaterno", font: .boldSystemFont(ofSize: 12), textColor: .black)
	let telefonoLabel = UILabel(text: "Teléfono: 55555555", font: .boldSystemFont(ofSize: 12), textColor: .black)
	let ultimaPosicionLabel = UILabel(text: "Última Posición", font: .boldSystemFont(ofSize: 12), textColor: .black)
	let fechaLabel = UILabel(text: "Fecha: 2020-04-15", font: .boldSystemFont(ofSize: 12), textColor: .black)
	let horaLabel = UILabel(text: "Hora: 14:29:30", font: .boldSystemFont(ofSize: 12), textColor: .black)
	lazy var mensajeButton = UIButton(title: "Mensaje", titleColor: #colorLiteral(red: 0, green: 0.6710000038, blue: 0.9330000281, alpha: 1), font: .systemFont(ofSize: 12), target: self, action: nil)
	lazy var rutaButton = UIButton(title: "Ver Ruta", titleColor: #colorLiteral(red: 0, green: 0.6710000038, blue: 0.9330000281, alpha: 1), font: .systemFont(ofSize: 12), target: self, action: #selector(verRuta))
	lazy var llamarButton = UIButton(title: "Llamar", titleColor: #colorLiteral(red: 0.1570000052, green: 0.6549999714, blue: 0.2709999979, alpha: 1), font: .systemFont(ofSize: 12), target: self, action: nil)
	
	// MARK: - Init
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupViewComponents()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Helpers
	
	fileprivate func setupViewComponents() {
		layer.cornerRadius = 10
		backgroundColor = .white
		
		perfilImageView.backgroundColor = .red
		perfilImageView.layer.cornerRadius = 10
		perfilImageView.clipsToBounds = true
		
		mensajeButton.roundedCornersButton(cornerRadius: 5, borderColor: #colorLiteral(red: 0, green: 0.6710000038, blue: 0.9330000281, alpha: 1))
		rutaButton.roundedCornersButton(cornerRadius: 5, borderColor: #colorLiteral(red: 0, green: 0.6710000038, blue: 0.9330000281, alpha: 1))
		llamarButton.roundedCornersButton(cornerRadius: 5, borderColor: #colorLiteral(red: 0.1570000052, green: 0.6549999714, blue: 0.2709999979, alpha: 1))
		
		hstack(perfilImageView.withWidth(120),
			   stack(servicioLabel,
					 dividerView.withHeight(1),
					 nombreLabel,
					 telefonoLabel,
					 ultimaPosicionLabel,
					 hstack(fechaLabel,
							horaLabel),
					 hstack(mensajeButton,
							rutaButton,
							spacing: 4,
							distribution: .fillEqually),
					 llamarButton,
					 UIView(),
					 spacing: 4),
			   spacing: 4,
			   distribution: .fillProportionally).withMargins(.allSides(8))
	}
	
	func setAttributedText(title: String, body: String) -> NSAttributedString {
		let attributedString = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
		let bodyString = NSAttributedString(string: body, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
		attributedString.append(bodyString)
		return attributedString
	}
    
    func cambiarBoton() {
        if integranteMapa.muestraRuta {
            rutaButton.setTitle("Ocultar Ruta", for: .normal)
        } else {
            rutaButton.setTitle("Ver Ruta", for: .normal)
        }
    }
	
	// MARK: - Selectors
	
	@objc func verRuta(_ sender: UIButton) {
		if integranteMapa.muestraRuta {
            delegate?.integranteMapaView(self, ocultoLaRutaDelIntegrante: integranteMapa)
		} else {
			delegate?.integranteMapaView(self, mostroLaRutaDelIntegrante: integranteMapa)
		}
	}
	
}

