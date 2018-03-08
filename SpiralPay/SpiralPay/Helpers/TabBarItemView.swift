//
//  TabBarItemView.swift
//  SpiralPay
//
//  Created by Zoeb on 20/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class TabBarItemView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImageButton: UIButton!
    
    var isSelected: Bool! {
        didSet {
            if titleImageButton != nil && titleLabel != nil {
                if isSelected {
                    self.titleImageButton.isSelected = true
                    self.titleLabel.textColor = Colors.mediumBlue
                } else {
                    self.titleImageButton.isSelected = false
                    self.titleLabel.textColor = Colors.grey
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        self.isSelected = false
    }
    
}
