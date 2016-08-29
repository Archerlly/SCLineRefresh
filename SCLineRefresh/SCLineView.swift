//
//  SCLineView.swift
//  SCLineRefresh
//
//  Created by SnowCheng on 16/8/15.
//  Copyright © 2016年 SnowCheng. All rights reserved.
//

import UIKit

class SCLineView: UIView {
    
// MARK: - Private property
    private var translationX: CGFloat = 0
    private var dropHeight: CGFloat = 0
    private var lineLayer = CAShapeLayer()
    
// MARK: - Public  property

// MARK: - override method (Init)
    init(frame: CGRect, startPoint: CGPoint, endPoint: CGPoint, color: UIColor, lineWidth: CGFloat, horizontalRandom: CGFloat, dropHeight: CGFloat) {
        super.init(frame: frame)
        
        self.dropHeight = dropHeight
        self.translationX = CGFloat(Int(arc4random()) % Int(horizontalRandom)) * 2 - horizontalRandom
        
        let middlePoint = CGPoint.init(x: (startPoint.x + endPoint.x) * 0.5, y: (startPoint.y + endPoint.y) * 0.5)
        let frameX = frame.origin.x + middlePoint.x - frame.size.width * 0.5
        let frameY = frame.origin.y + middlePoint.y - frame.size.height * 0.5
        self.frame = CGRect.init(origin: CGPoint.init(x: frameX, y: frameY), size: frame.size)
        
        let anchorX = middlePoint.x / frame.size.width
        let anchorY = middlePoint.y / frame.size.height
        self.layer.anchorPoint = CGPoint.init(x: anchorX, y: anchorY)
        self.transform = CGAffineTransformMakeTranslation(translationX, dropHeight)
        
        let path = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addLineToPoint(endPoint)
        
        lineLayer.path = path.CGPath
        lineLayer.lineWidth = lineWidth
        lineLayer.strokeColor = color.CGColor
        lineLayer.lineCap = "round"
        self.layer.addSublayer(lineLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

// MARK: - Public method
    func setProgress(progress: CGFloat) {
    
        let realProgress = 1 - progress
        let translate = CGAffineTransformMakeTranslation(translationX * realProgress, -dropHeight * realProgress)
        let scale = CGAffineTransformScale(translate, progress, progress)
        let rotate = CGAffineTransformRotate(scale, CGFloat(M_PI) * realProgress)
        transform = rotate
    }
    
    func updateLineWidth(lineWidth: CGFloat) {
        lineLayer.lineWidth = lineWidth
    }

// MARK: - Private method

// MARK: - @objc Action

// MARK: - lazy Loading
    

}
