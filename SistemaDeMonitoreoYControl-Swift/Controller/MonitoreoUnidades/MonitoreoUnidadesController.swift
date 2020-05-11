//
//  MonitoreoUnidadesController.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/13/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import JGProgressHUD
import MapKit
import Cluster
import Starscream

final class MonitoreoUnidadesController: BaseMapController {
	
	// MARK: - Properties

	let gruposView = GruposView(title: "Grupos", estado: .Expandido)
	var gruposViewLeadingAnchor: NSLayoutConstraint!
	
	let integrantesView = IntegrantesView(title: nil, estado: nil)
	var integrantesViewLeadingAnchor: NSLayoutConstraint!
	
	let registroRutasView = RegistroRutasView(title: "Registro de Rutas", estado: nil)
	var registroRutasViewLeadingAnchor: NSLayoutConstraint!
	
	let integranteMapaView = IntegranteMapaView()
	var integranteMapaViewBottomAnchor: NSLayoutConstraint!
	
	lazy var expandButton = UIButton(image: #imageLiteral(resourceName: "minimizar.png"), tintColor: #colorLiteral(red: 0.9570000172, green: 0.8709999919, blue: 0.07500000298, alpha: 1), target: self, action: #selector(expandirVista))
	
	var integrantes = [Integrante]()
	
	fileprivate let leadingConstant: CGFloat = (320 + 8)
    fileprivate lazy var bottomConstant: CGFloat = (160 + view.safeAreaLayoutGuide.layoutFrame.size.height)
    
    var integrantesMapa = [IntegranteMapa]()
    
    lazy var webSocket: WebSocket = {
        guard let socketUrl = UserDefaults.standard.object(forKey: Constants.baseSocketUrl) else { fatalError("Url del socket no proporcionada") }
        let urlRequest = URLRequest(url: URL(string: "\(socketUrl)/SocketNotifications")!)
        let socket = WebSocket(request: urlRequest)
        socket.delegate = self
        return socket
    }()
	
    var integranteEnRuta: IntegranteMapa!
    
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
		view.addSubview(gruposView)
		gruposView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 8, left: 0, bottom: 8, right: 0), size: .init(width: 320, height: 0))
		gruposViewLeadingAnchor = gruposView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
		gruposViewLeadingAnchor.isActive = true
		gruposView.addShadow()
		gruposView.delegate = self
		
		view.addSubview(expandButton)
		expandButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: gruposView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 12, bottom: 0, right: 0))
		expandButton.roundedButton(withSize: .init(width: 30, height: 30), backgroundColor: .white, cornerRadius: 15)
		expandButton.addShadow()
		
		view.addSubview(integrantesView)
		integrantesView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 8, left: 0, bottom: 8, right: 0), size: .init(width: 320, height: 0))
		integrantesViewLeadingAnchor = integrantesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -(leadingConstant))
		integrantesViewLeadingAnchor.isActive = true
		integrantesView.baseLeadingAnchor = integrantesViewLeadingAnchor
		integrantesView.addShadow()
		integrantesView.baseDelegate = self
		integrantesView.delegate = self
		
		view.addSubview(registroRutasView)
		registroRutasView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 8, left: 0, bottom: 8, right: 0), size: .init(width: 320, height: 0))
		registroRutasViewLeadingAnchor = registroRutasView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -(leadingConstant))
		registroRutasViewLeadingAnchor.isActive = true
		registroRutasView.baseLeadingAnchor = registroRutasViewLeadingAnchor
		registroRutasView.addShadow()
		registroRutasView.baseDelegate = self
		registroRutasView.delegate = self
		
		view.addSubview(integranteMapaView)
		integranteMapaView.withSize(.init(width: 350, height: 160))
        integranteMapaViewBottomAnchor = integranteMapaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomConstant)
		integranteMapaViewBottomAnchor.isActive = true
		integranteMapaView.addShadow()
		integranteMapaView.centerXToSuperview()
		integranteMapaView.delegate = self
		
		fetchGrupos()
	}
	
	// MARK: - Helpers
	
	fileprivate func fetchGrupos() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Obteniendo grupos"
        hud.show(in: view)
		Service.shared.getGroups(userId: "1") { (res) in
			switch res {
				case .failure(_):
					hud.dismiss()
					break
				case .success(var groups):
					for i in 0..<groups.gruposPersonalizados.count {
						groups.gruposPersonalizados[i].isSelected = false
					}
					for i in 0..<groups.gruposAutomaticos.count {
						groups.gruposAutomaticos[i].isSelected = false
					}
					self.gruposView.gruposAutomaticos = groups.gruposAutomaticos
					self.gruposView.gruposPersonalizados = groups.gruposPersonalizados
					self.gruposView.integrantes = groups.integrantes
					self.gruposView.integrantesActivos = groups.integrantesActivos()
					self.integrantes = groups.integrantes
					self.gruposView.reload()
					hud.dismiss()
			}
		}
	}
    
    func reloadGroups() {
        gruposView.gruposAutomaticos.removeAll()
        gruposView.gruposAutomaticos.removeAll()
        gruposView.integrantes.removeAll()
        gruposView.integrantesActivos.removeAll()
        integrantes.removeAll()
        gruposView.reload()
        fetchGrupos()
        gruposView.tableView.refreshControl?.endRefreshing()
    }
	
	func expandir(_ constraints: NSLayoutConstraint..., constant: CGFloat, completion: ((Bool) -> Void)?) {
		constraints.forEach {
			if constant < 0 {
				$0.constant += constant - 8
			} else {
				$0.constant += constant + 8
			}
		}
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
			self.view.layoutIfNeeded()
		}, completion: completion)
	}
	
	func expandir(constant: CGFloat) {
		if constant < 0 {
			self.cambiar(true, boton: self.expandButton)
			expandir(gruposViewLeadingAnchor, integrantesViewLeadingAnchor, registroRutasViewLeadingAnchor, constant: constant) { (_) in
				self.view.layoutIfNeeded()
				self.gruposView.estado = .NoExpandido
			}
		} else {
			self.cambiar(false, boton: self.expandButton)
			expandir(gruposViewLeadingAnchor, integrantesViewLeadingAnchor, registroRutasViewLeadingAnchor, constant: constant) { (_) in
				self.view.layoutIfNeeded()
				self.gruposView.estado = .Expandido
			}
		}
	}
	
	func ordenarPorFecha(_ rutasIntegrante: [RutaIntegrante]) -> [RutaIntegrante] {
		return rutasIntegrante.sorted { $1.hora > $0.hora }
	}
	
	func filtrarPorDistancia(_ rutasIntegrante: [RutaIntegrante]) -> [RutaIntegrante] {
		var rutasFiltradas = [RutaIntegrante]()
		for i in 1..<rutasIntegrante.count {
			let puntoA = rutasIntegrante[i - 1]
			let puntoB = rutasIntegrante[i]
			
			let distancia = puntoA.obtenerDistancia(desde: puntoB)
			if distancia > 20.0 {
				rutasFiltradas.append(puntoA)
			}
		}
		
		return rutasFiltradas
	}
	
	func filtrarPorPrecision(_ rutasIntegrante: [RutaIntegrante]) -> [RutaIntegrante] {
		return rutasIntegrante.filter { $0.accuracy > 30.0 }
	}
	
	func cambiar(_ cambiar: Bool, boton: UIButton) {
		if cambiar {
			boton.setImage(#imageLiteral(resourceName: "maximizar.png"), for: .normal)
			boton.tintColor = #colorLiteral(red: 0.0549999997, green: 0.5490000248, blue: 0.3249999881, alpha: 1)
		} else {
			boton.setImage(#imageLiteral(resourceName: "minimizar"), for: .normal)
			boton.tintColor = #colorLiteral(red: 0.9570000172, green: 0.8709999919, blue: 0.07500000298, alpha: 1)
		}
	}
	
	// MARK: - Selectors
	
	@objc func expandirVista(_ sender: UIButton) {
		if gruposView.estado == .Expandido {
			expandir(constant: -(leadingConstant))
		} else {
			cambiar(false, boton: sender)
			expandir(constant: leadingConstant)
		}
	}
	
	// MARK: - MKMapViewDelegate
	
	override func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		guard let annotation = view.annotation else { return }
		
		if let cluster = annotation as? ClusterAnnotation {
			var zoomRect = MKMapRect.null
			cluster.annotations.forEach {
				let annotationPoint = MKMapPoint($0.coordinate)
				let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
				if zoomRect.isNull {
					zoomRect = pointRect
				} else {
					zoomRect = zoomRect.union(pointRect)
				}
			}
			mapView.setVisibleMapRect(zoomRect, animated: true)
		} else if let annotation = annotation as? IntegranteMapa {
			let center = annotation.coordinate
			let region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
			mapView.setCenter(center, animated: true)
			mapView.setRegion(region, animated: true)
			integranteMapaView.integranteMapa = annotation
			if gruposView.estado == .Expandido {
				expandir(gruposViewLeadingAnchor, integrantesViewLeadingAnchor, registroRutasViewLeadingAnchor, constant: -(leadingConstant)) { (_) in
					self.expandir(self.integranteMapaViewBottomAnchor, constant: -(self.bottomConstant), completion: nil)
					self.gruposView.estado = .NoExpandido
				}
			} else {
				expandir(integranteMapaViewBottomAnchor, constant: -(bottomConstant), completion: nil)
			}
		}
	}
	
	override func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
		if view.annotation is IntegranteMapa {
			expandir(integranteMapaViewBottomAnchor, constant: bottomConstant, completion: nil)
			mapView.showAnnotations(mapView.annotations, animated: true)
		}
	}
}

