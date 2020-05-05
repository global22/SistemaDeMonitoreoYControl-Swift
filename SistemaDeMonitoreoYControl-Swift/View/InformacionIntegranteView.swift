//
//  InformacionIntegranteView.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/14/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools
import SDWebImage

class InformacionIntegranteView: UIView {
	// MARK: - Properties
	
	var informacionIntegrante: InformacionIntegrante! {
		didSet {
			configurarLabel(idLabel, titulo: "ID: ", descripcion: informacionIntegrante.telefono)
			configurarLabel(nombreLabel, titulo: "Nombre: ", descripcion: "\(informacionIntegrante.nombre) \(informacionIntegrante.apellidoPaterno) \(informacionIntegrante.apellidoMaterno)")
			configurarLabel(direccionLabel, titulo: "Dirección: ", descripcion: informacionIntegrante.direccion)
			configurarLabel(fechaNacimientoLabel, titulo: "Fecha de nacimiento: ", descripcion: informacionIntegrante.fechaNacimiento)
			configurarLabel(telefonoLabel, titulo: "Teléfono: ", descripcion: informacionIntegrante.telefono)
			configurarLabel(emailLabel, titulo: "E-mail: ", descripcion: informacionIntegrante.correo)
			configurarLabel(generoLabel, titulo: "Género: ", descripcion: informacionIntegrante.genero)
			configurarLabel(rhLabel, titulo: "RH: ", descripcion: informacionIntegrante.rh)
			configurarLabel(condicionMedicaLabel, titulo: "Condición Médica: ", descripcion: informacionIntegrante.condicionMedica)
			configurarLabel(alergiasLabel, titulo: "Alergias: ", descripcion: informacionIntegrante.alergias)
			configurarLabel(nombreEmergenciaLabel, titulo: nil, descripcion: informacionIntegrante.contactoNombre)
			configurarLabel(telefonoEmergenciaLabel, titulo: nil, descripcion: informacionIntegrante.contactoTelefono)
			configurarImageView(img: informacionIntegrante.img ?? "")
		}
	}
	
	let idLabel = UILabel(text: "ID: 555555555")
	let nombreLabel = UILabel(text: "Nombre: Nombre ApellidoP ApellidoM", numberOfLines: 0)
	let direccionLabel = UILabel(text: "Direccion: Direccion")
	let fechaNacimientoLabel = UILabel(text: "Fecha de nacimiento: 1999-12-31")
	let telefonoLabel = UILabel(text: "Telefono: 555555555")
	let emailLabel = UILabel(text: "E-mail: aljsdbflasbdf")
	let generoLabel = UILabel(text: "Genero: Masculino")
	let rhLabel = UILabel(text: "RH: O+")
	let condicionMedicaLabel = UILabel(text: "Condicion Medica: Buena", numberOfLines: 0)
	let alergiasLabel = UILabel(text: "Alergias: Niguna")
	let nombreEmergenciaLabel = UILabel(text: "Nombre")
	let telefonoEmergenciaLabel = UILabel(text: "555555555")
	let integranteImageView = UIImageView()
	
	// MARK: - Init
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupViewComponents()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Helpers
	
	func setupViewComponents() {
        backgroundColor = #colorLiteral(red: 0.2039999962, green: 0.2269999981, blue: 0.2509999871, alpha: 1)

		let contactosDeEmergenciaLabel = UILabel(text: "\tCONTACTOS DE EMERGENCIA", font: .systemFont(ofSize: 16), textColor: .white, textAlignment: .left)
		contactosDeEmergenciaLabel.backgroundColor = .black
		contactosDeEmergenciaLabel.withHeight(20)
		
		integranteImageView.layer.cornerRadius = 15
		integranteImageView.layer.masksToBounds = true
		integranteImageView.clipsToBounds = true
        integranteImageView.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.4392156863, blue: 0.6588235294, alpha: 1)
		
		let stackView = stack(stack(hstack(integranteImageView.withSize(.init(width: 100, height: 110)),
										   stack(idLabel,
												 nombreLabel,
												 spacing: 8),
										   spacing: 16,
										   alignment: .center),
									stack(direccionLabel,
										  fechaNacimientoLabel,
										  hstack(telefonoLabel,
												 UIView(),
												 emailLabel),
										  hstack(generoLabel,
												 UIView(),
												 rhLabel),
										  hstack(condicionMedicaLabel,
												 UIView(),
												 alergiasLabel),
										  spacing: 4).padTop(8)).withMargins(.allSides(8)),
							  contactosDeEmergenciaLabel,
							  hstack(nombreEmergenciaLabel,
									 UIView(),
									 telefonoEmergenciaLabel).withMargins(.init(top: 4, left: 32, bottom: 4, right: 32)))
		
		addSubview(stackView)
	}
	
	func configurarImageView(img: String) {
		if img == "" {
			integranteImageView.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.4392156863, blue: 0.6588235294, alpha: 1)
		}
		integranteImageView.sd_setImage(with: URL(string: img), completed: nil)
	}
	
	func configurarLabel(_ label: UILabel, titulo: String?, descripcion: String) {
		let tituloAttributedString: NSMutableAttributedString!
		let descripcionAttributedString = NSAttributedString(string: descripcion, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
		if let titulo = titulo {
			tituloAttributedString = NSMutableAttributedString(string: titulo, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9959999919, green: 0.5099999905, blue: 0.00400000019, alpha: 1)])
			tituloAttributedString.append(descripcionAttributedString)
			label.attributedText = tituloAttributedString
		} else {
			label.attributedText = descripcionAttributedString
		}
	}
}
