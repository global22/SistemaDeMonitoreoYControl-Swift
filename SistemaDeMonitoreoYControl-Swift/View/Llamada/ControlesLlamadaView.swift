//
//  ControlesLlamadaView.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 23/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit
import LBTATools

// MARK: - Protocol ControlesLlamadaDelegate

protocol ControlesLlamadaDelegate: class {
    func controlesLlamadaView(_ controlesLlamadaView: ControlesLlamadaView, didExpand expand: Bool)
}

class ControlesLlamadaView: UIView {
    
    enum Estado {
        case Oculto
        case Expandido
        case NoExpandido
    }
    
    // MARK: - Properties
    
    weak var delegate: ControlesLlamadaDelegate?
    
    let indicatorsView = UIView(backgroundColor: .gray)
    
    lazy var cambiarCamaraButton = UIButton(image: #imageLiteral(resourceName: "rotar_camara"), tintColor: .white, target: self, action: nil)
    lazy var microfonoButton = UIButton(image: #imageLiteral(resourceName: "mic_off"), tintColor: .white, target: self, action: nil)
    lazy var finalizarLlamadaButton = UIButton(image: #imageLiteral(resourceName: "cancelar_2"), tintColor: .white, target: self, action: nil)
    lazy var volumenButton = UIButton(image: #imageLiteral(resourceName: "volumen_off"), tintColor: .white, target: self, action: nil)
    lazy var videoButton = UIButton(image: #imageLiteral(resourceName: "video_off"), tintColor: .white, target: self, action: nil)
    
    fileprivate let cellId = "cellId"
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = .clear
        tv.tableFooterView = UIView()
        return tv
    }()
    
    fileprivate let buttonSize = CGSize(width: 50, height: 50)
    lazy var buttonCornerRadius: CGFloat = buttonSize.height / 2
    fileprivate let buttonImageInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    var estado: Estado!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        estado = .Oculto
        setupBlurView()
        setupViewComponents()
        setupSwipeGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    fileprivate func setupViewComponents() {
        backgroundColor = .clear
        
        indicatorsView.withSize(.init(width: 50, height: 5))
        indicatorsView.layer.cornerRadius = 2.5
        
        cambiarCamaraButton.roundedButton(withSize: buttonSize, backgroundColor: .gray, cornerRadius: buttonCornerRadius, padding: buttonImageInsets)
        microfonoButton.roundedButton(withSize: buttonSize, backgroundColor: .gray, cornerRadius: buttonCornerRadius, padding: buttonImageInsets)
        finalizarLlamadaButton.roundedButton(withSize: buttonSize, backgroundColor: #colorLiteral(red: 0.8550000191, green: 0.1609999985, blue: 0.1099999994, alpha: 1), cornerRadius: buttonCornerRadius, padding: buttonImageInsets)
        volumenButton.roundedButton(withSize: buttonSize, backgroundColor: .gray, cornerRadius: buttonCornerRadius, padding: buttonImageInsets)
        videoButton.roundedButton(withSize: buttonSize, backgroundColor: .gray, cornerRadius: buttonCornerRadius, padding: buttonImageInsets)
        
        stack(indicatorsView,
              hstack(cambiarCamaraButton,
                     microfonoButton,
                     finalizarLlamadaButton,
                     volumenButton,
                     videoButton,
                     spacing: 8),
              UIView(),
              spacing: 16,
            alignment: .center).padTop(4)
        
        addSubview(tableView)
        tableView.anchor(top: finalizarLlamadaButton.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func setupBlurView() {
        let blurView = DarkBlurView(cornerRadius: 10, maskToBounds: true)
        insertSubview(blurView, at: 0)
        blurView.fillSuperview()
    }
    
    fileprivate func setupSwipeGestures() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(expandView))
        swipeUp.direction = .up
        addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(expandView))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func expandView(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            delegate?.controlesLlamadaView(self, didExpand: true)
        } else {
            delegate?.controlesLlamadaView(self, didExpand: false)
        }
    }
}

// MARK: - UITableViewDataSource

extension ControlesLlamadaView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text = "\(indexPath.row + 1)"
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ControlesLlamadaView: UITableViewDelegate {
    
}
