//
//  UIView+HelperFunctions.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 1/20/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import MapKit
import Cluster

extension UIImage {
    
    func resizeImage(newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(.init(width: newWidth, height: newHeight))
        self.draw(in: .init(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension MKMapView {
    func annotationView<T: MKAnnotationView>(of type: T.Type, annotation: MKAnnotation?, reuseIdentifier: String) -> T {
        guard let annotationView = dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? T else {
            return type.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        annotationView.annotation = annotation
        return annotationView
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIView {
	func addShadow() {
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOpacity = 0.5
		layer.shadowOffset = .zero
		layer.shadowRadius = 3
	}
    
    func addBlackShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
    }
}

extension UIButton {
    func roundedButton(withSize size: CGSize, backgroundColor color: UIColor, cornerRadius radius: CGFloat, padding: UIEdgeInsets = .zero) {
		self.withSize(size)
		self.backgroundColor = color
		self.layer.cornerRadius = radius
		self.layer.borderWidth = 0.5
		self.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.imageEdgeInsets = padding
	}
	
	func roundedCornersButton(cornerRadius radius: CGFloat, borderColor color: UIColor) {
		self.layer.cornerRadius = radius
		self.layer.borderWidth = 1
		self.layer.borderColor = color.cgColor
	}
}
