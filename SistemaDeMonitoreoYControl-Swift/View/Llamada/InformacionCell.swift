//
//  InformacionCell.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 24/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit

class InformacionCell: UICollectionViewCell {
    
    let informacionIntegranteView = InformacionIntegranteView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(informacionIntegranteView)
        informacionIntegranteView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
