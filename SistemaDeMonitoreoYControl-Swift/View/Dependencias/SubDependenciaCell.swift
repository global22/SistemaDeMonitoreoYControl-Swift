//
//  SubDependenciaCell.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 07/05/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

class SubDependenciaCell: UITableViewCell {
    
    let nombreLabel = UILabel(text: "Nombre", font: .systemFont(ofSize: 16), textColor: .white)
    let blurView = DarkBlurView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViewComponents() {
        selectionStyle = .none
        backgroundColor = #colorLiteral(red: 0.2039999962, green: 0.2269999981, blue: 0.2509999871, alpha: 1)
        
        insertSubview(blurView, at: 0)
        blurView.fillSuperview()
        
        addSubview(nombreLabel)
        nombreLabel.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    
}
