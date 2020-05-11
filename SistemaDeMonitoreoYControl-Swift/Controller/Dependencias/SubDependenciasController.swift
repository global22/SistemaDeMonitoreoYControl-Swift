//
//  SubDependenciasController.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 22/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

class SubDependenciasController: UITableViewController {
    
    fileprivate let identifier = "identifier"
    fileprivate let selfIdentifier = "selfIdentifier"
    
    var dismissHandler: (() -> ())?
    
    var nivel: String!
    
    var dependencia: AtributosDependencia! {
        didSet {
            dependencia.nivel.forEach {
                nivel = $0.key
            }
            dependencia.nivel[nivel]!.nombre.forEach {
                subDependencias.append($0.value)
                tableView.reloadData()
            }
            let urlImagen = "https://recursos360.ml/sedena/Img/Logos/\(dependencia.nombre.lowercased())360.png"
            UserDefaults.standard.set(urlImagen, forKey: Constants.urlImagenDependencia)
            
            let socketUrl = dependencia.url.replacingOccurrences(of: "https", with: "wss")
            dependencia.socketUrl = socketUrl
        }
    }
    
    var subDependencia: AtributosDependencia? {
        didSet {
            if let subDependencia = subDependencia {
                subDependencia.nivel.forEach {
                    nivel = $0.key
                }
                if nivel != nil {
                    subDependencia.nivel[nivel]!.nombre.forEach {
                        subDependencias.append($0.value)
                        tableView.reloadData()
                    }
                }
                
            }
            let socketUrl = subDependencia?.url.replacingOccurrences(of: "https", with: "wss")
            subDependencia?.socketUrl = socketUrl
        }
    }
    
    var subDependencias = [AtributosDependencia]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if nivel != nil {
            navigationItem.title = subDependencia != nil ? subDependencia?.nivel[nivel]?.alias : dependencia.nivel[nivel]?.alias
        }
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background.jpg"))
        tableView.register(SubDependenciaCell.self, forCellReuseIdentifier: identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: selfIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(font: .boldSystemFont(ofSize: 18), textColor: .white, textAlignment: .left)
        label.backgroundColor = .clear
        if section == 0 {
            if nivel != nil {
                label.text = "\t\(nivel.capitalizeFirstLetter())"
            }
        } else {
            label.text = "\tDependencia"
        }
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return subDependencias.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SubDependenciaCell
        if indexPath.section == 0 {
            cell.nombreLabel.text = subDependencias[indexPath.row].alias
        } else {
            cell.nombreLabel.text = subDependencia != nil ? "Elegir \(subDependencia?.alias ?? "")" : "Elegir \(dependencia.alias)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if nivel != nil {
                let subDependencia = subDependencias[indexPath.row]
                let subDependenciasController = SubDependenciasController()
                subDependenciasController.subDependencia = subDependencia
                subDependenciasController.dismissHandler = self.dismissHandler
                navigationController?.pushViewController(subDependenciasController, animated: true)
            }
        } else {
            if let subDependencia = subDependencia {
                UserDefaults.standard.set(subDependencia.alias, forKey: Constants.dependencia)
                UserDefaults.standard.set(subDependencia.url, forKey: Constants.baseUrl)
                UserDefaults.standard.set(subDependencia.socketUrl, forKey: Constants.baseSocketUrl)
//                print(subDependencia.socketUrl)
            } else {
                UserDefaults.standard.set(dependencia.alias, forKey: Constants.dependencia)
                UserDefaults.standard.set(dependencia.url, forKey: Constants.baseUrl)
                UserDefaults.standard.set(dependencia.socketUrl, forKey: Constants.baseSocketUrl)
//                print(dependencia.url)
            }
            dismissHandler?()
        }
    }
}
