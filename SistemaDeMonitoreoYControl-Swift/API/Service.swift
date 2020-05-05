//
//  Service.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 1/21/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import Foundation
import Alamofire

class Service: NSObject {
    
    static let shared = Service()
    
    let baseUrl = "https://sedena360.ml/SEDENA"
    let socketBaseUrl = "wss://viict.guardianacional360.ml/cuartelgeneral"//"wss://sedena360.ml/SEDENA" 
    
    func obtenerDependencias(completion: @escaping(Result<Dependencia>) -> ()) {
        let url = "https://plataforma911.ml/CONTROLADOR/API/JSON/RegistroNiveles"
        Alamofire.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (respData) in
                if let err = respData.error {
                    print("Error al obtener las dependencias", err)
                    completion(.failure(err))
                    return
                }
                
                guard let data = respData.data else { return }
                do {
                    let dependencia = try JSONDecoder().decode(Dependencia.self, from: data)
                    completion(.success(dependencia))
                } catch {
                    print("Error al decodificar dependencias", error)
                    completion(.failure(error))
                }
                
        }
    }
    
    func login(user: String, password: String, completion: @escaping(Result<User>) -> ()) {
        let params = ["Usuario": user, "Password": password]
        
        let url = "\(baseUrl)/login"
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<500)
            .responseData { (respData) in
                if let err = respData.error {
                    completion(.failure(err))
                    return
                }
                
                guard let data = respData.data else { return }
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    UserDefaults.standard.setValue(user.id, forKey: "user")
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
        }
    }
    
    func getGroups(userId: String, completion: @escaping(Result<Group>) -> ()) {
        let params = ["idUsuarioSys": userId]
        
        let url = "\(baseUrl)/GruposPersonalizados"
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseData { (respData) in
                if let err = respData.error {
                    completion(.failure(err))
                    return
                }
                
                guard let data = respData.data else { return }
                do {
                    let data = try JSONDecoder().decode(Group.self, from: data)
//					data.integrantes.forEach {
//						print("\($0.nombre) Lat: \($0.getLat()) Ult Lat: \($0.getUltLat())")
//					}
                    completion(.success(data))
                } catch {
                    print("Failed to fetch group:", error)
                    completion(.failure(error))
                }
                
        }
    }
	
	func obtenerInformacion(delIntegrante integrante: Integrante, completion: @escaping(Result<InformacionIntegrante>) -> ()) {
		guard let urlServicio = integrante.urlServicio else { return }
		let url = "\(urlServicio)/envioPerfil"
		let movil = integrante.idUsuarioMovil
		
		var request = URLRequest(url: URL(string: url)!)
		request.httpMethod = "POST"
		request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
		
		guard let data = movil.data(using: .utf8) else { return }
		
		request.httpBody = data
		
		Alamofire.request(request)
			.validate(statusCode: 200..<300)
			.responseString(completionHandler: { (respData) in
				
				if let err = respData.error {
					completion(.failure(err))
					return
				}
				
				guard let data = respData.data else { return }
				guard let stringData = String(data: data, encoding: .isoLatin1) else { return }
				guard let utf8Data = stringData.data(using: .utf8) else { return }
				do {
					let info = try JSONDecoder().decode(InformacionIntegrante.self, from: utf8Data)
					completion(.success(info))
					print("Éxito al obtener información del integrante")
				} catch {
					print("Error al obtener información del integrante:", error)
					completion(.failure(error))
				}
			})
	}
	
	func obtenerRuta(delIntegrante integrante: Integrante, enLaFecha fecha: String, completion: @escaping(Result<Ruta>) -> ()) {
		guard let urlServicio = integrante.urlServicio else { return }
		let url = "\(urlServicio)/rutaDate"
		let params = ["idUsuario": integrante.idUsuarioMovil, "fecha": fecha]
		
		Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
			.responseData { (respData) in
				if let err = respData.error {
					print("Error al obtener la ruta del integrante:", err)
					completion(.failure(err))
					return
				}
				
				guard let data = respData.data else { return }
				do {
					let ruta = try JSONDecoder().decode(Ruta.self, from: data)
					completion(.success(ruta))
				} catch {
					print("Error al decodificar ruta:", error)
				}
		}
	}
	
	func obtenerRuta(delIntegrante integrante: Integrante, completion: @escaping(Result<Ruta>) -> ()) {
		guard let urlServicio = integrante.urlServicio else { return }
		let url = "\(urlServicio)/rutaNow"
		let params = ["idUsuario": integrante.idUsuarioMovil]
		
		Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseData(queue: DispatchQueue.global(),
                          completionHandler: { (respData) in
                            if let err = respData.error {
                                print("Error al obtener la ruta del integrante:", err)
                                completion(.failure(err))
                                return
                            }
                            
                            guard let data = respData.data else { return }
                            do {
                                let ruta = try JSONDecoder().decode(Ruta.self, from: data)
                                completion(.success(ruta))
                            } catch {
                                print("Error al decodificar ruta:", error)
                            }
            })
	}
    
    func obtenerActulizacionDeGPS(_ data: Data, completion: @escaping(Result<ActualizaGPS>) -> ()) {
        do {
            let actualiza = try JSONDecoder().decode(ActualizaGPS.self, from: data)
            completion(.success(actualiza))
        } catch {
            print("Error al decodificar la actualización de GPS", error)
            completion(.failure(error))
        }
    }
    
    func recibirLlamada(_ llamada: String, completion: @escaping(Result<Llamada>) -> ()) {
        guard let data = llamada.data(using: .utf8) else { return }
        do {
            let llamada = try JSONDecoder().decode(Llamada.self, from: data)
            completion(.success(llamada))
        } catch {
            print("Error al decodificar la llamada entrante:", error)
            completion(.failure(error))
        }
    }
}
