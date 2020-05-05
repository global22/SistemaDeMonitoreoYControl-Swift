//
//  DependenciasHeaderView.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 22/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

class DependenciasHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    let informacionLabel = UILabel(text: "Para poder acceder a la plataforma deberá primero seleccionar la dependencia a la que requiere iniciar", font: .boldSystemFont(ofSize: 24), textColor: .white, textAlignment: .left, numberOfLines: 0)
    
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
        backgroundColor = .clear
        
        addSubview(informacionLabel)
        informacionLabel.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        
    }
}
