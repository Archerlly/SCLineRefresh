//
//  CustomLineView.swift
//  SCLineRefresh
//
//  Created by SnowCheng on 16/8/17.
//  Copyright © 2016年 SnowCheng. All rights reserved.
//

import UIKit

class CustomLineView: UIView {
    
    var lines = [CAShapeLayer]()
    var totalPoints = [[CGPoint]]()
    var currentPoints = [CGPoint]()
    var beginDrawHandel: (() -> ())?
    var totalRect = CGRectZero

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        beginDrawHandel?()
        
        if let point = touches.first?.locationInView(self) {
            currentPoints = [CGPoint]()
            currentPoints.append(point)
            lines.append(CAShapeLayer())
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let point = touches.first?.locationInView(self) {
            currentPoints.append(point)
            drawLine()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if currentPoints.count > 1 {
            totalPoints.append(currentPoints)
        }
    }
    
    private func drawLine() {
        lines.last?.removeFromSuperlayer()
        
        let line = CAShapeLayer()
        let path = UIBezierPath()
        path.moveToPoint(currentPoints.first!)
        
        for point in currentPoints {
            path.addLineToPoint(point)
        }
        
        let currentRect = path.bounds;
        if totalRect.isEmpty {
            totalRect = currentRect
        } else {
            totalRect = totalRect.union(currentRect)
        }
        
        line.path = path.CGPath
        line.strokeColor = UIColor.redColor().CGColor
        line.fillColor = UIColor.clearColor().CGColor
        line.lineWidth = 1.5
        line.lineCap = "round"
        line.lineJoin = "round"
        
        lines.append(line)
        layer.addSublayer(line)
    }
    
    private func convertPoint(point: CGPoint, fromRect: CGRect, toRect: CGRect) -> CGPoint {
        let tx = fromRect.origin.x - toRect.origin.x
        let ty = fromRect.origin.y - toRect.origin.y
        
        return CGPoint.init(x: point.x + tx, y: point.y + ty)
    }
    
    func completeDraw() -> Bool {
        var startPoints = [String]()
        var endPoints = [String]()
        
        let totalPointsStringArr = totalPoints.map { (points) -> [String] in
           
            return points.map({ (point) -> String in
                let newPoint = convertPoint(point, fromRect: bounds, toRect: totalRect)
                return NSStringFromCGPoint(newPoint)
            })
            
        }
        
        for pointsString in totalPointsStringArr {
            startPoints.appendContentsOf(pointsString.dropLast())
            endPoints.appendContentsOf(pointsString.dropFirst())
        }
        
        for line in lines {
            line.removeFromSuperlayer()
        }
        totalPoints.removeAll()
        
        if startPoints.count > 0 && endPoints.count > 0 {
            
            let dic = ["startPoints": startPoints, "endPoints": endPoints]
            let path = NSBundle.mainBundle().pathForResource("demo", ofType: "plist")!
            (dic as NSDictionary).writeToFile(path, atomically: true)
            
            return true
        } else {
            return false
        }
        
        
    }

}
