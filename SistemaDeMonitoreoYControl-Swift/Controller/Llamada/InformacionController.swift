//
//  InformacionController.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 24/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

class InformacionController: LBTAFormController {
    
    let informacionIntegranteView = InformacionIntegranteView()
    let generarReporteView = GenerarReporteView()
    
    var llamada: Llamada! {
        didSet {
            navigationItem.title = llamada.modo.nombre
            informacionIntegranteView.informacionIntegrante = llamada.usuario
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewComponents()
    }
    
    fileprivate func setupViewComponents() {
        view.backgroundColor = #colorLiteral(red: 0.2039999962, green: 0.2269999981, blue: 0.2509999871, alpha: 1)
        
        
        navigationItem.leftBarButtonItem = .init(title: "Atrás", style: .plain, target: self, action: #selector(handleBack))
        
        let informacionStack = UIView()
        informacionStack.stack(informacionIntegranteView,
                               generarReporteView)
        
        formContainerStackView.addArrangedSubview(informacionStack)
    }
    
    @objc fileprivate func handleBack() {
        dismiss(animated: true, completion: nil)
    }

}


