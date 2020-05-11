//
//  LlamadaController.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 23/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools
import OpenTok

class LlamadaController: BaseViewController {
    
    // MARK: - Properties
    
    fileprivate let llamadaCellId = "llamadaCellId"
    
    var llamadas: [Llamada] = [] {
        didSet {
            llamadas.forEach {
                connectToSession(apiKey: $0.credenciales.apikey, sessionId: $0.credenciales.sesion, token: $0.credenciales.token)
                informacionController.llamada = $0
            }
        }
    }
    
    let informacionController = InformacionController()
    let chatController = ChatController()
    
    var controlesLlamadaView = ControlesLlamadaView()
    var controlesLlamadaViewHeightAnchor: NSLayoutConstraint!
    var controlesLlamadaViewBottomAnchor: NSLayoutConstraint!
    
    let accionesLlamadaView = AccionesLlamadaView()
    var accionesLlamadaTopAnchor: NSLayoutConstraint!
    var accionesLlamadaLeadingAnchor: NSLayoutConstraint!
    
    lazy var maxHeight = view.safeAreaLayoutGuide.layoutFrame.height - 16
    
    lazy var llamadasCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(LlamadaCell.self, forCellWithReuseIdentifier: llamadaCellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    var session: OTSession!
    
    var subscriber: OTSubscriber!
    
    var usuariosChat = [UsuarioChat]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewComponents()
        setupTapGesture()
        
        chatController.sendMessage = { [weak self] string in
            self?.sendTextMessage(text: string)
        }
    }
    
    // MARK: - Helpers
    
    fileprivate func setupViewComponents() {
        
        navigationItem.rightBarButtonItem = nil
        
        view.addSubview(llamadasCollectionView)
        llamadasCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        llamadasCollectionView.backgroundColor = .black
        
        view.addSubview(controlesLlamadaView)
        controlesLlamadaViewHeightAnchor = controlesLlamadaView.heightAnchor.constraint(equalToConstant: 100)
        controlesLlamadaViewHeightAnchor.isActive = true
        controlesLlamadaViewBottomAnchor = controlesLlamadaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        controlesLlamadaViewBottomAnchor.isActive = true
        controlesLlamadaView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 0))
        controlesLlamadaView.withWidth(320)
        controlesLlamadaView.delegate = self
        
        view.addSubview(accionesLlamadaView)
        accionesLlamadaTopAnchor = accionesLlamadaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        accionesLlamadaTopAnchor.isActive = true
        accionesLlamadaLeadingAnchor = accionesLlamadaView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
        accionesLlamadaLeadingAnchor.isActive = true
        accionesLlamadaView.withSize(.init(width: 198, height: 82))
        accionesLlamadaView.delegate = self
        
    }
    
    fileprivate func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    func basicAnimation(completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
    
    func expandView(to height: CGFloat, completion: ((Bool) -> Void)?) {
        controlesLlamadaViewHeightAnchor.constant = height
        basicAnimation(completion: completion)
    }
    
    func mostrarControles(_ mostrar: Bool, completion: ((Bool) -> Void)?) {
        if mostrar {
            controlesLlamadaViewBottomAnchor.constant = -8
        } else {
            controlesLlamadaViewBottomAnchor.constant = 150
        }
        basicAnimation(completion: completion)
    }
    
    func moverAcciones(_ mover: Bool, completion: ((Bool) -> Void)?) {
        if mover {
            accionesLlamadaLeadingAnchor.constant = 336
        } else {
            accionesLlamadaLeadingAnchor.constant = 8
        }
        basicAnimation(completion: completion)
    }
    
    func mostrarAcciones(_ mostrar: Bool, completion: ((Bool) -> Void)?) {
        if mostrar {
            accionesLlamadaTopAnchor.constant = 8
        } else {
            accionesLlamadaTopAnchor.constant = -150
        }
        basicAnimation(completion: completion)
    }
    
    func sendTextMessage(text: String) {
        let fechaFormatter = DateFormatter()
        fechaFormatter.dateFormat = "YYYY-MM-dd"
        let horaFormatter = DateFormatter()
        horaFormatter.dateFormat = "HH:mm:ss"
        let mensajeString = "{\"value\":\"\(text)\",\"fecha\":\"\(fechaFormatter.string(from: Date()))\",\"hora\":\"\(horaFormatter.string(from: Date()))\",\"idUsuario\":\"\(chatController.usuarioChat.senderId)\"}"
        session.signal(withType: "msg-signal", string: mensajeString, connection: nil, error: nil)
    }
    
    func sendFirstMessage() {
        let mensaje = "Se ha unido al chat"
        let mensajeChat = MensajeChat(text: mensaje, usuario: chatController.usuarioChat, idMensaje: UUID().uuidString, fecha: Date())
        chatController.insertMessage(mensajeChat)
        sendTextMessage(text: mensaje)
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func backgroundTap(_ sender: UITapGestureRecognizer) {
        if controlesLlamadaView.estado == .Expandido {
            expandView(to: 100) { (_) in
                self.mostrarControles(false) { (_) in
                    self.controlesLlamadaView.estado = .Oculto
                }
            }
            moverAcciones(false) { (_) in
                self.mostrarAcciones(false, completion: nil)
            }
        } else if controlesLlamadaView.estado == .Oculto {
            mostrarAcciones(true, completion: nil)
            mostrarControles(true) { (_) in
                self.controlesLlamadaView.estado = .NoExpandido
            }
        } else {
            mostrarAcciones(false, completion: nil)
            mostrarControles(false) { (_) in
                self.controlesLlamadaView.estado = .Oculto
            }
        }
    }
}

// MARK: - LlamadaDelegate

extension LlamadaController: LlamadaDelegate {
    func connectToSession(apiKey: String, sessionId: String, token: String) {
        session = OTSession(apiKey: apiKey, sessionId: sessionId, delegate: self)
        var error: OTError?
        session.connect(withToken: token, error: &error)
        if let error = error {
            print("Error al conectarse a la sesión", error)
        }
    }
    
    func susbcribeToStream(_ stream: OTStream) {
        var error: OTError?
        if let error = error {
            print("Error al suscribirse:", error)
        }
        var index = 0
        var id: String!
        var nombre: String!
        for i in 0..<llamadas.count {
            if llamadas[i].credenciales.sesion == stream.session.sessionId {
                id = llamadas[i].usuario.idUsuariosMovil
                nombre = "\(llamadas[i].usuario.nombre) \(llamadas[i].usuario.apellidoPaterno) \(llamadas[i].usuario.apellidoMaterno)"
                session.subscribe(llamadas[i].subscriber!, error: &error)
                index = i
            }
        }
        let usuarioChat = UsuarioChat(senderId: id, displayName: nombre)
        usuariosChat.append(usuarioChat)
        
        llamadasCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func unsubscribeToStream(_ stream: OTStream) {
        
    }
    
    func disconnectSession(_ session: OTSession) {
        
    }
    
    func connectPublisher(session: OTSession) {
        guard let publisher = OTPublisher(delegate: self) else { return }
        var error: OTError?
        session.publish(publisher, error: &error)
        if let error = error {
            print("Error al conectar al publicador", error)
        }
        
        if let publisherView = publisher.view {
            view.addSubview(publisherView)
            publisherView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 8), size: .init(width: 200, height: 200))
        }
    }
}

