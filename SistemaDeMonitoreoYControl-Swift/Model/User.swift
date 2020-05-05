//
//  User.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 1/21/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import Foundation

struct User: Decodable {
    let id: String
    let nombre: String
    let apellidos: String
    let tipo: String
    let disponibilidad: String
    let registrado: String?
    let estatus: String
    let sesion: String
    let correo: String
    let puedeRegistrar: String
    let usuario: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idUsuario_Sys"
        case nombre = "nombre"
        case apellidos = "apellidos"
        case disponibilidad = "disponibilidad"
        case registrado = "registrado_por_usuario"
        case estatus = "estatus"
        case sesion = "sesion"
        case correo = "correo"
        case puedeRegistrar = "puede_registrar"
        case usuario = "usuario"
        case tipo = "tipo"
    }
}
