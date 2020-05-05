//
//  Menu.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 1/20/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import Foundation

enum Menu: Int, CustomStringConvertible {
    case Administrador
    case MonitoreoDeUnidades
    case BusquedaDeReporte
    case PDFUsuariosRegistrados
    case RegistrarUnUsuario
    case ReporteDeIncidenteOperativo
    
    var description: String {
        switch self {
        case .Administrador:
            return "Administrador"
        case .MonitoreoDeUnidades:
            return "Monitoreo de Unidades"
        case .BusquedaDeReporte:
            return "Búsqueda de Reporte"
        case .PDFUsuariosRegistrados:
            return "PDF - Usuarios Registrados"
        case .RegistrarUnUsuario:
            return "Registrar un Usuario"
        case .ReporteDeIncidenteOperativo:
            return "Reporte de Incidente Operativo"
        }
    }
}
