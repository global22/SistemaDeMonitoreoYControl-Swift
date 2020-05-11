//
//  MensajeChat.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 06/05/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import MessageKit

struct MensajeChat: MessageType, Equatable {
    static func == (lhs: MensajeChat, rhs: MensajeChat) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
    var usuario: UsuarioChat 
    
    var sender: SenderType { return usuario }
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
    private init(tipoMensaje: MessageKind, usuario: UsuarioChat, idMensaje: String, fecha: Date) {
        self.kind = tipoMensaje
        self.usuario = usuario
        self.messageId = idMensaje
        self.sentDate = fecha
    }
    
    init(text: String, usuario: UsuarioChat, idMensaje: String, fecha: Date) {
        self.init(tipoMensaje: .text(text), usuario: usuario, idMensaje: idMensaje, fecha: fecha)
    }
    
    init(image: UIImage, usuario: UsuarioChat, idMensaje: String, fecha: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(tipoMensaje: .photo(mediaItem), usuario: usuario, idMensaje: idMensaje, fecha: fecha)
    }
}

fileprivate struct ImageMediaItem: MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
}
