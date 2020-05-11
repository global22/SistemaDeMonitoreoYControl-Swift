//
//  GruposView.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/13/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

// MARK: - Protocol GruposViewDelegate

protocol GruposViewDelegate: class {
	func mostrarIntegrantes(_ integrantes: [Integrante], delGrupo grupo: String)
	func gruposView(_ gruposView: GruposView, mostroIntegrantes integrantes: [IntegranteMapa])
	func gruposView(_ gruposView: GruposView, ocultoIntegrantes integrantes: [String])
    func recargarGruposView(_ gruposView: GruposView)
}

// MARK: - Class GruposView

class GruposView: BaseCardView {
	
	// MARK: - Properties
	
    let refreshControl = UIRefreshControl()
	weak var delegate: GruposViewDelegate?
	var gruposAutomaticos = [GrupoAutomatico]()
	var gruposPersonalizados = [GrupoPersonalizado]()
	var integrantes = [Integrante]()
	var integrantesActivos = [Integrante]()
	var integrantesMapa = [IntegranteMapa]()
	
	private let cellId = "cellId"
	private let grupoCellId = "grupoCellId"
	
	lazy var tableView: UITableView = {
		let tv = UITableView()
		tv.register(GrupoPersonalizadoCell.self, forCellReuseIdentifier: cellId)
		tv.register(GrupoAutomaticoCell.self, forCellReuseIdentifier: grupoCellId)
		tv.delegate = self
		tv.dataSource = self
		tv.tableFooterView = UIView()
		tv.backgroundColor = #colorLiteral(red: 0.2039999962, green: 0.2269999981, blue: 0.2509999871, alpha: 1)
        tv.refreshControl = refreshControl
        tv.separatorColor = .darkGray
		return tv
	}()
	
	lazy var gruposPersonalizadosSwitch = UISwitch()
	
