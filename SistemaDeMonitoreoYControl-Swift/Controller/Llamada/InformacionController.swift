//
//  InformacionController.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 24/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit

class InformacionController: UICollectionViewController {
    
    fileprivate let informacionCellId = "informacionCellId"
    fileprivate let generarReporteCellId = "generarReporteCellId"
    
    var llamada: Llamada! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Información"
        navigationItem.leftBarButtonItem = .init(title: "Atrás", style: .plain, target: self, action: #selector(handleBack))
        
        collectionView.register(InformacionCell.self, forCellWithReuseIdentifier: informacionCellId)
        collectionView.register(GenerarReporteCell.self, forCellWithReuseIdentifier: generarReporteCellId)
    }
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: informacionCellId, for: indexPath) as! InformacionCell
            cell.informacionIntegranteView.informacionIntegrante = llamada.usuario
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: generarReporteCellId, for: indexPath) as! GenerarReporteCell
            return cell
        }
    }
}

extension InformacionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 200
        if indexPath.item == 0 {
            let cell = InformacionCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
            let estimatedSize = cell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
            height = estimatedSize.height
        } else if indexPath.item == 1 {
            let cell = GenerarReporteCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
            let estimatedSize = cell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
            height = estimatedSize.height
        }
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
