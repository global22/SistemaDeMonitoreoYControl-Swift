//
//  DarkBlurView.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 23/04/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit

class DarkBlurView: UIVisualEffectView {
    let blurView = UIBlurEffect(style: .dark)
    var cornerRadius: CGFloat?
    var maskToBounds: Bool?
    
    init(cornerRadius: CGFloat = 0, maskToBounds: Bool = false) {
        super.init(effect: blurView)
        self.cornerRadius = cornerRadius
        self.maskToBounds = maskToBounds
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = maskToBounds
        
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
