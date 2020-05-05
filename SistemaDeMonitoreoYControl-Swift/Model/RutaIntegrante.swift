//
//  RutaIntegrante.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/14/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import Foundation
import MapKit

class RutaIntegrante: NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D
	var lat: Double
	var lng: Double
	var hora: String
	var accuracy: Double
	var altitud: Double
	var velocidad: Double
	var fecha: String
	var descripcion: String = ""
	var horaFinal: String = ""
	
	var title: String?
	
	let image = #imageLiteral(resourceName: "ruta")
	
	init(lat: Double, lng: Double, hora: String, velocidad: Double, accuracy: Double, altitud: Double, fecha: String) {
		self.lat = lat
		self.lng = lng
		self.hora = hora
		self.velocidad = velocidad
		self.accuracy = accuracy
		self.altitud = altitud
		self.coordinate = .init(latitude: lat, longitude: lng)
		self.fecha = fecha
	}
	
	func getImage() -> UIImage? {
		guard let image = self.image.resizeImage(newWidth: 15) else { return nil }
		return image
	}
	
	func obtenerDistancia(desde ruta: RutaIntegrante) -> Double {
		let puntoA = CLLocation(latitude: self.lat, longitude: self.lng)
		let puntoB = CLLocation(latitude: ruta.lat, longitude: ruta.lng)
		let distancia = puntoB.distance(from: puntoA)
		
		return distancia
	}
}

