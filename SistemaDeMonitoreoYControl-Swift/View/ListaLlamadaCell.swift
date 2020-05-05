//
//  ListaLlamadaCell.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 21/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

class ListaLlamadaCell: UITableViewCell {
    
    // MARK: - Properties
    
    var llamada: Llamada! {
        didSet {
            nombreLabel.text = "\(llamada.usuario.nombre) \(llamada.usuario.apellidoPaterno) \(llamada.usuario.apellidoMaterno)"
            tipoLlamadaLabel.text = llamada.modo.nombre
            telefonoLabel.text = llamada.usuario.idUsuariosMovil
            fechaHoraLabel.text = "\(llamada.registro.fecha) \(llamada.registro.hora)"
            
            if llamada.registro.estado == .enEspera {
                backgroundColor = #colorLiteral(red: 0.3102680147, green: 0.6782981157, blue: 0.4890297651, alpha: 1)
            } else if llamada.registro.estado == .atendida {
                backgroundColor = #colorLiteral(red: 0.5019999743, green: 0.5019999743, blue: 0.5019999743, alpha: 1)
            } else {
                backgroundColor = #colorLiteral(red: 0.7398121953, green: 0.3820734024, blue: 0.3775727153, alpha: 1)
            }
        }
    }
    
    let nombreLabel = UILabel(text: "Nombre ApMaterno ApPaterno", font: .boldSystemFont(ofSize: 14), textColor: .white, textAlignment: .left)
    let tipoLlamadaLabel = UILabel(text: "Video-Llamada Entrante", font: .systemFont(ofSize: 12), textColor: .white, textAlignment: .left)
    let telefonoLabel = UILabel(text: "555555555", font: .boldSystemFont(ofSize: 14), textColor: .white, textAlignment: .right)
    let fechaHoraLabel = UILabel(text: "2020-05-05 10:04:05", font: .systemFont(ofSize: 12), textColor: .white, textAlignment: .right)
    
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
        hstack(stack(nombreLabel,
                     tipoLlamadaLabel),
               stack(telefonoLabel,
                     fechaHoraLabel)).withMargins(.allSides(8))
    }
}
