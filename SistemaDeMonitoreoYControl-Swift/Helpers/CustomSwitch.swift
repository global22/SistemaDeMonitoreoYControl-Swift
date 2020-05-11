//
//  CustomSwitch.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Alberto Garcia on 08/05/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import UIKit

class CustomSwitch: UISwitch {
    
    init() {
        super.init(frame: .zero)
        self.transform = .init(scaleX: 0.75, y: 0.75)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
