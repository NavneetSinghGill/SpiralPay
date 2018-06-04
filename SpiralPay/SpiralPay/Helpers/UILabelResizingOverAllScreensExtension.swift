//
//  UILabelResizingOverAllScreensExtension.swift
//  SpiralPay
//
//  Created by Zoeb on 25/04/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

extension UILabel {
    
    private struct VarKeys {
        static var fontKey: UInt8 = 0
        static var autoResizeKey: UInt8 = 1
        static var defaultFontKey: UInt8 = 1
    }
    
    private var defaultFont: UIFont {
        get {
            guard let value = objc_getAssociatedObject(self, &VarKeys.defaultFontKey) as? UIFont else {
                return self.font
            }
            
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &VarKeys.defaultFontKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var autoResize: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &VarKeys.autoResizeKey) as? Bool else {
                return false
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &VarKeys.autoResizeKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if newValue == true {
                defaultFont = self.font
                if UIDevice().userInterfaceIdiom == .phone {
                    switch UIScreen.main.nativeBounds.height {
                    case 1136:
                        Utils.print(object: ("iPhone 5 or 5S or 5C"))
                        self.font = defaultFont.withSize(defaultFont.pointSize)
                    case 1334:
                        Utils.print(object: ("iPhone 6/6S/7/8"))
                        self.font = defaultFont.withSize(defaultFont.pointSize + 2)
                    case 2208:
                        Utils.print(object: ("iPhone 6+/6S+/7+/8+"))
                        self.font = defaultFont.withSize(defaultFont.pointSize + 3)
                    case 2436:
                        Utils.print(object: ("iPhone X"))
                        self.font = defaultFont.withSize(defaultFont.pointSize + 4)
                    default:
                        Utils.print(object: ("unknown"))
                    }
                }
            }
            
        }
    }
    
    @IBInspectable
    open var shouldAutoResize: Bool {
        get {
            return self.autoResize
        }
        set {
            self.autoResize = newValue
        }
    }
    
//    @IBInspectable
//    var font: UIFont {
//        didSet {
//            self.font = self.font
//        }
//    }
    
}
