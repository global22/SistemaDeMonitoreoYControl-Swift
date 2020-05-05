//
//  Group.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 1/23/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import Foundation

struct Group: Decodable {
    let dependncia: String
    var gruposAutomaticos: [GrupoAutomatico]
    let integrantes: [Integrante]
    var gruposPersonalizados: [GrupoPersonalizado]
    
    enum CodingKeys: String, CodingKey {
        case dependncia = "Dependencia"
        case gruposPersonalizados = "GruposPersonalizados"
        case gruposAutomaticos = "GruposAutomaticos"
        case integrantes = "integrantes"
    }
	
	func integrantesActivos() -> [Integrante] {
		self.integrantes.filter {
			$0.getLat() != 0.0
		}
	}
}

struct GrupoPersonalizado: Decodable {
    let estado: String
    let idSuperior: String?
    let idUsuarioSys: String
    let idGruposUsuariosSys: String
    let idServicio: String?
    let nombre: String
    let integrantes: [String]
	
	var isSelected: Bool?
    
    enum CodingKeys: String, CodingKey {
        case estado = "estado"
        case idSuperior = "idSuperior"
        case idUsuarioSys = "idUsuario_Sys"
        case idGruposUsuariosSys = "idgruposUsuarioSys"
        case idServicio = "idServicio"
        case nombre = "nombre"
        case integrantes = "integrantes"
    }
}

struct Integrante: Decodable {
    let nombre: String
    let apellidoPaterno: String
    let apellidoMaterno: String
    let icon: String
    let img: String
    let aliasServicio: String
    let FireBaseKey: String?
    let idUsuarioMovil: String
    let telefono: String?
    let urlServicio: String?
    let gps: GPS
    
    enum CodingKeys: String, CodingKey {
        case nombre = "nombre"
        case apellidoPaterno = "apellido_paterno"
        case apellidoMaterno = "apellido_materno"
        case icon = "icon"
        case img = "img"
        case aliasServicio = "aliasServicio"
        case FireBaseKey = "FireBaseKey"
        case idUsuarioMovil = "idUsuarios_Movil"
        case telefono = "telefono"
        case urlServicio = "urlServicio"
        case gps = "gps"
    }
	
	func getLat() -> Double {
		var latitud = 0.0
		let lat = self.gps.lat
		switch lat {
			case .double(let dou):
				latitud = dou
			default:
				break
		}
		return latitud
	}
	
	func getLng() -> Double {
		var longitud = 0.0
		let lng = self.gps.lng
		switch lng {
			case .double(let dou):
				longitud = dou
			default:
				break
		}
		return longitud
	}
	
	func getUltLat() -> Double {
		var latitud = 0.0
		let lat = self.gps.ult.lat
		switch lat {
			case .double(let dou):
				latitud = dou
			default:
				break
		}
		return latitud
	}
	
	func getUltLng() -> Double {
		var longitud = 0.0
		let lng = self.gps.ult.lng
		switch lng {
			case .double(let dou):
				longitud = dou
			default:
				break
		}
		return longitud
	}
}

struct GPS: Decodable {
    let fecha: String?
    let hora: String?
    let lng: customValue?
    let lat: customValue?
    let ult: Ult
    
    enum CodingKeys: String, CodingKey {
        case fecha = "fecha"
        case hora = "hora"
        case lng = "lng"
        case lat = "lat"
        case ult = "ult"
    }
    
    enum customValue: Decodable, Equatable {
        case double(Double), string(String)
        
        init(from decoder: Decoder) throws {
            if let double = try? decoder.singleValueContainer().decode(Double.self) {
                self = .double(double)
                return
            }
            
            if let string = try? decoder.singleValueContainer().decode(String.self) {
                self = .string(string)
                return
            }
            
            throw customError.missingValue
        }
        
        enum customError: Error {
            case missingValue
        }
    }
}

struct Ult: Decodable {
    let lat: customValue
    let lng: customValue
    
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }
    
    enum customValue: Decodable {
        case double(Double), string(String)
        
        init(from decoder: Decoder) throws {
            if let double = try? decoder.singleValueContainer().decode(Double.self) {
                self = .double(double)
                return
            }
            
            if let string = try? decoder.singleValueContainer().decode(String.self) {
                self = .string(string)
                return
            }
            
            throw customError.missingValue
        }
        
        enum customError: Error {
            case missingValue
        }
    }
}


struct GrupoAutomatico: Decodable {
    let idSuperior: String?
    let idGruposUsuariosSys: String
    let online: Bool
    let idServicio: String
    let nombre: String
    let urlServicio: String
    let integrantes: [String]
	
	var isSelected: Bool?
    
    enum CodingKeys: String, CodingKey {
        case idSuperior = "idSuperior"
        case idGruposUsuariosSys = "idgruposUsuarioSys"
        case online = "online"
        case idServicio = "idServicio"
        case nombre = "nombre"
        case urlServicio = "urlServicio"
        case integrantes = "integrantes"
    }
}
