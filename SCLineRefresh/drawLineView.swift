//
//  drawLineView.swift
//  SCLineRefresh
//
//  Created by SnowCheng on 16/8/17.
//  Copyright © 2016年 SnowCheng. All rights reserved.
//

import UIKit

class drawLineView: UIView {

    func drawLine() {
        
        let path = UIBezierPath()
        
        path.moveToPoint(CGPointMake(20, 12))
        path.addLineToPoint(CGPointMake(20, 0))
        path.addLineToPoint(CGPointMake(0, 0))
        path.addLineToPoint(CGPointMake(0, 20))
        path.addLineToPoint(CGPointMake(20, 20))
        path.addLineToPoint(CGPointMake(20, 40))
        path.addLineToPoint(CGPointMake(0, 40))
        path.addLineToPoint(CGPointMake(0, 28))
        
        path.moveToPoint(CGPointMake(35, 40))
        path.addLineToPoint(CGPointMake(35, 20))
        path.addLineToPoint(CGPointMake(35, 0))
        path.addLineToPoint(CGPointMake(45, 20))
        path.addLineToPoint(CGPointMake(55, 40))
        path.addLineToPoint(CGPointMake(55, 20))
        path.addLineToPoint(CGPointMake(55, 0))
        
        path.moveToPoint(CGPointMake(70, 0))
        path.addLineToPoint(CGPointMake(90, 0))
        path.addLineToPoint(CGPointMake(90, 20))
        path.addLineToPoint(CGPointMake(90, 40))
        path.addLineToPoint(CGPointMake(70, 40))
        path.addLineToPoint(CGPointMake(70, 20))
        path.addLineToPoint(CGPointMake(70, 0))
        
        path.moveToPoint(CGPointMake(105, 0))
        path.addLineToPoint(CGPointMake(109, 20))
        path.addLineToPoint(CGPointMake(113, 40))
        path.addLineToPoint(CGPointMake(117, 20))
        path.addLineToPoint(CGPointMake(121, 0))
        path.addLineToPoint(CGPointMake(125, 20))
        path.addLineToPoint(CGPointMake(129, 40))
        path.addLineToPoint(CGPointMake(133, 20))
        path.addLineToPoint(CGPointMake(137, 0))

        
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.CGPath
        lineLayer.strokeColor = UIColor.redColor().CGColor
        lineLayer.fillColor = UIColor.clearColor().CGColor
        lineLayer.lineWidth = 1.5
        lineLayer.lineCap = "round"
        lineLayer.lineJoin = "round"
        
        layer.addSublayer(lineLayer)
    }
    
    func drawStar() {
        let path = UIBezierPath()
        
        path.moveToPoint(CGPointMake(0, 10))
        path.addLineToPoint(CGPointMake(11.55, 10))
        path.addLineToPoint(CGPointMake(23.10, 10))
        path.addLineToPoint(CGPointMake(34.64, 10))
        path.addLineToPoint(CGPointMake(28.87, 20))
        path.addLineToPoint(CGPointMake(23.09, 30))
        path.addLineToPoint(CGPointMake(17.32, 40))
        path.addLineToPoint(CGPointMake(11.55, 30))
        path.addLineToPoint(CGPointMake(5.77, 20))
        path.addLineToPoint(CGPointMake(0, 10))
        
        path.moveToPoint(CGPointMake(0, 30))
        path.addLineToPoint(CGPointMake(11.55, 30))
        path.addLineToPoint(CGPointMake(23.10, 30))
        path.addLineToPoint(CGPointMake(34.64, 30))
        path.addLineToPoint(CGPointMake(28.87, 20))
        path.addLineToPoint(CGPointMake(23.09, 10))
        path.addLineToPoint(CGPointMake(17.32, 00))
        path.addLineToPoint(CGPointMake(11.55, 10))
        path.addLineToPoint(CGPointMake(5.77, 20))
        path.addLineToPoint(CGPointMake(0, 30))
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.CGPath
        lineLayer.strokeColor = UIColor.redColor().CGColor
        lineLayer.fillColor = UIColor.clearColor().CGColor
        lineLayer.lineWidth = 1.5
        lineLayer.lineCap = "round"
        lineLayer.lineJoin = "round"
        
        layer.addSublayer(lineLayer)
    }

}
