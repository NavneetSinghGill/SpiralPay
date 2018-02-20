//
//  BezierPathExtenstion.swift
//  SpiralPay
//
//  Created by Zoeb on 21/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import Foundation
import UIKit

extension UIBezierPath {
    
    class func interpolateCGPointsWithHermite(pointsAsNSValues: Array<AnyObject>, closed: Bool) -> UIBezierPath? {
        if pointsAsNSValues.count < 2 {
            return nil
        }
        
        let nCurves = closed ? pointsAsNSValues.count : pointsAsNSValues.count - 1
        
        let path = UIBezierPath()
        
        for ii in 0..<nCurves {
            let value = pointsAsNSValues[ii]
            
            var curPt : CGPoint?, prevPt : CGPoint?, nextPt : CGPoint?, endPt : CGPoint?
//            value.getValue(&curPt)
            curPt = value as? CGPoint
            if ii == 0 {
                path.move(to: curPt!)
            }
            
            var nextii = (ii + 1)%pointsAsNSValues.count
            var previi = ii - 1 < 0 ? pointsAsNSValues.count - 1 : ii-1
            
//            pointsAsNSValues[previi].getValue(&prevPt)
            prevPt = pointsAsNSValues[previi] as? CGPoint
//            pointsAsNSValues[nextii].getValue(&nextPt)
            nextPt = pointsAsNSValues[nextii] as? CGPoint
            endPt = nextPt
            
            var mx: CGFloat, my: CGFloat
            if closed || ii > 0 {
                mx = (nextPt!.x - curPt!.x) * 0.5 + (curPt!.x - prevPt!.x) * 0.5
                my = (nextPt!.y - curPt!.y) * 0.5 + (curPt!.y - prevPt!.y) * 0.5
            } else {
                mx = (nextPt!.x - curPt!.x) * 0.5;
                my = (nextPt!.y - curPt!.y) * 0.5;
            }
            
            var ctrlPt1 = CGPoint()
            ctrlPt1.x = curPt!.x + mx / 3.0;
            ctrlPt1.y = curPt!.y + my / 3.0;
            
            pointsAsNSValues[nextii].getValue(&curPt)
            
            nextii = (nextii + 1) % pointsAsNSValues.count
            previi = ii
            
            pointsAsNSValues[previi].getValue(&prevPt)
            pointsAsNSValues[nextii].getValue(&nextPt)
            
            if closed || ii < nCurves - 1 {
                mx = (nextPt!.x - curPt!.x) * 0.5 + (curPt!.x - prevPt!.x) * 0.5
                my = (nextPt!.y - curPt!.y) * 0.5 + (curPt!.y - prevPt!.y) * 0.5
            }
            else {
                mx = (curPt!.x - prevPt!.x) * 0.5
                my = (curPt!.y - prevPt!.y) * 0.5
            }
            
            var ctrlPt2 = CGPoint()
            ctrlPt2.x = curPt!.x - mx / 3.0
            ctrlPt2.y = curPt!.y - my / 3.0
            
            path.addCurve(to: endPt!, controlPoint1: ctrlPt1, controlPoint2: ctrlPt2)
        }
        
        if closed {
            path.close()
        }
        
        return path
    }
    
}