// MARK: - GruposViewDelegate

extension MonitoreoUnidadesController: GruposViewDelegate {
	func gruposView(_ gruposView: GruposView, mostroIntegrantes integrantes: [IntegranteMapa]) {
        integrantesMapa = integrantes
		mapView.addAnnotations(integrantes)
		mapView.showAnnotations(mapView.annotations, animated: true)
		expandir(constant: -(leadingConstant))
        gruposView.reload()
	}
	
	func gruposView(_ gruposView: GruposView, ocultoIntegrantes integrantes: [String]) {
		for annotation in mapView.annotations {
			for id in integrantes {
				if (annotation as? IntegranteMapa)?.idUsuario == id {
					mapView.removeAnnotation(annotation)
                } else if annotation is RutaIntegrante {
                    mapView.removeAnnotation(annotation)
                }
			}
		}
        mapView.removeOverlays(mapView.overlays)
        manager.removeAll()
		if mapView.annotations.count > 1 {
			mapView.showAnnotations(mapView.annotations, animated: true)
			expandir(constant: -(leadingConstant))
            gruposView.reload()
		} else {
            webSocket.disconnect()
            cleanMapView()
			setRegion()
            gruposView.reload()
		}
	}
	
	func mostrarIntegrantes(_ integrantes: [Integrante], delGrupo grupo: String) {
		integrantesView.setTitle(grupo)
		integrantesView.integrantes = integrantes
		integrantesView.reload()
		expandir(integrantesViewLeadingAnchor, constant: leadingConstant, completion: nil)
	}
	
