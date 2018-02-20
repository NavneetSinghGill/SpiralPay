//
//  TabBarItemView.swift
//  SpiralPay
//
//  Created by Apple on 20/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class TabBarItemView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImageButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        
    }
    
}
