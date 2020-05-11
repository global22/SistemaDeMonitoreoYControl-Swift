//
//  GenerarReporteView.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 07/05/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

class GenerarReporteView: UIView {
    
    // MARK: - Properties
    
    lazy var generarNuevoReporteButton = UIButton(title: "Generar nuevo reporte: 09:32:06", titleColor: .black, font: .systemFont(ofSize: 14), backgroundColor: #colorLiteral(red: 0, green: 0.6705882353, blue: 0.9333333333, alpha: 1), target: self, action: #selector(generarNuevoReporte))
    let incidentesCercanosView = UIView(backgroundColor: .white)
    
    let incidencias = ["Aborto", "Abuso de confianza", "Abuso sexual", "Accidente / Choque de vehiculos con heridos"]
    
    let descripcionLugarLabel = UILabel(text: "Descripción de Lugar:", font: .systemFont(ofSize: 12), textColor: #colorLiteral(red: 0.9959999919, green: 0.5099999905, blue: 0.00400000019, alpha: 1))
    let descripcionLugarTextField = UITextField()
    let reporteLabel = UILabel(text: "Reporte:", font: .systemFont(ofSize: 12), textColor: #colorLiteral(red: 0.9959999919, green: 0.5099999905, blue: 0.00400000019, alpha: 1))
    let reporteTextField = UITextField()
    let incidenteLabel = UILabel(text: "Incidente", font: .systemFont(ofSize: 12), textColor: #colorLiteral(red: 0.9959999919, green: 0.5099999905, blue: 0.00400000019, alpha: 1))
    let incidenciasTableView = UITableView()
    let incidenciasSearchBar = UISearchBar()
    let prioridadLabel = UILabel(text: "Prioridad", font: .systemFont(ofSize: 12), textColor: #colorLiteral(red: 0.9959999919, green: 0.5099999905, blue: 0.00400000019, alpha: 1), textAlignment: .left)
    let prioridadDetalleLabel = UILabel(text: "Tipo de prioridad", font: .systemFont(ofSize: 14), textColor: .white, textAlignment: .center)
    lazy var establecerYNotificarButton = UIButton(title: "Establecer y Notificar", titleColor: .white, font: .boldSystemFont(ofSize: 14), backgroundColor: #colorLiteral(red: 0.8550000191, green: 0.1609999985, blue: 0.1099999994, alpha: 1), target: self, action: #selector(establecerYNotificar))
    let folioInternoLabel = UILabel(text: "Folio Interno", font: .systemFont(ofSize: 12), textColor: #colorLiteral(red: 0.9959999919, green: 0.5099999905, blue: 0.00400000019, alpha: 1), textAlignment: .left)
    let folioInternoDetalleLabel = UILabel(text: "Folio interno", font: .systemFont(ofSize: 14), textColor: .white, textAlignment: .center)
    let folioIncidentesLabel = UILabel(text: "Folio Incidentes", font: .systemFont(ofSize: 12), textColor: #colorLiteral(red: 0.9959999919, green: 0.5099999905, blue: 0.00400000019, alpha: 1), textAlignment: .left)
    let folioIncidentesDetalleLabel = UILabel(text: "Folio incedentes", font: .systemFont(ofSize: 14), textColor: .white, textAlignment: .center)
    let folioExternoLabel = UILabel(text: "Folio Externo", font: .systemFont(ofSize: 12), textColor: #colorLiteral(red: 0.9959999919, green: 0.5099999905, blue: 0.00400000019, alpha: 1), textAlignment: .left)
    let folioExternoTextField = IndentedTextField(placeholder: "Folio externo", padding: 8, cornerRadius: 15, backgroundColor: .white)
    lazy var guardarButton = UIButton(title: "Guardar", titleColor: .white, font: .boldSystemFont(ofSize: 14), backgroundColor: #colorLiteral(red: 0.8550000191, green: 0.1609999985, blue: 0.1099999994, alpha: 1), target: self, action: #selector(guardarReporte))
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func setupViewComponents() {
        let generarReporteLabel = UILabel(text: "\tGENERAR REPORTE", font: .systemFont(ofSize: 16), textColor: .white, textAlignment: .left)
        generarReporteLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 0.662745098, alpha: 1)
        generarReporteLabel.withHeight(30)
        
        let incidentesCercanosLabel = UILabel(text: " Incidentes Cercanos", font: .boldSystemFont(ofSize: 16), textColor: .white, textAlignment: .left)
        incidentesCercanosLabel.backgroundColor = #colorLiteral(red: 0.5019999743, green: 0.5019999743, blue: 0.5019999743, alpha: 1)
        incidentesCercanosLabel.withHeight(40)
        
        let detallarReporteLabel = UILabel(text: " Detallar Reporte", font: .boldSystemFont(ofSize: 16), textColor: .white, textAlignment: .left)
        detallarReporteLabel.backgroundColor = #colorLiteral(red: 0.5019999743, green: 0.5019999743, blue: 0.5019999743, alpha: 1)
        detallarReporteLabel.withHeight(40)
        
        let notificacionDependenciasLabel = UILabel(text: " Detallar Reporte", font: .boldSystemFont(ofSize: 16), textColor: .white, textAlignment: .left)
        notificacionDependenciasLabel.backgroundColor = #colorLiteral(red: 0.5019999743, green: 0.5019999743, blue: 0.5019999743, alpha: 1)
        notificacionDependenciasLabel.withHeight(40)
        
        generarNuevoReporteButton.layer.cornerRadius = 15
        incidentesCercanosView.layer.cornerRadius = 10
        
        descripcionLugarTextField.backgroundColor = #colorLiteral(red: 0.9610000253, green: 0.9610000253, blue: 0.9610000253, alpha: 1)
        descripcionLugarTextField.layer.cornerRadius = 10
        descripcionLugarTextField.layer.masksToBounds = true
        
        reporteTextField.backgroundColor = #colorLiteral(red: 0.9610000253, green: 0.9610000253, blue: 0.9610000253, alpha: 1)
        reporteTextField.layer.cornerRadius = 10
        reporteTextField.layer.masksToBounds = true
        
        incidenciasTableView.delegate = self
        incidenciasTableView.dataSource = self
        
        incidenciasSearchBar.placeholder = "Selecciona un incidente"
        incidenciasSearchBar.delegate = self
        incidenciasSearchBar.showsCancelButton = true
        
        prioridadDetalleLabel.backgroundColor = #colorLiteral(red: 0.7725490196, green: 0.7725490196, blue: 0.7725490196, alpha: 0.14)
        prioridadDetalleLabel.layer.cornerRadius = 5
        prioridadDetalleLabel.layer.masksToBounds = true
        
        establecerYNotificarButton.layer.cornerRadius = 15
        establecerYNotificarButton.layer.masksToBounds = true
        
        guardarButton.layer.cornerRadius = 15
        guardarButton.layer.masksToBounds = true
        
        let stackView = stack(generarReporteLabel,
                              incidentesCercanosLabel,
                              stack(stack(generarNuevoReporteButton.withHeight(40)).withMargins(.init(top: 8, left: 32, bottom: 0, right: 32)),
                                    stack(incidentesCercanosView.withHeight(120)).withMargins(.allSides(8))),
                              detallarReporteLabel,
                              stack(stack(descripcionLugarLabel,
                                                          descripcionLugarTextField.withHeight(70),
                                                          spacing: 4),
                                                    stack(reporteLabel,
                                                          reporteTextField.withHeight(70),
                                                          spacing: 4).padTop(8),
                                                    stack(incidenteLabel,
                                                          stack(incidenciasSearchBar.withHeight(50),
                                                                incidenciasTableView.withHeight(100)),
                                                          spacing: 4).padTop(8),
                                                    hstack(prioridadLabel,
                                                           prioridadDetalleLabel.withSize(.init(width: 200, height: 30)),
                                                           spacing: 4).padTop(8),
                                                    stack(establecerYNotificarButton.withHeight(30)).withMargins(.init(top: 8, left: 50, bottom: 0, right: 50)),
                                                    hstack(folioInternoLabel,
                                                           folioInternoDetalleLabel.withSize(.init(width: 200, height: 30)),
                                                           spacing: 4).padTop(8),
                                                    hstack(folioIncidentesLabel,
                                                           folioIncidentesDetalleLabel.withSize(.init(width: 200, height: 30)),
                                                           spacing: 4).padTop(8),
                                                    hstack(folioExternoLabel,
                                                           folioExternoTextField.withSize(.init(width: 200, height: 30)),
                                                           spacing: 4).padTop(8),
                                                    stack(guardarButton.withHeight(30)).withMargins(.init(top: 8, left: 50, bottom: 0, right: 50)),
                                                    UIView()
                              ).withMargins(.allSides(8)),
                              notificacionDependenciasLabel,
                              UIView()
                              )
        
        addSubview(stackView)
    }
    
    // MARK: - Selectors
    
    @objc func generarNuevoReporte() {
        print("Intentando generar un nuevo reporte")
    }
    
    @objc func establecerYNotificar() {
        print("Establecer y notificar")
    }
    
    @objc func guardarReporte() {
        print("Guardar")
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource

extension GenerarReporteView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incidencias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = incidencias[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 12)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = incidencias[indexPath.row]
        incidenciasSearchBar.text = text
    }
}

// MARK: - UISearchBarDelegate

extension GenerarReporteView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
