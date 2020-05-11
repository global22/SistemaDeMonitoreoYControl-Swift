//
//  UsuarioChat.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 06/05/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import MessageKit

struct UsuarioChat: SenderType, Equatable {
    var senderId: String
    
    var displayName: String
}
