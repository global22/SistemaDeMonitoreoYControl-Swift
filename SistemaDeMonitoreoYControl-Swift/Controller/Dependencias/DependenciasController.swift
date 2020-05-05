//
//  DependenciasController.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 22/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

class DependenciasController: UICollectionViewController {
    
    // MARK: - Properties
    
    fileprivate let identifier = "identifier"
    fileprivate let headerIdentifier = "headerIdentifier"
    
    var dependencias = [AtributosDependencia]()
    
    // MARK: - Init
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Dependencias"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background.jpg"))
        collectionView.register(DependenciaCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.register(DependenciasHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        fetchDependencias()
    }
    
    // MARK: - Helpers
    
    fileprivate func fetchDependencias() {
        Service.shared.obtenerDependencias { (res) in
            switch res {
            case .failure(_):
                break
            case .success(let dependencia):
                for (_, value) in dependencia.nombre {
//                    print("\(value.alias)")
//                    print("Nivel 1 \(value.nivel["nivel 1"]?.nombre)")
//                    for (_, val) in value.nivel["nivel 1"]!.nombre {
//                        print("Nivel 2\(val.nivel["nivel 2"]?.nombre)")
//                        for (_, v) in val.nivel["nivel 2"]!.nombre {
//                            print("Nivel 3 \(v.nivel["nivel 3"]?.nombre)")
//                        }
//                    }
                    self.dependencias.append(value)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dependencias.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! DependenciaCell
        cell.dependencia = dependencias[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! DependenciasHeaderView
        return view
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dependencia = dependencias[indexPath.item]
        let controller = SubDependenciasController()
        controller.dependencia = dependencia
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DependenciasController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 100, left: 100, bottom: 100, right: 100)
    }
}
