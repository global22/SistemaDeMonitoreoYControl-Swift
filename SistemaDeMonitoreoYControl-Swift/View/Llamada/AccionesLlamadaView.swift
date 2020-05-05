//
//  AccionesLlamadaView.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 23/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

// MARK: - Protocol AccionesLlamadaDelegate

protocol AccionesLlamadaDelegate: class {
    func mostrarChat()
    func mostrarMapa()
    func mostrarInformacion()
}

class AccionesLlamadaView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: AccionesLlamadaDelegate?
    
    lazy var chatButton = UIButton(image: #imageLiteral(resourceName: "chat"), tintColor: .white, target: self, action: #selector(seleccionarChat))
    lazy var mapButton = UIButton(image: #imageLiteral(resourceName: "map"), tintColor: .white, target: self, action: #selector(seleccionarMapa))
    lazy var infoButton = UIButton(image: #imageLiteral(resourceName: "info"), tintColor: .white, target: self, action: #selector(seleccionarInformacion))
    
    fileprivate let buttonSize = CGSize(width: 50, height: 50)
    lazy var buttonCornerRadius: CGFloat = buttonSize.height / 2
    fileprivate let buttonImageInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurView()
        setupViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    fileprivate func setupBlurView() {
        let blurView = DarkBlurView(cornerRadius: 10, maskToBounds: true)
        insertSubview(blurView, at: 0)
        blurView.fillSuperview()
    }
    
    fileprivate func setupViewComponents() {
        infoButton.roundedButton(withSize: buttonSize, backgroundColor: .gray, cornerRadius: buttonCornerRadius, padding: buttonImageInsets)
        mapButton.roundedButton(withSize: buttonSize, backgroundColor: .gray, cornerRadius: buttonCornerRadius, padding: buttonImageInsets)
        chatButton.roundedButton(withSize: buttonSize, backgroundColor: .gray, cornerRadius: buttonCornerRadius, padding: buttonImageInsets)
        
        let stackView = hstack(infoButton,
                               mapButton,
                               chatButton,
                               spacing: 8).withMargins(.allSides(16))
        
        addSubview(stackView)
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func seleccionarChat(_ sender: UIButton) {
        delegate?.mostrarChat()
    }
    
    @objc fileprivate func seleccionarMapa(_ sender: UIButton) {
        delegate?.mostrarMapa()
    }
    
    @objc fileprivate func seleccionarInformacion(_ sender: UIButton) {
        delegate?.mostrarInformacion()
    }
}
