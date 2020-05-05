//
//  LlamadaProtocol.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 05/05/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import OpenTok

protocol LlamadaDelegate {
    
    func connectToSession(apiKey: String, sessionId: String, token: String)
    
    func susbcribeToStream(_ stream: OTStream)
    
    func unsubscribeToStream(_ stream: OTStream)
    
    func disconnectSession(_ session: OTSession)
    
    func connectPublisher(session: OTSession)
}

extension LlamadaDelegate {
    
    func conntectPublisher(session: OTSession) {}
}
