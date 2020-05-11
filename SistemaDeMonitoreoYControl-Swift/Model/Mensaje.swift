//
//  Mensaje.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 06/05/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import Foundation

struct Mensaje: Decodable {
    let value: String
    let fecha: String
    let hora: String
    let idUsuario: String
}
