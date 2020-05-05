//
//  CountClusterAnnotationView.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/14/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import Cluster

class CountClusterAnnotationView: ClusterAnnotationView {
	
	override func configure() {
		super.configure()
		
		guard let annotation = annotation as? ClusterAnnotation else { return }
		let count = annotation.annotations.count
		let diameter = radius(for: count) * 2
		frame.size = .init(width: diameter, height: diameter)
		layer.cornerRadius = frame.width / 2
		layer.masksToBounds = true
		layer.borderColor = UIColor.white.cgColor
		layer.borderWidth = 1.5
		backgroundColor = #colorLiteral(red: 0.137254902, green: 0.3568627451, blue: 0.3058823529, alpha: 1)
	}
	
	func radius(for count: Int) -> CGFloat {
		if count < 5 {
			return 12
		} else if count < 10 {
			return 16
		} else {
			return 20
		}
	}
}