    func recargarGruposView(_ gruposView: GruposView) {
        gruposView.gruposAutomaticos.removeAll()
        gruposView.gruposAutomaticos.removeAll()
        gruposView.integrantes.removeAll()
        gruposView.integrantesActivos.removeAll()
        integrantes.removeAll()
        gruposView.reload()
        fetchGrupos()
        gruposView.tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - IntegrantesViewDelegate

extension MonitoreoUnidadesController: IntegrantesViewDelegate {
	func mostrarRegistro(delIntegrante integrante: Integrante) {
		expandir(registroRutasViewLeadingAnchor, constant: leadingConstant, completion: nil)
		Service.shared.obtenerInformacion(delIntegrante: integrante) { (res) in
			switch res {
				case .failure(_):
					break
				case .success(let info):
					self.registroRutasView.informacionIntegrante = info
					self.registroRutasView.informacionIntegranteView.informacionIntegrante = info
			}
		}
	}
	
	func seleccionoIntegrante(_ integrante: Integrante) {
        let integranteMapa = IntegranteMapa(nombre: integrante.nombre, apellidoPaterno: integrante.apellidoPaterno, apellidoMaterno: integrante.apellidoMaterno, latitud: integrante.getLat(), longitud: integrante.getLng(), icon: integrante.icon, idUsuario: integrante.idUsuarioMovil, estaEnRuta: true, fecha: integrante.gps.fecha ?? "", hora: integrante.gps.hora ?? "", servicio: integrante.aliasServicio, img: integrante.img, firebase: integrante.FireBaseKey ?? "")
		
		mapView.addAnnotation(integranteMapa)
		mapView.showAnnotations(mapView.annotations, animated: true)
	}
}

// MARK: - RegistroRutasDelegate

extension MonitoreoUnidadesController: RegistroRutasDelegate {
	func seleccionoRuta(delIntegrante integrante: InformacionIntegrante, enLaFecha fecha: String) {
		cleanMapView()
		guard let integrante = integrantes.first(where: {
			$0.idUsuarioMovil == integrante.idUsuariosMovil
		}) else { return }
		let hud = JGProgressHUD(style: .dark)
		hud.textLabel.text = "Obteniendo ruta \ndel integrante"
		hud.show(in: view)
		
		Service.shared.obtenerRuta(delIntegrante: integrante, enLaFecha: fecha) { (res) in
			switch res {
				case .failure(_):
					DispatchQueue.main.async {
						hud.textLabel.text = "Error al obtener ruta \ndel integrante"
						hud.indicatorView = JGProgressHUDErrorIndicatorView()
						hud.dismiss(afterDelay: 4.0)
					}
					break
				case .success(let ruta):
                    if ruta.fecha[fecha]?.ruta != "" {
                        let datosRuta = ruta.fecha[fecha]
                        guard let lat = datosRuta?.latitud else { return }
                        guard let lng = datosRuta?.longitud else { return }
                        let integranteMapa = IntegranteMapa(nombre: integrante.nombre, apellidoPaterno: integrante.apellidoPaterno, apellidoMaterno: integrante.apellidoMaterno, latitud: Double(lat)!, longitud: Double(lng)!, icon: integrante.icon, idUsuario: integrante.idUsuarioMovil, estaEnRuta: false, fecha: fecha, hora: datosRuta!.hora, servicio: integrante.aliasServicio, img: integrante.img, firebase: integrante.FireBaseKey ?? "")
                        
                        guard let rutaString = datosRuta?.getRuta() else { return }
                        
                        guard let rutaIntegrante = datosRuta?.convertirRuta(rutaString, enLaFecha: fecha) else { return }
                        
                        var rutaFiltrada = self.ordenarPorFecha(rutaIntegrante)
                        rutaFiltrada = self.filtrarPorDistancia(rutaIntegrante)
                        rutaFiltrada = self.filtrarPorPrecision(rutaFiltrada)
                        
                        DispatchQueue.main.async {
                            self.trazarRuta(self.ordenarPorFecha(rutaIntegrante), enMapa: self.mapView)
                            self.mostrarIntegrante(integranteMapa, enMapa: self.mapView)
                            self.mostrarPuntos(deRuta: rutaFiltrada, enMapa: self.mapView)
                            hud.textLabel.text = "Éxito al obtener ruta \ndel integrante"
                            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                            hud.dismiss(afterDelay: 1.0, animated: true)
                            self.expandir(self.gruposViewLeadingAnchor, self.integrantesViewLeadingAnchor, self.registroRutasViewLeadingAnchor, constant: -self.leadingConstant) { (_) in
                                self.gruposView.estado = .NoExpandido
                                self.cambiar(true, boton: self.expandButton)
                            }
                    }
                }
                
			}
		}
	}
}

// MARK: - BaseCardDelegate

extension MonitoreoUnidadesController: BaseCardDelegate {
	func cardView(_ cardView: BaseCardView, didCloseWith leadingAnchor: NSLayoutConstraint) {
		if let registroRutas = cardView as? RegistroRutasView {
			cleanMapView()
			expandir(leadingAnchor, constant: -(leadingConstant)) { (_) in
				registroRutas.calendar.setCurrentPage(Date(), animated: true)
				if let date = registroRutas.calendar.selectedDate {
					registroRutas.calendar.deselect(date)
				}
			}
		} else {
			expandir(leadingAnchor, constant: -(leadingConstant), completion: nil)
		}
	}
}

// MARK: - IntegranteMapaDelegate

extension MonitoreoUnidadesController: IntegranteMapaDelegate {
    fileprivate func ocultarIntegranteAnterior() {
        ocultarRuta()
        integrantesMapa.forEach {
            $0.muestraRuta = false
        }
    }
    
    fileprivate func ocultarRuta() {
        manager.removeAll()
        manager.reload(mapView: mapView)
        mapView.removeOverlays(mapView.overlays)
    }
    
    func integranteMapaView(_ integranteMapaView: IntegranteMapaView, llamoAlIntegrante integrante: IntegranteMapa, con credenciales: CredencialesOperador) {
        DispatchQueue.main.async {
            let llamadaController = LlamadaController()
            llamadaController.connectToSession(apiKey: credenciales.apikey, sessionId: credenciales.idsesion, token: credenciales.token)
            let navController = UINavigationController(rootViewController: llamadaController)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func integranteMapaView(_ integranteMapaView: IntegranteMapaView, ocultoLaRutaDelIntegrante integrante: IntegranteMapa) {
        webSocket.disconnect()
        integranteMapaView.integranteMapa.muestraRuta = false
        integranteMapaView.cambiarBoton()
        ocultarRuta()
    }
    
	func integranteMapaView(_ integranteMapaView: IntegranteMapaView, mostroLaRutaDelIntegrante integrante: IntegranteMapa) {
        ocultarIntegranteAnterior()
        integranteEnRuta = integrante
		let fecha = integrante.fecha
		guard let integrante = integrantes.first(where: {
			$0.idUsuarioMovil == integrante.idUsuario
		}) else { return }
		let hud = JGProgressHUD(style: .dark)
		hud.textLabel.text = "Obteniendo ruta \ndel integrante"
		hud.show(in: view)
		Service.shared.obtenerRuta(delIntegrante: integrante) { (res) in
            switch res {
            case .failure(_):
                integranteMapaView.integranteMapa.muestraRuta = false
                DispatchQueue.main.async {
                    integranteMapaView.cambiarBoton()
                    hud.textLabel.text = "El integrante no tiene \nruta actual"
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.dismiss(afterDelay: 1.0)
                }
                break
            case .success(let ruta):
                if ruta.fecha[fecha] != nil {
                    let datosRuta = ruta.fecha[fecha]
                    
                    guard let rutaString = datosRuta?.getRuta() else { return }
                    guard let rutaIntegrante = datosRuta?.convertirRuta(rutaString, enLaFecha: fecha) else { return }
                    
                    var rutaFiltrada = self.ordenarPorFecha(rutaIntegrante)
                    rutaFiltrada = self.filtrarPorDistancia(rutaIntegrante)
                    rutaFiltrada = self.filtrarPorPrecision(rutaFiltrada)
                    
                    integranteMapaView.integranteMapa.muestraRuta = true
                    
                    self.webSocket.connect()
                    
                    DispatchQueue.main.async {
                        integranteMapaView.cambiarBoton()
                        self.trazarRuta(self.ordenarPorFecha(rutaIntegrante), enMapa: self.mapView)
                        self.mostrarPuntos(deRuta: rutaFiltrada, enMapa: self.mapView)
                        hud.textLabel.text = "Éxito al obtener ruta \ndel integrante"
                        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        hud.dismiss(afterDelay: 1.0, animated: true)
                    }
                } else {
                    integranteMapaView.integranteMapa.muestraRuta = false
                    DispatchQueue.main.async {
                        integranteMapaView.cambiarBoton()
                        hud.textLabel.text = "El integrante no tiene \nruta actual"
                        hud.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud.dismiss(afterDelay: 1.0)
                    }
                }
            }
		}
	}
}

// MARK: - WebSocketDelegate

extension MonitoreoUnidadesController: WebSocketDelegate {
    fileprivate func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("Web socket encontró un error: \(e.message)")
        } else if let e = error {
            print("Web socket encontró un error: \(e.localizedDescription)")
        } else {
            print("Web socket encontró un error")
        }
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("Web socket conectado: \(headers)")
        case .disconnected(let reason, let code):
            print("Web socket desconectado: \(reason) con código: \(code)")
        case .text(let string):
            guard let data = string.data(using: .utf8) else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
            for (key, value) in json {
                if key == "ActualizaGPS" && value as! Int == 1 {
                    let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    Service.shared.obtenerActulizacionDeGPS(data) { (res) in
                        switch res {
                        case .failure(_):
                            break
                        case .success(let actualiza):
                            if self.integranteEnRuta.idUsuario == actualiza.idUsuario {
                                let coordenada = CLLocationCoordinate2DMake(actualiza.lat, actualiza.lng)
                                DispatchQueue.main.async {
                                    UIView.animate(withDuration: 0.3) {
                                        self.integranteEnRuta.coordinate = coordenada
                                    }
                                }
                            }
                        }
                    }
                }
            }
            print("Web socket recibió mensaje: \(json)")
        case .binary(let data):
            print("Web socket recibió data: \(data)")
        case .pong(_):
            break
        case .ping(_):
            break
        case .error(let error):
            handleError(error)
        case .reconnectSuggested(_):
            break
        case .cancelled:
            print("Web socket cancelado")
            break
        case .viabilityChanged(_):
            break
        }
    }
    
    
}
