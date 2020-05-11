//
//  AdminController.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 2/25/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import LBTATools
import UIKit
import Starscream
import OpenTok

class AdminController: BaseViewController {
    
    // MARK: - Properties
    
    fileprivate let collectionIdentifier = "collectionIdentifier"
    fileprivate let tableIdentifier = "tableIdentifier"
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let itemsPerRow: CGFloat = 3
    let itemsPerColumn: CGFloat = 2
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LlamadaEntranteCell.self, forCellWithReuseIdentifier: collectionIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListaLlamadaCell.self, forCellReuseIdentifier: tableIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = #colorLiteral(red: 0.2039999962, green: 0.2269999981, blue: 0.2509999871, alpha: 1)
        return tableView
    }()
    
    var webSocket: WebSocket!
    
    var llamadas = [Llamada]()
    
    var listaLlamadas = [Llamada]()
    
    var item = 0
    
    var session: OTSession!
    
    var subscriber: OTSubscriber!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.object(forKey: Constants.usuario) != nil {
            guard let socketUrl = UserDefaults.standard.object(forKey: Constants.baseSocketUrl) else { fatalError("Url del socket no proporcionada") }
            let urlRequest = URLRequest(url: URL(string: "\(socketUrl)/SocketNotifications")!)
            webSocket = WebSocket(request: urlRequest)
            webSocket.delegate = self
            webSocket.connect()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.object(forKey: Constants.usuario) != nil {
            webSocket.disconnect()
        }
    }
    
    // MARK: - Helper Fucntions
    
    fileprivate func setupViewComponents() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .black
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: UIScreen.main.bounds.width * 0.666, height: 0))
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, size: .init(width: UIScreen.main.bounds.width * 0.333, height: 0))
        
    }
    
    fileprivate func connectToSession(apiKey: String, sessionId: String, token: String) {
        session = OTSession(apiKey: apiKey, sessionId: sessionId, delegate: self)
        var error: OTError?
        session.connect(withToken: token, error: &error)
        if let error = error {
            print("Error al conectarse a la sesión", error)
        }
    }
    
    fileprivate func susbcribeToStream(_ stream: OTStream) {
        subscriber = OTSubscriber(stream: stream, delegate: self)
        
        var error: OTError?
        session.subscribe(subscriber, error: &error)
        if let error = error {
            print("Error al suscribirse:", error)
        }
        
        var item = 0
        for i in 0..<llamadas.count {
            if llamadas[i].credenciales.sesion == stream.session.sessionId {
                llamadas[i].subscriber = subscriber
                item = i
            }
        }
        collectionView.reloadItems(at: [IndexPath(item: item, section: 0)])
    }
    
    fileprivate func unsubscribeToStream(_ stream: OTStream) {
        var item = 0
        for i in 0..<llamadas.count {
            if llamadas[i].credenciales.sesion == stream.session.sessionId {
                llamadas[i].registro.estado = .perdida
                item = i
            }
        }
        for i in 0..<listaLlamadas.count {
            if listaLlamadas[i].credenciales.sesion == stream.session.sessionId {
                listaLlamadas[i].registro.estado = .perdida
            }
        }
        collectionView.reloadItems(at: [IndexPath(item: item, section: 0)])
        tableView.reloadData()
    }
    
    fileprivate func disconnectSession(_ session: OTSession) {
        var index = 0
        for i in 0..<llamadas.count {
            if llamadas[i].credenciales.sesion == session.sessionId {
                index = i
            }
        }
        for i in 0..<listaLlamadas.count {
            if listaLlamadas[i].credenciales.sesion == session.sessionId {
                listaLlamadas[i].registro.estado = .atendida
            }
        }
        llamadas.remove(at: index)
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        tableView.reloadData()
    }
    // MARK: - Selectors
    
}

// MARK: - UICollectionViewDelegate UICollectionViewDataSource

