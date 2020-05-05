//
//  Dependencia.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 22/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import Foundation

struct Dependencia: Decodable {
    var nombre: [String: AtributosDependencia]
    
    private struct CK: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CK.self)
        
        self.nombre = [String: AtributosDependencia]()
        for key in container.allKeys {
            let value = try container.decode(AtributosDependencia.self, forKey: CK(stringValue: key.stringValue)!)
            self.nombre[key.stringValue] = value
        }
    }
}

struct AtributosDependencia: Decodable {
    var alias: String
    var niveles: String?
    var id: String
    var nombre: String
    var url: String
    var nivel: [String: Nivel]
    
    private struct CK: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
        
        static let alias = CK.make(key: "alias")
        static let niveles = CK.make(key: "niveles")
        static let id = CK.make(key: "id")
        static let nombre = CK.make(key: "nombre")
        static let url = CK.make(key: "url")
        static func make(key: String) -> CK {
            return CK(stringValue: key)!
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CK.self)
        
        self.nivel = [String: Nivel]()
        self.alias = ""
        self.niveles = ""
        self.id = ""
        self.nombre = ""
        self.url = ""
        try container.allKeys.forEach { (key) in
            switch key.stringValue {
            case CK.alias.stringValue:
                self.alias = try container.decode(String.self, forKey: .alias)
            case CK.niveles.stringValue:
                self.niveles = try container.decode(String.self, forKey: .niveles)
            case CK.id.stringValue:
                self.id = try container.decode(String.self, forKey: .id)
            case CK.nombre.stringValue:
                self.nombre = try container.decode(String.self, forKey: .nombre)
            case CK.url.stringValue:
                self.url = try container.decode(String.self, forKey: .url)
            default:
                let value = try container.decode(Nivel.self, forKey: CK(stringValue: key.stringValue)!)
                self.nivel[key.stringValue] = value
            }
        }
    }
}

struct Nivel: Decodable {
    var nombre: [String: AtributosDependencia]
    var alias: String
    
    private struct CK: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
        
        static let alias = CK.make(key: "alias")
        static func make(key: String) -> CK {
            return CK(stringValue: key)!
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CK.self)
        
        self.nombre = [String: AtributosDependencia]()
        self.alias = try container.decode(String.self, forKey: .alias)
        try container.allKeys.forEach { (key) in
            switch key.stringValue {
            case CK.alias.stringValue:
                self.alias = try container.decode(String.self, forKey: .alias)
            default:
                let value = try container.decode(AtributosDependencia.self, forKey: CK(stringValue: key.stringValue)!)
                self.nombre[key.stringValue] = value
            }
        }
    }
}