	lazy var gruposPersonalizadosView: UIView = {
		let view = UIView(backgroundColor: #colorLiteral(red: 0.9959999919, green: 0.5099999905, blue: 0.00400000019, alpha: 1))
		gruposPersonalizadosSwitch.transform = .init(scaleX: 0.75, y: 0.75)
		gruposPersonalizadosSwitch.addTarget(self, action: #selector(seleccionarGruposPersonalizados), for: .valueChanged)
		let label = UILabel(text: "Grupos Personalizados", font: .boldSystemFont(ofSize: 14), textColor: .white)
		let stackView = hstack(gruposPersonalizadosSwitch,
							   label,
							   spacing: 8,
							   alignment: .center).padLeft(4)
		view.addSubview(stackView)
		stackView.centerYToSuperview()
		return view
	}()
	
	lazy var registradosLabel = UILabel(text: "Registrados: ", font: .systemFont(ofSize: 12), textColor: .white)
	lazy var activosLabel = UILabel(text: "Activos: ", font: .systemFont(ofSize: 12), textColor: .white)
	
	lazy var gruposAutomaticosSwitch = UISwitch()
	
	lazy var gruposAutomaticosView: UIView = {
		let view = UIView(backgroundColor: #colorLiteral(red: 0.9959999919, green: 0.5099999905, blue: 0.00400000019, alpha: 1))
		gruposAutomaticosSwitch.transform = .init(scaleX: 0.75, y: 0.75)
		gruposAutomaticosSwitch.addTarget(self, action: #selector(seleccionarGruposAutomaticos), for: .valueChanged)
		let label = UILabel(text: "Grupos Automáticos", font: .boldSystemFont(ofSize: 14), textColor: .white)
		let stackView = hstack(gruposAutomaticosSwitch,
							   stack(label,
							   hstack(registradosLabel,
									  activosLabel,
									  spacing: 4)),
							   spacing: 8).padLeft(4)
		view.addSubview(stackView)
		stackView.centerYToSuperview()
		return view
	}()
	
	lazy var nuevoGrupoButton = UIButton(image: #imageLiteral(resourceName: "new_group.png"), tintColor: .black, target: self, action: #selector(crearNuevoGrupo))
	
	lazy var nuevoGrupoView: UIView = {
		let view = UIView(backgroundColor: #colorLiteral(red: 0.9610000253, green: 0.9610000253, blue: 0.9610000253, alpha: 1))
		let label = UILabel(text: "Crear nuevo grupo", font: .boldSystemFont(ofSize: 14), textColor: .black)
		view.addSubview(label)
		label.centerInSuperview()
		view.addSubview(nuevoGrupoButton)
		nuevoGrupoButton.centerYToSuperview()
		nuevoGrupoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
		nuevoGrupoButton.withSize(.init(width: 30, height: 30))
		return view
	}()
	
	// MARK: - Init
	
	override init(title: String?, estado: Estado?) {
		super.init(title: title, estado: estado)
        
        refreshControl.addTarget(self, action: #selector(recargarGrupos), for: .valueChanged)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Helpers
	
	override func setupViewComponents() {
		super.setupViewComponents()
		
		closeButton.isHidden = true
		
		addSubview(tableView)
		tableView.anchor(top: headerView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
		tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
		tableView.layer.cornerRadius = cornerRadius
	}
	
	func reload() {
		tableView.reloadData()
	}
    
    func filtrarIntegrantesDeGrupoAutomatico(_ grupo: GrupoAutomatico) -> [Integrante] {
        var integrantesFiltrados = [Integrante]()
        grupo.integrantes.forEach { (idIntegrante) in
            self.integrantes.forEach { (integrante) in
                if integrante.idUsuarioMovil == idIntegrante && integrante.getLat() != 0.0 {
                    integrantesFiltrados.append(integrante)
                }
            }
        }
        return integrantesFiltrados
    }
    
    func filtrarIntegrantesDeGrupoPersonalizado(_ grupo: GrupoPersonalizado) -> [Integrante] {
        var integrantesFiltrados = [Integrante]()
        if let integrantesGrupo = grupo.integrantes {
            integrantesGrupo.forEach { (idIntegrante) in
                self.integrantes.forEach { (integrante) in
                    if integrante.idUsuarioMovil == idIntegrante && integrante.getLat() != 0.0 {
                        integrantesFiltrados.append(integrante)
                    }
                }
            }
        }
        return integrantesFiltrados
    }
	
	func mostrarGruposAutomaticos(_ mostrar: Bool) {
		for i in 0..<gruposAutomaticos.count {
			if gruposAutomaticos[i].integrantes.isEmpty {
				gruposAutomaticos[i].isSelected = mostrar
			}
			for j in 0..<gruposAutomaticos[i].integrantes.count {
				for k in 0..<integrantesActivos.count {
					if integrantesActivos[k].idUsuarioMovil == gruposAutomaticos[i].integrantes[j] {
						gruposAutomaticos[i].isSelected = mostrar
					}
				}
			}
		}
	}
	
	func mostrarGruposPersonalizados(_ mostrar: Bool) {
		for i in 0..<gruposPersonalizados.count {
            if let integrantes = gruposPersonalizados[i].integrantes {
                if integrantes.isEmpty {
                    gruposPersonalizados[i].isSelected = mostrar
                }
                for j in 0..<integrantes.count {
                    for k in 0..<integrantesActivos.count {
                        if integrantesActivos[k].idUsuarioMovil == integrantes[j] {
                            gruposPersonalizados[i].isSelected = mostrar
                        }
                    }
                }
            }
		}
	}
	
	func integrantesActivos<T>(deGrupos grupos: T) -> [Integrante] {
		var integrantesFiltrados = [Integrante]()
		if let grupos = grupos as? [GrupoPersonalizado] {
            grupos.forEach { (grupo) in
                self.filtrarIntegrantesDeGrupoPersonalizado(grupo).forEach {
                    integrantesFiltrados.append($0)
                }
            }
		} else if let grupos = grupos as? [GrupoAutomatico] {
            grupos.forEach { (grupo) in
                self.filtrarIntegrantesDeGrupoAutomatico(grupo).forEach {
                    integrantesFiltrados.append($0)
                }
            }
		}
		return integrantesFiltrados
	}
	
	func integrantesActivos<T>(deLosGrupos grupos: T) -> [String] {
		var integrantesFiltrados = [String]()
		if let grupos = grupos as? [GrupoPersonalizado] {
            grupos.forEach { (grupo) in
                self.filtrarIntegrantesDeGrupoPersonalizado(grupo).forEach({
                    integrantesFiltrados.append($0.idUsuarioMovil)
                })
            }
		} else if let grupos = grupos as? [GrupoAutomatico] {
            grupos.forEach { (grupo) in
                self.filtrarIntegrantesDeGrupoAutomatico(grupo).forEach({
                    integrantesFiltrados.append($0.idUsuarioMovil)
                })
            }
		}
		return integrantesFiltrados
	}
	
	func filtrarIntegrantesPorGrupo<T>(grupo: T) -> [Integrante] {
		var integrantesFiltrados = [Integrante]()
		if let grupo = grupo as? GrupoPersonalizado {
            integrantesFiltrados = filtrarIntegrantesDeGrupoPersonalizado(grupo)
		} else if let grupo = grupo as? GrupoAutomatico {
            integrantesFiltrados = filtrarIntegrantesDeGrupoAutomatico(grupo)
		}
		return integrantesFiltrados
	}
	
	func filtrarIntegrantesActivos<T>(porGrupo grupo: T) -> [String] {
		var integrantesFiltrados = [String]()
		if let grupo = grupo as? GrupoPersonalizado {
            filtrarIntegrantesDeGrupoPersonalizado(grupo).forEach {
                integrantesFiltrados.append($0.idUsuarioMovil)
            }
		} else if let grupo = grupo as? GrupoAutomatico {
            filtrarIntegrantesDeGrupoAutomatico(grupo).forEach {
                integrantesFiltrados.append($0.idUsuarioMovil)
            }
		}
		return integrantesFiltrados
	}
	
	func filtrarIntegrantesActivos<T>(porGrupo grupo: T) -> [Integrante] {
		var integrantesFiltrados = [Integrante]()
		if let grupo = grupo as? GrupoPersonalizado {
            integrantesFiltrados = filtrarIntegrantesDeGrupoPersonalizado(grupo)
		} else if let grupo = grupo as? GrupoAutomatico {
			integrantesFiltrados = filtrarIntegrantesDeGrupoAutomatico(grupo)
		}
		return integrantesFiltrados
	}
	
	func integrantesMapa<T>(delGrupo grupo: T) -> [IntegranteMapa] {
		let integrantes: [Integrante] = filtrarIntegrantesActivos(porGrupo: grupo)
		var integrantesMapa = [IntegranteMapa]()
		integrantes.forEach {
            let integranteMapa = IntegranteMapa(nombre: $0.nombre, apellidoPaterno: $0.apellidoPaterno, apellidoMaterno: $0.apellidoMaterno, latitud: $0.getLat(), longitud: $0.getLng(), icon: $0.icon, idUsuario: $0.idUsuarioMovil, estaEnRuta: true, fecha: $0.gps.fecha ?? "", hora: $0.gps.hora ?? "", servicio: $0.aliasServicio, img: $0.img, firebase: $0.FireBaseKey ?? "")
			integrantesMapa.append(integranteMapa)
		}
		return integrantesMapa
	}
	
	func integrantesMapa<T>(deLosGrupos grupos: T) -> [IntegranteMapa] {
		let integrantes: [Integrante] = integrantesActivos(deGrupos: grupos)
		var integrantesMapa = [IntegranteMapa]()
		integrantes.forEach {
            let integranteMapa = IntegranteMapa(nombre: $0.nombre, apellidoPaterno: $0.apellidoPaterno, apellidoMaterno: $0.apellidoMaterno, latitud: $0.getLat(), longitud: $0.getLng(), icon: $0.icon, idUsuario: $0.idUsuarioMovil, estaEnRuta: true, fecha: $0.gps.fecha ?? "", hora: $0.gps.hora ?? "", servicio: $0.aliasServicio, img: $0.img, firebase: $0.FireBaseKey ?? "")
			integrantesMapa.append(integranteMapa)
		}
		return integrantesMapa
	}
	
	// MARK: - Selectors
	
	@objc func crearNuevoGrupo() {
		
	}
	
	@objc func seleccionarGruposPersonalizados(_ sender: UISwitch) {
		if sender.isOn {
			mostrarGruposPersonalizados(true)
			let integrantes = integrantesMapa(deLosGrupos: gruposPersonalizados)
			delegate?.gruposView(self, mostroIntegrantes: integrantes)
		} else {
			mostrarGruposPersonalizados(false)
			let integrantes: [String] = integrantesActivos(deLosGrupos: gruposPersonalizados)
			delegate?.gruposView(self, ocultoIntegrantes: integrantes)
		}
	}
	
	@objc func seleccionarGruposAutomaticos(_ sender: UISwitch) {
		if sender.isOn {
			mostrarGruposAutomaticos(true)
			let integrantes = integrantesMapa(deLosGrupos: gruposAutomaticos)
			delegate?.gruposView(self, mostroIntegrantes: integrantes)
			reload()
		} else {
			mostrarGruposAutomaticos(false)
			let integrantes: [String] = integrantesActivos(deLosGrupos: gruposAutomaticos)
			delegate?.gruposView(self, ocultoIntegrantes: integrantes)
			if gruposPersonalizadosSwitch.isOn {
				let integrantes = integrantesMapa(deLosGrupos: gruposPersonalizados)
				delegate?.gruposView(self, mostroIntegrantes: integrantes)
			}
			reload()
		}
	}
    
    @objc func recargarGrupos() {
        print("Recargando")
        delegate?.recargarGruposView(self)
    }
}

// MARK: - UITableViewDataSource

extension GruposView: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
			case 0:
				return 0
			case 1:
				return gruposPersonalizados.count
			default:
				return gruposAutomaticos.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.section == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GrupoPersonalizadoCell
			cell.item = gruposPersonalizados[indexPath.row]
			cell.indice = indexPath
			cell.delegate = self
			return cell
		} else if indexPath.section == 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: grupoCellId, for: indexPath) as! GrupoAutomaticoCell
			cell.item = gruposAutomaticos[indexPath.row]
			cell.indice = indexPath
			cell.delegate = self
			return cell
		}
		return UITableViewCell()
	}
}

// MARK: - UITableViewDelegate

extension GruposView: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 35
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		registradosLabel.text = "Registrados: \(integrantes.count)"
		activosLabel.text = "Acitvos: \(integrantesActivos.count)"
		switch section {
			case 0:
				return nuevoGrupoView
			case 1:
				return gruposPersonalizadosView
			default:
				return gruposAutomaticosView
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let section = indexPath.section
		var integrantes = [Integrante]()
		switch section {
			case 1:
				integrantes = filtrarIntegrantesPorGrupo(grupo: gruposPersonalizados[indexPath.row])
				delegate?.mostrarIntegrantes(integrantes, delGrupo: gruposPersonalizados[indexPath.row].nombre)
			default:
				integrantes = filtrarIntegrantesPorGrupo(grupo: gruposAutomaticos[indexPath.row])
				delegate?.mostrarIntegrantes(integrantes, delGrupo: gruposAutomaticos[indexPath.row].nombre)
		}
	}
}

// MARK: - GrupoDelegate

extension GruposView: GrupoDelegate {
	func grupoCell<T>(_ grupoCell: T, mostroGrupoDelIndice indice: IndexPath) where T : UITableViewCell {
		if grupoCell is GrupoPersonalizadoCell {
			gruposPersonalizados[indice.row].isSelected = true
			let integrantes = integrantesMapa(delGrupo: gruposPersonalizados[indice.row])
			delegate?.gruposView(self, mostroIntegrantes: integrantes)
		} else {
			gruposAutomaticos[indice.row].isSelected = true
			let integrantes = integrantesMapa(delGrupo: gruposAutomaticos[indice.row])
			delegate?.gruposView(self, mostroIntegrantes: integrantes)
		}
	}
	
	func grupoCell<T>(_ grupoCell: T, ocultoGrupoDelIndice indice: IndexPath) where T : UITableViewCell {
		if grupoCell is GrupoPersonalizadoCell {
			gruposPersonalizados[indice.row].isSelected = false
			let integrantes: [String] = filtrarIntegrantesActivos(porGrupo: gruposPersonalizados[indice.row])
			delegate?.gruposView(self, ocultoIntegrantes: integrantes)
		} else {
			gruposAutomaticos[indice.row].isSelected = false
			let integrantes: [String] = filtrarIntegrantesActivos(porGrupo: gruposAutomaticos[indice.row])
			delegate?.gruposView(self, ocultoIntegrantes: integrantes)
		}
	}
}
