//
//  CircularProgressView.swift
//  SpiralPay
//
//  Created by Navneet on 26/04/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {
    
    let shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSetup()
    }
    
    func initialSetup() {
        let center = CGPoint(x: self.frame.size.height/2, y: self.frame.size.height/2)
        
        // create my track layer
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: center, radius: frame.size.height/2, startAngle: -CGFloat.pi / 2, endAngle: (2 * CGFloat.pi)-(CGFloat.pi / 2), clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1).cgColor
        trackLayer.lineWidth = 5
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = kCALineCapRound
        self.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = Colors.mediumBlue.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.strokeEnd = 0
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func setProgress(percentage: CGFloat) { // 0 to 1
        var percentageCorrected: CGFloat = percentage
        if percentage < 0 {
            percentageCorrected = 0
        } else if percentage > 1 {
            percentageCorrected = 1
        }
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = percentageCorrected
        basicAnimation.duration = 0.001
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
}
