//
//  IntegrantesView.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/13/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

// MARK: - Protocol IntegrantesViewDelegate

protocol IntegrantesViewDelegate: class {
	func mostrarRegistro(delIntegrante integrante: Integrante)
	func seleccionoIntegrante(_ integrante: Integrante)
}

class IntegrantesView: BaseCardView {
	
	// MARK: - Properties
	
	weak var delegate: IntegrantesViewDelegate?
	var integrantes = [Integrante]()
	
	fileprivate let cellId = "cellId"
	
	lazy var tableView: UITableView = {
		let tv = UITableView()
		tv.register(IntegranteCell.self, forCellReuseIdentifier: cellId)
		tv.delegate = self
		tv.dataSource = self
		tv.tableFooterView = UIView()
		tv.backgroundColor = #colorLiteral(red: 0.2039999962, green: 0.2269999981, blue: 0.2509999871, alpha: 1)
		tv.separatorColor = .lightGray
		return tv
	}()
	
	// MARK: - Init
	
	override init(title: String?, estado: Estado?) {
		super.init(title: title, estado: estado)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Helpers
	
	override func setupViewComponents() {
		super.setupViewComponents()
		
		addSubview(tableView)
		tableView.anchor(top: headerView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
		tableView.layer.masksToBounds = true
		tableView.layer.cornerRadius = cornerRadius
		tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
	}
	
	func reload() {
		tableView.reloadData()
	}
}

// MARK: - UITableViewDataSource

extension IntegrantesView: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return integrantes.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! IntegranteCell
		cell.integrante = integrantes[indexPath.row]
		cell.indice = indexPath
		cell.delegate = self
		return cell
	}
}

// MARK: - UITableViewDelegate

extension IntegrantesView: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 40
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let integrante = integrantes[indexPath.row]
		if integrante.getLat() != 0.0 {
			delegate?.seleccionoIntegrante(integrante)
		} 
	}
}

// MARK: - IntegranteDelegate

extension IntegrantesView: IntegranteDelegate {
	func seleccionoIntegrante(_ integrante: Integrante, enElIndice indice: IndexPath) {
		delegate?.mostrarRegistro(delIntegrante: integrante)
	}
}
