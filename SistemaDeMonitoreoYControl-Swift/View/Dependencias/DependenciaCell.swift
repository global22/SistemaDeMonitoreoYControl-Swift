//
//  DependenciaCell.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 22/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

class DependenciaCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var dependencia: AtributosDependencia! {
        didSet {
            nombreLabel.text = dependencia.alias
        }
    }
    
    let nombreLabel = UILabel(text: "Nombre", font: .boldSystemFont(ofSize: 20), textColor: .white, textAlignment: .center, numberOfLines: 0)
    
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
        backgroundColor = #colorLiteral(red: 0.2039999962, green: 0.2269999981, blue: 0.2509999871, alpha: 1)
        
        addSubview(nombreLabel)
        nombreLabel.centerInSuperview()
    }
    
}
