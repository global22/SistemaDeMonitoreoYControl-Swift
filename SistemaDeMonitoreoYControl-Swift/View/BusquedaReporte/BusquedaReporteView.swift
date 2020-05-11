//
//  BusquedaReporteView.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 08/05/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools
import FSCalendar

class BusquedaReporteView: BaseCardView {
    
    let busquedaFolioLabel = UILabel(text: " Búsqueda por folio externo", font: .boldSystemFont(ofSize: 16), textColor: .white, textAlignment: .left)
    let folioSearchBar = UISearchBar()
    let busquedaFechaLabel = UILabel(text: " Búsqueda por fecha", font: .boldSystemFont(ofSize: 16), textColor: .white, textAlignment: .left)
    
    let llamadasAtendidasSwitch = CustomSwitch()
    let llamadasAtendidasLabel = UILabel(text: "Mis llamadas atendidas", font: .systemFont(ofSize: 14), textColor: .white)
    
    let todasLlamadasAtendidasSwitch = CustomSwitch()
    let todasLlamadasAtendidasLabel = UILabel(text: "Todas las llamadas atendidas", font: .systemFont(ofSize: 14), textColor: .white)
    
    let todasLlamadasPerdidasSwitch = CustomSwitch()
    let todasLlamadasPerdidasLabel = UILabel(text: "Todas las llamadas perdidas", font: .systemFont(ofSize: 14), textColor: .white)
    
    let llamadaSigilosoSwitch = CustomSwitch()
    let llamadaSigilosoLabel = UILabel(text: "Llamadas en modo sigiloso", font: .systemFont(ofSize: 14), textColor: .white)
    
    let videoLlamadasSwitch = CustomSwitch()
    let videoLlamadasLabel = UILabel(text: "Video llamadas", font: .systemFont(ofSize: 14), textColor: .white)
    
    let llamadasVozSwitch = CustomSwitch()
    let llamadasVozLabel = UILabel(text: "Llamadas de voz", font: .systemFont(ofSize: 14), textColor: .white)
    
    let comunicacionChatSwitch = CustomSwitch()
    let comunicacionChatLabel = UILabel(text: "Comunicación por chat", font: .systemFont(ofSize: 14), textColor: .white)
    
    lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = .white
        calendar.locale = Locale(identifier: "es_MX")
        calendar.appearance.borderRadius = 0
        calendar.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
        return calendar
    }()
    
    override init(title: String?, estado: BaseCardView.Estado?) {
        super.init(title: title, estado: estado)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func setupViewComponents() {
        super.setupViewComponents()
        
        closeButton.isHidden = true
        
        busquedaFolioLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5879999995, blue: 0.6629999876, alpha: 1)
        folioSearchBar.barTintColor = #colorLiteral(red: 0.2039999962, green: 0.2269999981, blue: 0.2509999871, alpha: 1)
        if #available(iOS 13.0, *) {
            folioSearchBar.searchTextField.backgroundColor = .white
        } else {
            // Fallback on earlier versions
            folioSearchBar.subviews.forEach {
                if let textView = $0 as? UITextView {
                    textView.backgroundColor = .white
                }
            }
        }
        busquedaFechaLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5879999995, blue: 0.6629999876, alpha: 1)
        
        let stackView = UIView()
        
        stackView.stack(busquedaFolioLabel.withHeight(40),
                        folioSearchBar,
                        busquedaFechaLabel.withHeight(40),
                        calendar.withHeight(250),
                        hstack(llamadasAtendidasSwitch,
                               llamadasAtendidasLabel,
                            spacing: 4).padTop(4).padLeft(4),
                        hstack(todasLlamadasAtendidasSwitch,
                               todasLlamadasAtendidasLabel,
                            spacing: 4).padTop(4).padLeft(4),
                        hstack(todasLlamadasPerdidasSwitch,
                               todasLlamadasPerdidasLabel,
                            spacing: 4).padTop(4).padLeft(4),
                        hstack(llamadaSigilosoSwitch,
                               llamadaSigilosoLabel,
                            spacing: 4).padTop(4).padLeft(4),
                        hstack(videoLlamadasSwitch,
                               videoLlamadasLabel,
                            spacing: 4).padTop(4).padLeft(4),
                        hstack(llamadasVozSwitch,
                               llamadasVozLabel,
                            spacing: 4).padTop(4).padLeft(4),
                        hstack(comunicacionChatSwitch,
                               comunicacionChatLabel,
                            spacing: 4).padTop(4).padLeft(4),
                        UIView())
        
        addSubview(stackView)
        stackView.anchor(top: headerView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
}

// MARK: - FSCalendarDataSource

extension BusquedaReporteView: FSCalendarDataSource {
    
}

// MARK: - FSCalendarDelegate

extension BusquedaReporteView: FSCalendarDelegate {
    
}
