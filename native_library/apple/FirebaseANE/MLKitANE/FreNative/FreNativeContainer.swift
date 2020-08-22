//
//  FreNativeContainer.swift
//  VisionANE_LIB
//
//  Created by Eoin Landy on 28/10/2018.
//  Copyright © 2018 Tua Rua Ltd. All rights reserved.
//

import UIKit

class FreNativeContainer: UIView {
    
    convenience init(frame frameRect: CGRect, visible: Bool) {
        self.init(frame: frameRect)
        self.isHidden = !visible
        self.backgroundColor = UIColor.clear
    }
    
    override init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
