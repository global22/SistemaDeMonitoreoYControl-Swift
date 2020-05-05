//
//  ActualizaGPS.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 20/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import Foundation

struct ActualizaGPS: Decodable {
    let ActualizaGPS: Bool
    let so: String?
    let soversion: String
    let fecha: String
    let hora: String
    let gpsOTS: Bool?
    let origen: String
    let version: String
    let idUsuario: String
    let lat: Double
    let lng: Double
    
    enum CodingKeys: String, CodingKey {
        case ActualizaGPS
        case so
        case soversion
        case fecha
        case hora
        case gpsOTS
        case origen
        case version
        case idUsuario = "idUsuarios_Movil"
        case lat
        case lng
    }
}
