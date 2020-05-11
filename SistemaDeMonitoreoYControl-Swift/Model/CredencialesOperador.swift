//
//  CredencialesOperador.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 08/05/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import Foundation

struct CredencialesOperador: Decodable {
    let apikey: String
    let id: String
    let idsesion: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case apikey
        case id = "ID"
        case idsesion
        case token
    }
}
