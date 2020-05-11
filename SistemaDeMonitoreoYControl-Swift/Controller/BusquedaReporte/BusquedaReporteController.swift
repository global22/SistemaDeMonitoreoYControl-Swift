//
//  BusquedaReporteController.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 08/05/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

class BusquedaReporteController: BaseViewController {
    
    let busquedaReporteView = BusquedaReporteView(title: "Buscar Reporte", estado: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(busquedaReporteView)
        busquedaReporteView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 8, left: 8, bottom: 8, right: 0), size: .init(width: 320, height: 0))
    }
    
}
