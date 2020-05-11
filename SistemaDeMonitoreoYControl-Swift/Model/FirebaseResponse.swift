//
//  FirebaseResponse.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 11/05/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import Foundation

struct FirebaseResponse: Decodable {
    let multicastId: Int
    let success: Int
    let failure: Int
    let canonicalIds: Int
    let results: [Results]
    
    enum CodingKeys: String, CodingKey {
        case multicastId = "multicast_id"
        case success
        case failure
        case canonicalIds = "canonical_ids"
        case results
    }
}

struct Results: Decodable {
    let messageId: String
    
    enum CodingKeys: String, CodingKey {
        case messageId = "message_id"
    }
}
