//
//  GenerarReporteCell.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 04/05/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

class GenerarReporteCell: UICollectionViewCell {
    
    let generarReporteLabel = UILabel(text: " Generar Reporte", font: .systemFont(ofSize: 14), textColor: .white, textAlignment: .left)
    let incidentesCercanosLabel = UILabel(text: " Incidentes Cercanos", font: .systemFont(ofSize: 16), textColor: .white, textAlignment: .left)
    lazy var generarReporteButton = UIButton(title: "Generar nuevo reporte \t2020-05-04", titleColor: .white, font: .systemFont(ofSize: 14), backgroundColor: #colorLiteral(red: 0, green: 0.6710000038, blue: 0.9330000281, alpha: 1), target: self, action: nil)
    let reportesView = UIView(backgroundColor: .white)
    let detallarReporteLabel = UILabel(text: " Detallar Reporte", font: .systemFont(ofSize: 16), textColor: .white, textAlignment: .left)
    
    let descripcionLugarLabel = UILabel(text: "Descripción del Lugar", font: .systemFont(ofSize: 12), textColor: #colorLiteral(red: 0.9959999919, green: 0.5099999905, blue: 0.00400000019, alpha: 1), textAlignment: .left)
    let descripcionLugarTextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    fileprivate func setupViewComponents() {
        backgroundColor = #colorLiteral(red: 0.2039999962, green: 0.2269999981, blue: 0.2509999871, alpha: 1)
        
        generarReporteLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5879999995, blue: 0.6629999876, alpha: 1)
        incidentesCercanosLabel.backgroundColor = #colorLiteral(red: 0.5019999743, green: 0.5019999743, blue: 0.5019999743, alpha: 1)
        
        generarReporteButton.layer.cornerRadius = 15
        
        reportesView.layer.cornerRadius = 10
        
        detallarReporteLabel.backgroundColor = #colorLiteral(red: 0.5019999743, green: 0.5019999743, blue: 0.5019999743, alpha: 1)
        
        addSubview(generarReporteLabel)
        generarReporteLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 20))
        
        addSubview(incidentesCercanosLabel)
        incidentesCercanosLabel.anchor(top: generarReporteLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 30))
        
        addSubview(generarReporteButton)
        generarReporteButton.anchor(top: incidentesCercanosLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 32, bottom: 8, right: 32), size: .init(width: 0, height: 50))
        
        addSubview(reportesView)
        reportesView.anchor(top: generarReporteButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8), size: .init(width: 0, height: 70))
        
        addSubview(detallarReporteLabel)
        detallarReporteLabel.anchor(top: reportesView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        
        addSubview(descripcionLugarLabel)
        descripcionLugarLabel.anchor(top: detallarReporteLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 0))
        
        addSubview(descripcionLugarTextView)
        descripcionLugarTextView.anchor(top: descripcionLugarLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 70))
    }
}