// MARK: - ControlesLlamadaDelegate

extension LlamadaController: ControlesLlamadaDelegate {
    func controlesLlamadaView(_ controlesLlamadaView: ControlesLlamadaView, didExpand expand: Bool) {
        if expand {
            expandView(to: maxHeight) { (_) in
                controlesLlamadaView.estado = .Expandido
            }
            moverAcciones(true, completion: nil)
        } else {
            expandView(to: 100) { (_) in
                controlesLlamadaView.estado = .NoExpandido
            }
            moverAcciones(false, completion: nil)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension LlamadaController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let rect = controlesLlamadaView.bounds
        if controlesLlamadaView.estado == .Expandido {
            if rect.contains(touch.location(in: controlesLlamadaView)) {
                return false
            }
        }
        return true
    }
}

// MARK: - AccionesLlamadaDelegate

extension LlamadaController: AccionesLlamadaDelegate {
    func mostrarChat() {
        let navController = UINavigationController(rootViewController: chatController)
        navController.modalPresentationStyle = .formSheet
        if #available(iOS 13, *)  {
            navController.isModalInPresentation = true
        }
        present(navController, animated: true, completion: nil)
    }
    
    func mostrarMapa() {
        print("Mapa")
    }
    
    func mostrarInformacion() {
        let navController = UINavigationController(rootViewController: informacionController)
        navController.modalPresentationStyle = .formSheet
        if #available(iOS 13, *)  {
            navController.isModalInPresentation = true
        }
        present(navController, animated: true, completion: nil)
    }
}

// MARK: - OTSessionDelegate

extension LlamadaController: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print("sessionDidConnect(_:)")
        connectPublisher(session: session)
        sendFirstMessage()
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("sessionDidDisconnect(_:)")
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("session(_:didFailWithError:)", error)
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("session(_:streamCreated:)")
        susbcribeToStream(stream)
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("session(_:streamDestroyed:)")
        if presentedViewController != nil {
            presentedViewController?.dismiss(animated: true, completion: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func session(_ session: OTSession, receivedSignalType type: String?, from connection: OTConnection?, with string: String?) {
        if session.connection?.connectionId != connection?.connectionId {
            guard let mensaje = string else { return }
            if mensaje.contains("value") {
                guard let data = mensaje.data(using: .utf8) else { return }
                do {
                    let mensajeRecibido = try JSONDecoder().decode(Mensaje.self, from: data)
                    usuariosChat.forEach {
                        if $0.senderId == mensajeRecibido.idUsuario {
                            let msj = MensajeChat(text: mensajeRecibido.value, usuario: $0, idMensaje: UUID().uuidString, fecha: Date())
                            chatController.insertMessage(msj)
                        }
                    }
                    print(mensajeRecibido)
                } catch {
                    print("Error al decodificar mensaje recibido:", error)
                }
            }
            
        }
    }
}

// MARK: - OTPublisherDelegate

extension LlamadaController: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("publisher(_:didFailWithError:)", error)
    }
}

// MARK: - OTSubscriberDelegate

extension LlamadaController: OTSubscriberDelegate {
    func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
        print("subscriberDidConnect(toStream:)")
    }
    
    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("subscriber(_:didFailWithError:)", error)
    }
}

// MARK: - UICollectionViewDataSource

extension LlamadaController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return llamadas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: llamadaCellId, for: indexPath) as! LlamadaCell
        cell.llamada = llamadas[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension LlamadaController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return.init(width: view.frame.width - 16, height: view.safeAreaLayoutGuide.layoutFrame.height - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 8, left: 8, bottom: 8, right: 8)
    }
}
