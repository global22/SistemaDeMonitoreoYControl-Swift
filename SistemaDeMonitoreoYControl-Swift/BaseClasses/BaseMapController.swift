//
//  BaseMapController.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/13/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import MapKit
import LBTATools
import Cluster
import SDWebImage

class BaseMapController: BaseViewController {
    
    // MARK: - Properties
	
	lazy var mapView: MKMapView = {
		let map = MKMapView()
		map.delegate = self
		return map
	}()
	
	fileprivate let defaultRegion: MKCoordinateRegion = {
		let coordinate = CLLocationCoordinate2DMake(19.4978, -99.1269)
		let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3500000, longitudinalMeters: 3500000)
		return region
	}()
	
	lazy var manager: ClusterManager = {
		let manager = ClusterManager()
		manager.delegate = self
		manager.maxZoomLevel = 17
		manager.minCountForClustering = 3
		manager.clusterPosition = .center
		return manager
	}()
    
    lazy var informacionButton = UIButton(image: #imageLiteral(resourceName: "info"), tintColor: .white, target: self, action: #selector(mostrarInformacion))
	
	private let transformer = SDImageResizingTransformer(size: CGSize(width: 50, height: 50), scaleMode: .fill)
	
    // MARK: - Life Cycle
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViewComponents()
	}
	
    // MARK: - Private Helpers
    
	fileprivate func setupViewComponents() {
		view.addSubview(mapView)
		mapView.fillSuperview()
		mapView.setRegion(defaultRegion, animated: true)
        
        view.addSubview(informacionButton)
        informacionButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 8))
        informacionButton.roundedButton(withSize: .init(width: 30, height: 30), backgroundColor: .white, cornerRadius: 15)
        informacionButton.backgroundColor = #colorLiteral(red: 0, green: 0.5879999995, blue: 0.6629999876, alpha: 1)
        informacionButton.addShadow()
	}
    
    fileprivate func setupUserMap(for annotation: IntegranteMapa, on mapView: MKMapView) -> MKAnnotationView {
        let identifier = NSStringFromClass(IntegranteMapa.self)
        let annotationView = mapView.annotationView(of: MKAnnotationView.self, annotation: annotation, reuseIdentifier: identifier)
        let customAnnotation = annotation
        annotationView.sd_setImage(with: URL(string: customAnnotation.icon), placeholderImage: nil, options: .scaleDownLargeImages, context: [.imageTransformer: transformer])
        annotationView.canShowCallout = true
        annotationView.centerOffset = CGPoint(x: 0, y: -(50 / 2))
        return annotationView
    }
    
    fileprivate func setupCluster(for annotation: ClusterAnnotation, on mapView: MKMapView) -> CountClusterAnnotationView {
        let identifier = NSStringFromClass(ClusterAnnotation.self)
        let annotationView = mapView.annotationView(of: CountClusterAnnotationView.self, annotation: annotation, reuseIdentifier: identifier)
        return annotationView
    }
    
    fileprivate func setupRoute(for annotation: RutaIntegrante, on mapView: MKMapView) -> MKAnnotationView {
        let identifier = NSStringFromClass(RutaIntegrante.self)
        let annotationView = mapView.annotationView(of: MKAnnotationView.self, annotation: annotation, reuseIdentifier: identifier)
        let customAnnotation = annotation
        annotationView.image = customAnnotation.getImage()
        return annotationView
    }
	
    // MARK: - Public Helpers
    
	func cleanMapView() {
		if !mapView.annotations.isEmpty {
			mapView.removeOverlays(mapView.overlays)
			mapView.removeAnnotations(mapView.annotations)
			manager.removeAll()
			mapView.setRegion(defaultRegion, animated: true)
		}
	}
    
    func showAnnotations() {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
	
	func setRegion() {
		mapView.setRegion(defaultRegion, animated: true)
	}
	
	func trazarRuta(_ rutasIntegrante: [RutaIntegrante], enMapa mapa: MKMapView) {
		var polylineCoordinates = [CLLocationCoordinate2D]()
		rutasIntegrante.forEach {
			let coordinate = $0.coordinate
			polylineCoordinates.append(coordinate)
		}
		let polyline = MKPolyline(coordinates: polylineCoordinates, count: polylineCoordinates.count)
		mapa.addOverlay(polyline)
	}
	
	func mostrarIntegrante(_ integrante: IntegranteMapa, enMapa mapa: MKMapView) {
		mapa.addAnnotation(integrante)
		mapa.showAnnotations(mapa.annotations, animated: true)
	}
	
	func mostrarPuntos(deRuta ruta: [RutaIntegrante], enMapa mapa: MKMapView) {
		manager.add(ruta)
		manager.reload(mapView: mapa)
	}
    
    // MARK: - Selectors
    
    @objc func mostrarInformacion(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Seccione un tipo de mapa", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(.init(title: "Estándar", style: .default, handler: { (_) in
            self.mapView.mapType = .standard
        }))
        alertController.addAction(.init(title: "Satélite", style: .default, handler: { (_) in
            self.mapView.mapType = .satellite
        }))
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.sourceRect = sender.bounds
        alertController.popoverPresentationController?.sourceView = sender
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - MKMapViewDelegate

extension BaseMapController: MKMapViewDelegate {
	open func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		manager.reload(mapView: mapView)
	}
	
	open func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if let polyline = overlay as? MKPolyline {
			let polylineRender = MKPolylineRenderer(overlay: polyline)
			polylineRender.strokeColor = #colorLiteral(red: 0, green: 0.6705882353, blue: 0.9333333333, alpha: 1) //UIColor.blue//darkGray.withAlphaComponent(0.5)
			polylineRender.lineWidth = 1.5
			return polylineRender
		}
		return MKOverlayRenderer()
	}
	
	open func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
		if let annotation = annotation as? ClusterAnnotation {
            annotationView = setupCluster(for: annotation, on: mapView)
			return annotationView
		} else if let annotation = annotation as? IntegranteMapa {
            annotationView = setupUserMap(for: annotation, on: mapView)
            return annotationView
		} else if let annotation = annotation as? RutaIntegrante {
			annotationView = setupRoute(for: annotation, on: mapView)
            return annotationView
		}
		
		return annotationView
	}

	open func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
		views.forEach { $0.alpha = 0 }
		UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
			views.forEach { $0.alpha = 1 }
		}, completion: nil)
	}
	
	open func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {  }
	
	open func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {  }
}

// MARK: - ClusterManagerDelegate

extension BaseMapController: ClusterManagerDelegate {
	func cellSize(for zoomLevel: Double) -> Double? {
		return nil
	}
	
	func shouldClusterAnnotation(_ annotation: MKAnnotation) -> Bool {
		return !(annotation is MKUserLocation)
	}
}
