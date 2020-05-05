//
//  RegistroRutasView.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/13/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools
import FSCalendar

// MARK: - Protocol RegistroRutasDelegate

protocol RegistroRutasDelegate: class {
	func seleccionoRuta(delIntegrante integrante: InformacionIntegrante, enLaFecha fecha: String)
}

class RegistroRutasView: BaseCardView {
	
	// MARK: - Properties
	
	weak var delegate: RegistroRutasDelegate?
	
	var informacionIntegrante: InformacionIntegrante? {
		didSet {
			calendar.reloadData()
		}
	}
	
	let informacionIntegranteView = InformacionIntegranteView()
	let informacionGeneralLabel = UILabel(text: "  INFORMACIÓN GENERAL", font: .boldSystemFont(ofSize: 16), textColor: .white, textAlignment: .left)
	let historialRutaLabel = UILabel(text: "  Historial de Ruta", font: .boldSystemFont(ofSize: 16), textColor: .white, textAlignment: .left)
	
	lazy var calendar: FSCalendar = {
		let calendar = FSCalendar()
		calendar.dataSource = self
		calendar.delegate = self
		calendar.backgroundColor = .white
		calendar.layer.masksToBounds = true
		calendar.layer.cornerRadius = 10
		calendar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
		calendar.locale = Locale(identifier: "es_MX")
		calendar.appearance.borderRadius = 0
		calendar.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
		return calendar
	}()
	
	lazy var dateFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "YYYY-MM-dd"
		return df
	}()
	
	// MARK: - Init
	
	override init(title: String?, estado: Estado?) {
		super.init(title: title, estado: estado)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Helpers
	
	override func setupViewComponents() {
		super.setupViewComponents()
		informacionGeneralLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5879999995, blue: 0.6629999876, alpha: 1)
		historialRutaLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5879999995, blue: 0.6629999876, alpha: 1)
		
		addSubview(informacionGeneralLabel)
		informacionGeneralLabel.anchor(top: headerView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 30))
		
		addSubview(informacionIntegranteView)
		informacionIntegranteView.anchor(top: informacionGeneralLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
		
		addSubview(historialRutaLabel)
		historialRutaLabel.anchor(top: informacionIntegranteView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 30))
		
		addSubview(calendar)
		calendar.anchor(top: historialRutaLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
	}
}

// MARK: - FSCalendarDataSource

extension RegistroRutasView: FSCalendarDataSource {
	
}

// MARK: - FSCalendarDelegate

extension RegistroRutasView: FSCalendarDelegate {
	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		let formattedDate = dateFormatter.string(from: date)
		if let informacionIntegrante = informacionIntegrante {
			delegate?.seleccionoRuta(delIntegrante: informacionIntegrante, enLaFecha: formattedDate)
		}
	}
	
	func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
		let formattedDate = dateFormatter.string(from: date)
		if let dates = informacionIntegrante?.fechasRutas {
			for date in dates {
				if formattedDate == date.fecha {
					return true
				}
			}
		}
		return false
	}
}


// MARK: - FSCalendatDelegateAppearence

extension RegistroRutasView: FSCalendarDelegateAppearance {
	func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
		let formattedDate = dateFormatter.string(from: date)
		guard let dates = informacionIntegrante?.fechasRutas else { return nil }
		var datesArray = [String]()
		dates.forEach {
			if let fecha = $0.fecha {
				datesArray.append(fecha)
			}
		}
		if !datesArray.contains(formattedDate) {
			return .lightGray
		} else {
			return .black
		}
	}
}
