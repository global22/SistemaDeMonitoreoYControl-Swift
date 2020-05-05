//
//  BaseCardView.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 4/13/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

class BaseCardView: UIView {
	
	// MARK: - Properties
	
	enum Estado {
		case Expandido
		case NoExpandido
	}
	
	var title: String?
	lazy var closeButton = UIButton(image: #imageLiteral(resourceName: "cancelar.png"), tintColor: #colorLiteral(red: 0.5019999743, green: 0.5019999743, blue: 0.5019999743, alpha: 1), target: self, action: #selector(handleClose))
	let headerView = UIView(backgroundColor: #colorLiteral(red: 0.9610000253, green: 0.9610000253, blue: 0.9610000253, alpha: 1))
	let titleLabel = UILabel(text: "Title", font: .boldSystemFont(ofSize: 24), textColor: .black)
	var baseDelegate: BaseCardDelegate?
	let lineView = UIView(backgroundColor: #colorLiteral(red: 0.9959999919, green: 0.5099999905, blue: 0.00400000019, alpha: 1))
	open var baseLeadingAnchor: NSLayoutConstraint!
	open var estado: Estado?
	
	open var cornerRadius: CGFloat {
		return 10
	}
	
	open weak var parentController: UIViewController?
	
	// MARK: - Init
	
	init(title: String?, estado: Estado?) {
		self.title = title
		self.estado = estado
		super.init(frame: .zero)
		setupViewComponents()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Helpers
	
	open func setupViewComponents() {
		backgroundColor = #colorLiteral(red: 0.2039999962, green: 0.2269999981, blue: 0.2509999871, alpha: 1)
		
		layer.cornerRadius = cornerRadius

		addSubview(headerView)
		headerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 50))
		headerView.layer.cornerRadius = 10
		headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		
		headerView.addSubview(closeButton)
		closeButton.anchor(top: headerView.topAnchor, leading: nil, bottom: nil, trailing: headerView.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 0, right: 4), size: .init(width: 30, height: 30))
		
		headerView.addSubview(lineView)
		lineView.anchor(top: nil, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, trailing: headerView.trailingAnchor, size: .init(width: 0, height: 4))
		
		headerView.addSubview(titleLabel)
		titleLabel.anchor(top: nil, leading: headerView.leadingAnchor, bottom: lineView.topAnchor, trailing: headerView.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 4, right: 0))
		titleLabel.text = title
	}
	
	func setTitle(_ title: String) {
		titleLabel.text = title
	}
	
	// MARK: - Selectors
	
	@objc func handleClose() {
		baseDelegate?.cardView(self, didCloseWith: baseLeadingAnchor)
	}
	
}

// MARK: - Protocol BaseCardDelegate

protocol BaseCardDelegate {
	func cardView(_ cardView: BaseCardView, didCloseWith leadingAnchor: NSLayoutConstraint)
}
