//
//  Llamada.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 21/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import Foundation
import UIKit
import OpenTok

struct Llamada: Decodable {
    let origen: String
    let modo: Modo
    let llamadaSOS: Bool
    var usuario: InformacionIntegrante
    let fechaServidor: String
    let horaServidor: String
    var registro: RegistroLlamada
    let idconnection: String
    let credenciales: Credenciales
    var subscriber: OTSubscriber?
    
    enum CodingKeys: String, CodingKey {
        case origen = "origen"
        case modo = "Modo"
        case llamadaSOS = "llamadaSOS"
        case usuario = "Usuarios_Movil"
        case fechaServidor = "fechaServidor"
        case horaServidor = "horaServidor"
        case registro = "RegistroLlamada"
        case idconnection = "idconnection"
        case credenciales = "Credenciales"
    }
}

struct Credenciales: Decodable {
    let apikey: String
    let sesion: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case apikey
        case sesion
        case token
    }
}

struct RegistroLlamada: Decodable {
    var id: String?
    var apikey: String
    var connectionid: String
    var fecha: String
    var hora: String
    var idLlamada: String
    var idUsuarios_Movil: String
    var idSession: String
    var lat: String?
    var latitud: String?
    var lng: String?
    var longitud: String?
    var modo: String
    var ruta_video: String
    var token: String
    
    enum Estado {
        case enEspera
        case atendida
        case perdida
    }
    
    var estado: Estado?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case apikey = "apikey"
        case connectionid
        case fecha
        case hora
        case idLlamada
        case idUsuarios_Movil
        case idSession = "idsession"
        case lat
        case latitud
        case lng
        case longitud
        case modo
        case ruta_video
        case token
    }
}

struct Modo: Decodable {
    let clave: String
    let id: String
    let nombre: String
    
    enum CodingKeys: String, CodingKey {
        case clave = "clave"
        case id = "id"
        case nombre = "nombre"
    }
}
