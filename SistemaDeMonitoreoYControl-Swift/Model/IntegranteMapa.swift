//
//  IntegranteMapa.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/14/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import Foundation
import MapKit

class IntegranteMapa: NSObject, MKAnnotation {
	var idUsuario: String
	var nombre: String
	var apellidoMaterno: String
	var apellidoPaterno: String
	@objc dynamic var coordinate: CLLocationCoordinate2D
	var latitud: Double
	var longitud: Double
	var icon: String
	var title: String?
	
	var estaEnRuta: Bool
	var fecha: String
	var hora: String
	var servicio: String
	var img: String
	var muestraRuta: Bool = false
	
	init(nombre: String, apellidoPaterno: String, apellidoMaterno: String, latitud: Double, longitud: Double, icon: String, idUsuario: String, estaEnRuta: Bool, fecha: String, hora: String, servicio: String, img: String) {
		self.nombre = nombre
		self.apellidoPaterno = apellidoPaterno
		self.apellidoMaterno = apellidoMaterno
		self.latitud = latitud
		self.longitud = longitud
		self.icon = icon
		self.idUsuario = idUsuario
		self.estaEnRuta = estaEnRuta
		self.fecha = fecha
		self.hora = hora
		self.servicio = servicio
		self.img = img
        self.coordinate = .init(latitude: latitud, longitude: longitud)
        self.title = "\(nombre)"
        super.init()
        
	}
}