extension AdminController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionIdentifier, for: indexPath) as! LlamadaEntranteCell
        cell.indice = indexPath
        if !llamadas.isEmpty {
            cell.llamada = llamadas[indexPath.item]
        } else {
            cell.reloadCell()
        }
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AdminController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let padding = sectionInsets.top * (itemsPerColumn + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let availableHeight = collectionView.frame.height - padding
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = availableHeight / itemsPerColumn
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - UITableViewDataSource

extension AdminController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaLlamadas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableIdentifier, for: indexPath) as! ListaLlamadaCell
        cell.llamada = listaLlamadas[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AdminController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(text: "  Llamadas", font: .boldSystemFont(ofSize: 24), textColor: .black, textAlignment: .left)
        label.backgroundColor = .white
        return label
    }
}

// MARK: - WebSocketDelegate

extension AdminController: WebSocketDelegate {
    fileprivate func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("Web socket encontró un error: \(e.message)")
        } else if let e = error {
            print("Web socket encontró un error: \(e.localizedDescription)")
        } else {
            print("Web socket encontró un error")
        }
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("Web socket conectado: \(headers)")
        case .disconnected(let reason, let code):
            print("Web socket desconectado: \(reason) con código: \(code)")
        case .text(let string):
            if string.contains("RegistroLlamada") {
                Service.shared.recibirLlamada(string) { (res) in
                    switch res {
                    case .failure(_):
                        break
                    case .success(var llamada):
                        if self.llamadas.isEmpty {
                            llamada.registro.estado = .enEspera
                            self.llamadas.append(llamada)
                            self.listaLlamadas.insert(llamada, at: 0)
                            self.tableView.reloadData()
                            self.collectionView.reloadItems(at: [IndexPath(item: self.item, section: 0)])
                            
                            self.connectToSession(apiKey: llamada.credenciales.apikey, sessionId: llamada.credenciales.sesion, token: llamada.credenciales.token)
                            self.item += 1
                        } else {
                            for i in 0..<self.llamadas.count {
                                if self.llamadas[i].usuario.idUsuariosMovil == llamada.usuario.idUsuariosMovil {
                                    llamada.registro.estado = .enEspera
                                    self.listaLlamadas.insert(llamada, at: 0)
                                    self.llamadas[i] = llamada
                                    self.tableView.reloadData()
                                    self.collectionView.reloadItems(at: [IndexPath(item: i, section: 0)])
                                    
                                    self.connectToSession(apiKey: llamada.credenciales.apikey, sessionId: llamada.credenciales.sesion, token: llamada.credenciales.token)
                                }
                            }
                        }
                    }
                }
            }
            print("Web socket recibió un mensaje: \(string)")
        case .binary(let data):
            print("Web socket recibió data: \(data)")
        case .pong(_):
            break
        case .ping(_):
            break
        case .error(let error):
            handleError(error)
        case .reconnectSuggested(_):
            break
        case .cancelled:
            print("Web socket cancelado")
            break
        case .viabilityChanged(_):
            break
        }
    }
}

// MARK: - LlamadaEntranteDelegate

extension AdminController: LlamadaEntranteDelegate {
    func atenderLlamada(enIndice indice: IndexPath) {
        let llamadaController = LlamadaController()
        llamadaController.llamadas.append(llamadas[indice.item])
        let navController = UINavigationController(rootViewController: llamadaController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true) {
            var error: OTError?
            self.session.disconnect(&error)
            if let error = error {
                print("Error al desconectarse:", error)
            }
        }
    }
}

// MARK: - OTSessionDelegate

extension AdminController: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print("sessionDidConnect")
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        disconnectSession(session)
        print("sessionDidDisconnect")
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("didFailWithError", error)
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("streamCreated")
        susbcribeToStream(stream)
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("streamDestroyed")
        unsubscribeToStream(stream)
        
    }
}

// MARK: - OTSubscriberDelegate

extension AdminController: OTSubscriberDelegate {
    func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
        print("subscriberDidConnect")
    }
    
    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("didFailWithError", error)
    }
}
