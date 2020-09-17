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
        
        guard let baseUrl = UserDefaults.standard.object(forKey: Constants.baseUrl) else {
            return
        }
        
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
                    UserDefaults.standard.setValue(user.id, forKey: Constants.usuario)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
        }
    }
    
    func getGroups(userId: String, completion: @escaping(Result<Group>) -> ()) {
        let params = ["idUsuarioSys": userId]
        
        guard let baseUrl = UserDefaults.standard.object(forKey: Constants.baseUrl) else {
            return
        }
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
    
    func generarCredenciales(completion: @escaping(Result<CredencialesOperador>) -> ()) {
        let url = "http://plataforma911.ml/CONTROLADOR/API/Credenciales"
        Alamofire.request(url, method: .get)
            .responseData { (dataResp) in
                if let error = dataResp.error {
                    print("Error al generar las credenciales:", error)
                    completion(.failure(error))
                    return
                }
                
                guard let data = dataResp.data else { return }
                do {
                    let credenciales = try JSONDecoder().decode(CredencialesOperador.self, from: data)
                    completion(.success(credenciales))
                } catch {
                    print("Error al decodificar las credenciales:", error)
                    completion(.failure(error))
                }
        }
    }
    
    /// Función que se encarga de solicitar una llamada por parte del operador a cualquiera de los integrantes de la dependencia en la que se encuentra.
    /// - Parameters:
    ///   - firebaseKey: Es la llave de Firebase asociada al integrante al que se requiere llamar. Es importante ya que mediante esta llave Firebase le notifica al integrante que se le esta solicitando una llamada.
    ///   - credenciales: Son las credenciales de OpenTok del operador previamente generadas.
    ///   - completion: Un bloque de completado que notificará si se realizó de manera correcta la solicitud o si ésta tuvo un fallo.
    /// - Returns: No tiene valor de retorno.
    func solicitarLlamada(firebaseKey: String, credenciales: CredencialesOperador, completion: @escaping(Result<FirebaseResponse>) -> ()) {
        guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else { return }
        let headers = ["Content-Type": "application/json",
                       "Authorization": "key=\(Constants.firebaseAuth)"]
        
        let hora = DateFormatter.hourFormatter.string(from: Date())
        print(hora)
        let fecha = DateFormatter.dateFormatter.string(from: Date())
        print(fecha)
        
        let dataBody: [String: Any] = ["apikey": credenciales.apikey,
                                       "fecha": fecha,
                                       "hora": hora,
                                       "idNotificacion": "000", //la proporciona plataforma
                                       "idsesion": credenciales.idsesion,
                                       "sound": "default",
                                       "text": "\(UserDefaults.standard.object(forKey: Constants.dependencia) ?? "")", //dependencia desde donde se origino llamada
                                       "title": "\(UserDefaults.standard.object(forKey: Constants.dependencia) ?? "") solicita video",
                                       "token": credenciales.token,
                                       "type": "3"]
        
        let params: [String: Any] = ["to": firebaseKey, //"fe7spefMBAw:APA91bGUbRSzp-ScB1W2nAIFaaiOzGQw-rCZjQ705AVBC65TD0ZiWrpN1oCsZmSKde0_mdsuOjJCBtJFiW363uaLodQGvfEtBndsPg0EJHvfRInvEuZ6LxFXyUAJK808lv4NMvO67-IS",
                                    "priority": "high",
                                    "content-available": true,
//                                    "notification": ["title": "TITLE", "body": "BODY"]]
                                    // notification: [title: String, body: String]
                                    "data": dataBody]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: .sortedKeys)
            request.httpBody = data
        } catch {
            print("Error al generar parametros del POST:", error)
        }
 
        URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if let error = error {
                print("Error al obtener la autorización:", error)
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            do {
                let firebaseResponse = try JSONDecoder().decode(FirebaseResponse.self, from: data)
                completion(.success(firebaseResponse))
            } catch {
                print("Error al decodificar la respuesta:", error)
                completion(.failure(error))
            }
        }.resume()
    }
}
