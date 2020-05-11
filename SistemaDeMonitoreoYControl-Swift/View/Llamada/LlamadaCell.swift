//
//  LlamadaCell.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 06/05/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit

class LlamadaCell: UICollectionViewCell {

    var llamada: Llamada! {
        didSet {
            nombreLabel.text = "\(llamada.usuario.nombre) \(llamada.usuario.apellidoPaterno) \(llamada.usuario.apellidoMaterno)"
            
            if let subscriberView = llamada.subscriber?.view {
                insertSubview(subscriberView, at: 0)
                subscriberView.frame = bounds
            }
        }
    }
    
    let nombreLabel = UILabel(text: "Nombre", font: .boldSystemFont(ofSize: 14), textColor: .white, textAlignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    fileprivate func setupViewComponents() {
        layer.cornerRadius = 15
        clipsToBounds = true
        
        nombreLabel.backgroundColor = .black
        
        addSubview(nombreLabel)
        nombreLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 30))
        
        
    }
}
