//
//  LlamadaEntranteCell.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 21/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

// MARK: - Protocol LlamadaEntranteDelegate

protocol LlamadaEntranteDelegate: class {
    func atenderLlamada(enIndice indice: IndexPath)
}

class LlamadaEntranteCell: UICollectionViewCell {
    
    // MARK: - Propertires
    
    var llamada: Llamada? {
        didSet {
            if let llamada = llamada {
                if llamada.registro.estado == .enEspera {
                    usuarioLabel.text = llamada.registro.idUsuarios_Movil
                    idLabel.alpha = 1
                    usuarioLabel.alpha = 1
                    
                    llamadaLabel.isHidden = false
                    imageView.isHidden = true
                    profileImageView.removeFromSuperview()
                    
                    if let subscriberView = llamada.subscriber?.view {
                        subscriberView.frame = viewContrainer.bounds
                        viewContrainer.insertSubview(subscriberView, at: 0)
                    }
                    
                    enEsperaButton.setTitle("Atender", for: .normal)
                    enEsperaButton.backgroundColor = #colorLiteral(red: 0.8550000191, green: 0.1609999985, blue: 0.1099999994, alpha: 1)
                    enEsperaButton.setTitleColor(.white, for: .normal)
                } else if llamada.registro.estado == .perdida {
                    profileImageView.sd_setImage(with: URL(string: llamada.usuario.img ?? "")!)
                    profileImageView.frame = viewContrainer.bounds
                    viewContrainer.insertSubview(profileImageView, at: 0)
                    
                    if let subscriberView = llamada.subscriber?.view {
                        subscriberView.removeFromSuperview()
                    }
                }
            } 
        }
    }
    
    weak var delegate: LlamadaEntranteDelegate?
    var indice: IndexPath!
    let viewContrainer = UIView(backgroundColor: #colorLiteral(red: 0.1019607843, green: 0.1254901961, blue: 0.1764705882, alpha: 1))
    let idLabel = UILabel(text: "ID de usuario", font: .systemFont(ofSize: 14), textColor: #colorLiteral(red: 0.9959999919, green: 0.5099999905, blue: 0.00400000019, alpha: 1), textAlignment: .left)
    let usuarioLabel = UILabel(text: "5555555", font: .systemFont(ofSize: 12), textColor: .white, textAlignment: .left)
    let separatorLineView = UIView(backgroundColor: .white)
    lazy var enEsperaButton = UIButton(title: "En Espera", titleColor: .black, font: .systemFont(ofSize: 14), backgroundColor: .white, target: self, action: #selector(atenderLlamada))
    let imageView = UIImageView(image: #imageLiteral(resourceName: "calluser"), contentMode: ContentMode.scaleAspectFill)
    let llamadaLabel = UILabel(text: "Llamada entrante", font: .boldSystemFont(ofSize: 12), textColor: .white, textAlignment: .center)
    let profileImageView = UIImageView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    fileprivate func setupViewComponents() {
        backgroundColor = #colorLiteral(red: 0.5019999743, green: 0.5019999743, blue: 0.5019999743, alpha: 1)
        
        viewContrainer.addBlackShadow()
        
        viewContrainer.addSubview(imageView)
        imageView.centerInSuperview()
        
        viewContrainer.addSubview(llamadaLabel)
        llamadaLabel.anchor(top: viewContrainer.topAnchor, leading: viewContrainer.leadingAnchor, bottom: nil, trailing: viewContrainer.trailingAnchor, size: .init(width: 0, height: 30))
        llamadaLabel.backgroundColor = .black
        llamadaLabel.isHidden = true
        
        imageView.withSize(.init(width: 150, height: 150))
        
        enEsperaButton.layer.cornerRadius = 15
        
        let stackView = stack(viewContrainer,
                              stack(idLabel,
                                    usuarioLabel,
                                    spacing: 2),
                              separatorLineView.withHeight(1),
                              stack(enEsperaButton).withMargins(.init(top: 0, left: 24, bottom: 0, right: 24)),
                              spacing: 4).withMargins(.allSides(8))
        
        addSubview(stackView)
        
        idLabel.alpha = 0
        usuarioLabel.alpha = 0
    }
    
    func reloadCell() {
        idLabel.alpha = 0
        usuarioLabel.alpha = 0
        llamadaLabel.isHidden = true
        imageView.isHidden = false
        enEsperaButton.backgroundColor = .white
        enEsperaButton.setTitle("En Espera", for: .normal)
        enEsperaButton.setTitleColor(.black, for: .normal)
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func atenderLlamada() {
        if llamada != nil {
            delegate?.atenderLlamada(enIndice: indice)
        }
    }
}
