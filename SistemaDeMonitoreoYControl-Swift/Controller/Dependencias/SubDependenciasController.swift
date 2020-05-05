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
        }
    }
    
    var subDependencias = [AtributosDependencia]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = dependencia.nivel["nivel 1"]?.alias
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subDependencias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = subDependencias[indexPath.row].alias
        return cell
    }
}
