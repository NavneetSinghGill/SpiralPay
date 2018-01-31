//
//  ProgressBar.swift
//  SpiralPay
//
//  Created by Zoeb on 24/01/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {
    
    private var progressBarViewTag = 98789
    
    var percentage: CGFloat = 0 {
        didSet {
            self.setProgressBar(value: percentage)
        }
    }
    
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.progressBar?.layer.cornerRadius = cornerRadius
        }
    }
    
    var progressBar: UIView?

    @IBInspectable
    var progressColor: UIColor = UIColor(displayP3Red: 0, green: 160/255, blue: 200/255, alpha: 1)
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSetup()
    }
    
    func initialSetup() {
        progressBar = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width * percentage, height: self.bounds.size.height))
        progressBar?.backgroundColor = progressColor
        progressBar?.layer.cornerRadius = self.layer.cornerRadius
        
        self.addSubview(progressBar!)
        
        self.clipsToBounds = true
        self.cornerRadius = self.bounds.size.height/2
    }
    
    func animate(fromPercentage: CGFloat, toPercentage: CGFloat, with completionBlock: @escaping () -> () = {}) {
        setProgressBar(value: fromPercentage)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.setProgressBar(value: toPercentage)
        }) { (completed) in
            self.percentage = toPercentage
            completionBlock()
        }
    }
    
    private func setProgressBar(value: CGFloat) {
        var newValue: CGFloat = value
        if value < 0 {
            newValue = 0
        } else if value > 1 {
            newValue = 1
        }
        progressBar?.frame.size = CGSize(width: self.bounds.size.width * newValue, height: self.bounds.size.height)
    }
    
}
