//
//  InformacionIntegrante.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/14/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import Foundation

struct InformacionIntegrante: Decodable {
	let img: String?
	let fechaNacimiento: String
	let direccion: String
	let icon: String
	let nombre: String
	let cp: String
	let contactoNombre: String
	let alergias: String
	let registro: Registro?
	let contactoTelefono: String
	let ultConexion: UltConexion?
	let rh: String
	let correo: String
	let genero: String
	let apellidoMaterno: String
	let apellidoPaterno: String
	let idUsuariosMovil: String
	let telefono: String
	let condicionMedica: String
	let aliasServicio: String?
	let fireBaseKey: String?
	let fechasRutas: [Fecha]?
    var usuarioChat: UsuarioChat?
	
	enum CodingKeys: String, CodingKey {
		case img = "img"
		case fechaNacimiento = "fecha_nacimiento"
		case direccion = "direccion"
		case icon = "icon"
		case nombre = "nombre"
		case cp = "cp"
		case contactoNombre = "contacto_nombre"
		case alergias = "alergias"
		case registro = "registro"
		case contactoTelefono = "contacto_telefono"
		case ultConexion = "ultConexion"
		case rh = "rh"
		case correo = "correo"
		case genero = "genero"
		case apellidoMaterno = "apellido_materno"
		case apellidoPaterno = "apellido_paterno"
		case idUsuariosMovil = "idUsuarios_Movil"
		case telefono = "telefono"
		case condicionMedica = "condicion_medica"
		case aliasServicio = "aliasServicio"
		case fireBaseKey = "FireBaseKey"
		case fechasRutas = "FechasRutas"
	}
}

struct Registro: Decodable {
	let fecha: String
	let hora: String
	
	enum CodingKeys: String, CodingKey {
		case fecha = "Fecha"
		case hora = "Hora"
	}
}

struct UltConexion: Decodable {
	let fecha: String
	let hora: String
	
	enum CodingKeys: String, CodingKey {
		case fecha = "Fecha"
		case hora = "Hora"
	}
}

struct Fecha: Decodable {
	let fecha: String?
	
	enum CodingKeys: String, CodingKey {
		case fecha = "Fecha"
	}
}
