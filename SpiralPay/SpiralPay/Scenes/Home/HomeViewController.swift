//
//  HomeViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 20/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class HomeViewController: SpiralPayViewController {
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var customSegmentBlueView: UIView!
    @IBOutlet weak var customSegmentBlueViewTrailingConstraint: NSLayoutConstraint!
    
    var shapeL: CAShapeLayer?
    var dotsL: CAShapeLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let points = [CGPoint(x: 0, y: 0), CGPoint(x: graphView.frame.size.width/2, y: graphView.frame.size.height/2), CGPoint(x: graphView.frame.size.width, y: 0)]
        
        addLineGraphWith(points: points)
        addDotsTo(points: points)
    }
    
    private func addLineGraphWith(points: [CGPoint]) {
        let aPath = UIBezierPath.interpolateCGPointsWithHermite(pointsAsNSValues: points as Array<AnyObject>, closed: false)
        
        shapeL = CAShapeLayer()
        shapeL!.path = aPath!.cgPath
        shapeL!.fillColor = UIColor.clear.cgColor
        shapeL!.strokeColor = Colors.pink.cgColor
        shapeL!.lineWidth = 2
        
        shapeL!.masksToBounds = false
        shapeL!.shadowColor = UIColor.black.cgColor
        shapeL!.shadowOpacity = 0.2
        shapeL!.shadowOffset = CGSize(width: 0, height: 2)
        shapeL!.shadowRadius = 2
        shapeL!.shouldRasterize = true
        
        graphView.layer.addSublayer(shapeL!)
    }
    
    private func addDotsTo(points: [CGPoint]) {
        dotsL = CAShapeLayer()
        for point in points {
            let greyDot = CAShapeLayer()
            
            let greyDotPath = UIBezierPath(arcCenter: point,
                                           radius: 8,
                                           startAngle: 0,
                                           endAngle: 6*CGFloat.pi,
                                           clockwise: true)
            greyDot.path = greyDotPath.cgPath
            greyDot.fillColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.9).cgColor
            
            greyDot.masksToBounds = false
            greyDot.shadowColor = UIColor.black.cgColor
            greyDot.shadowOpacity = 0.2
            greyDot.shadowOffset = CGSize(width: 0, height: 2)
            greyDot.shadowRadius = 2
            greyDot.shouldRasterize = true
            
            dotsL?.addSublayer(greyDot)
            
            let dot = CAShapeLayer()
            
            let pinkDotPath = UIBezierPath(arcCenter: point,
                                           radius: 4,
                                           startAngle: 0,
                                           endAngle: 6*CGFloat.pi,
                                           clockwise: true)
            dot.path = pinkDotPath.cgPath
            dot.fillColor = Colors.pink.cgColor
            dotsL?.addSublayer(dot)
        }
        
        graphView.layer.addSublayer(dotsL!)
    }
    
    //MARK:- IBAction methods
    
    @IBAction func thisWeekButtonTapped() {
        customSegmentBlueViewTrailingConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        UIView.transition(with: weekButton,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.weekButton.setTitleColor(.white, for: .normal)
        },
                          completion: nil)
        
        UIView.transition(with: monthButton,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.monthButton.setTitleColor(UIColor(white: 130/255, alpha: 1), for: .normal)
        },
                          completion: nil)
    }
    
    @IBAction func thisMonthButtonTapped() {
        customSegmentBlueViewTrailingConstraint.constant = customSegmentBlueView.frame.size.width
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        UIView.transition(with: weekButton,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.weekButton.setTitleColor(UIColor(white: 130/255, alpha: 1), for: .normal)
        },
                          completion: nil)
        
        UIView.transition(with: monthButton,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.monthButton.setTitleColor(.white, for: .normal)
        },
                          completion: nil)
    }
    
}
