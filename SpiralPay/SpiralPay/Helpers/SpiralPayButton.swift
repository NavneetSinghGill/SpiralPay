//
//  SpiralPayButton.swift
//  SpiralPay
//
//  Created by Zoeb on 29/01/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class SpiralPayButton: UIButton {

    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.alpha = 1
            } else {
                self.alpha = 0.4
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isSelected = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isSelected = false
    }
    
}
