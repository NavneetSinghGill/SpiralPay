//
//  UIViewExtension.swift
//  SpiralPay
//
//  Created by Zoeb on 15/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var borderWidth : CGFloat {
        set {
            layer.borderWidth = newValue
        }
        
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat {
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
        
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor : UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
    }
    
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 2
        
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}
