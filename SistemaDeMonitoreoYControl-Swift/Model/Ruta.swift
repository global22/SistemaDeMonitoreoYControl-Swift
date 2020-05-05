//
//  Ruta.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/14/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import Foundation

struct Ruta: Decodable {
	var fecha: [String: DatosRuta]
	
	private struct CK: CodingKey {
		var stringValue: String
		init?(stringValue: String) {
			self.stringValue = stringValue
		}
		var intValue: Int?
		init?(intValue: Int) {
			return nil
		}
	}
	
	init(from decoder: Decoder) throws {
		let container = try! decoder.container(keyedBy: CK.self)
		
		self.fecha = [String: DatosRuta]()
		for key in container.allKeys {
			let value = try container.decode(DatosRuta.self, forKey: CK(stringValue: key.stringValue)!)
			self.fecha[key.stringValue] = value
		}
	}
}

struct DatosRuta: Decodable {
	let hora: String
	let ruta: String
	let longitud: String
	let latitud: String
	
	var rutaString: [[String]]?
	
	enum CodingKeys: String, CodingKey {
		case hora = "Hora"
		case ruta = "Ruta"
		case longitud = "Longitud"
		case latitud = "Latitud"
	}
	
	func getRuta() -> [[String]] {
		let str = ruta.replacingOccurrences(of: "[", with: "")
		let str2 = str.replacingOccurrences(of: "]", with: "")
		
		let strArray = str2.components(separatedBy: ",")
		
		var count = 0
		var arrayAux = [String]()
		var superArray = [[String]]()
		for i in 0..<strArray.count {
			if count != 6 {
				arrayAux.append(strArray[i])
				count += 1
			}
			if count == 6 {
				count = 0
				superArray.append(arrayAux)
				arrayAux.removeAll()
			}
		}
		return superArray
	}
	
	func convertirRuta(_ ruta: [[String]], enLaFecha fecha: String) -> [RutaIntegrante] {
		var rutaConvertida = [RutaIntegrante]()
		var rutaIntegrante: RutaIntegrante?
		for objetos in ruta {
			for _ in 0..<objetos.count {
				let accuracy = Double(objetos[4])!
				if accuracy < 1000.0 {
					rutaIntegrante = .init(lat: Double(objetos[0])!, lng: Double(objetos[1])!, hora: objetos[2], velocidad: Double(objetos[3])!, accuracy: accuracy, altitud: Double(objetos[5])!, fecha: fecha)
				}
			}
			if let ruta = rutaIntegrante {
				rutaConvertida.append(ruta)
			}
		}
		
		return rutaConvertida
	}
	
}
