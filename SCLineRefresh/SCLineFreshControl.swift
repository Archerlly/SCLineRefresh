//
//  SCLineFreshControl.swift
//  SCLineRefresh
//
//  Created by SnowCheng on 16/8/15.
//  Copyright © 2016年 SnowCheng. All rights reserved.
//

import UIKit

class SCLineFreshControl: UIControl {
    
    enum RefreshStage {
        case Draging
        case PrapareRefresh
        case Refreshing
        case ReFreshEnd
    }
    
    // MARK: - Private property
    
    private let kNormalAlpha: CGFloat = 0.5
    
    private var dropHeight: CGFloat = 0
    
    private var lineWidth: CGFloat = 0

    private var lineArr = [SCLineView]()
    
    private var timeLink: CADisplayLink?
    
    private var sc_superView: UIScrollView!
    
    private var defaultContentInsetTop: CGFloat = 0
    
    private var internalAnimationFactor: CGFloat = 0
    
    private var reverseLoadingAnimation = false
    
    private var currentStage = RefreshStage.Draging
    
    private var currentProgress: CGFloat = 0 {
        didSet {
            updateLineItem(currentProgress)
        }
    }
    
    // MARK: - Public  property
    var refreshHandle: ((render: SCLineFreshControl)->())?
    
    // MARK: - override method (Init)
    init(plistName: String, lineWidth: CGFloat, lineColor: UIColor, horizontalRandom: CGFloat, dropHeight: CGFloat, scale: CGFloat, reverseLoadingAnimation: Bool, internalAnimationFactor: CGFloat) {
        super.init(frame: CGRectZero)
        
        update(plistName, lineWidth: lineWidth, lineColor: lineColor, horizontalRandom: horizontalRandom, dropHeight: dropHeight, scale: scale, reverseLoadingAnimation: reverseLoadingAnimation, internalAnimationFactor: internalAnimationFactor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        sc_superView = newSuperview as? UIScrollView ?? UIScrollView()
        sc_superView.addObserver(self, forKeyPath: "contentOffset", options:[.New, .Old], context: nil)
        defaultContentInsetTop = sc_superView.contentInset.top
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset" {
            
            let point = sc_superView.contentOffset
            
            let bounceHeight = -point.y - defaultContentInsetTop
            center = CGPoint.init(x: sc_superView.bounds.size.width * 0.5, y: point.y * 0.5)
            
//            print("\(bounceHeight)---\(point)")
            
            switch currentStage {
            case .Draging:
                currentProgress = max(min(bounceHeight / dropHeight, 1), 0)
                currentStage = bounceHeight > dropHeight ? .PrapareRefresh : .Draging
                
            case .PrapareRefresh:
                currentStage = bounceHeight > dropHeight ? .PrapareRefresh : .Draging
                if !sc_superView.dragging {
                    currentStage = .Refreshing
                    UIView.animateWithDuration(0.25, animations: {
                        (self.sc_superView.contentInset.top = self.defaultContentInsetTop + self.bounds.size.height * 1.5)
                    })
                    refreshHandle?(render: self)
                    startLoadingAnimation()
                }
            
            default: break
            }
        }
    }
    
    deinit{
        sc_superView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    // MARK: - Public method
    func endRefresh() {
        stopAnimation()
    }
    
    func update(plistName: String, lineWidth: CGFloat, lineColor: UIColor, horizontalRandom: CGFloat, dropHeight: CGFloat, scale: CGFloat, reverseLoadingAnimation: Bool, internalAnimationFactor: CGFloat) {
        
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
        lineArr.removeAll()
        
        guard let path = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist") else {
            print("\(plistName) + error")
            return
        }
        
        let pointDict = NSDictionary.init(contentsOfFile: path)
        
        guard let startPointStringArr = pointDict?["startPoints"] as? [String], endPointStringArr = pointDict?["endPoints"] as? [String] else {
            print("dictionary key error")
            return
        }
        
        let startPointArr = startPointStringArr.map { (pointString) -> CGPoint in
            let point = CGPointFromString(pointString)
            return CGPointMake(point.x * scale, point.y * scale)
        }
        
        let endPointArr = endPointStringArr.map { (pointString) -> CGPoint in
            let point = CGPointFromString(pointString)
            return CGPointMake(point.x * scale, point.y * scale)
        }
        
        let width = max(startPointArr.sort { $0.0.x > $0.1.x }.first!.x, endPointArr.sort { $0.0.x > $0.1.x }.first!.x)
        let height = max(startPointArr.sort { $0.0.y > $0.1.y }.first!.y, endPointArr.sort { $0.0.y > $0.1.y }.first!.y)
        
        frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        
        let maxCount = max(startPointArr.count, endPointArr.count)
        for index in 0 ..< maxCount {
            
            let startPoint = startPointArr[index]
            let endPoint = endPointArr[index]
            
            let lineItem = SCLineView.init(frame: frame, startPoint: startPoint, endPoint: endPoint, color: lineColor, lineWidth: lineWidth, horizontalRandom: horizontalRandom, dropHeight: dropHeight)
            lineItem.tag = index
            lineItem.backgroundColor = UIColor.clearColor()
            lineItem.alpha = 0
            
            addSubview(lineItem)
            lineArr.append(lineItem)
        }
        
        self.lineWidth = lineWidth
        self.dropHeight = dropHeight
        self.internalAnimationFactor = internalAnimationFactor
        self.reverseLoadingAnimation = reverseLoadingAnimation
        
    }
    
    // MARK: - Private method
    private func updateLineItem(progress: CGFloat) {
        
        for index in 0 ..< lineArr.count {
            let item = lineArr[index]
            let startProgress = CGFloat(index) / CGFloat(lineArr.count) * (1 - internalAnimationFactor)
            let realProgress = min(max(progress - startProgress, 0) , internalAnimationFactor) / internalAnimationFactor
            item.setProgress(realProgress)
            item.alpha = max(realProgress * kNormalAlpha , 0.5)
        }
        
    }
    
    private func startLoadingAnimation() {
        
        let timeInterval = 2.0 / Double(lineArr.count)
        let items = reverseLoadingAnimation ? lineArr.reverse() : lineArr
        for item in items {
            let index = items.indexOf(item)!
            item.tag = index
            performSelector(#selector(SCLineFreshControl.lineItemLoadingAnimation(_:)), withObject: item, afterDelay: Double(index) * timeInterval, inModes: [NSRunLoopCommonModes])
        }
        
    }
    
    private func stopAnimation() {
        print("stop")
        currentStage = .ReFreshEnd
        currentProgress = 1
        timeLink = CADisplayLink.init(target: self, selector: #selector(SCLineFreshControl.lineItemBackAnimation))
        timeLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        
        UIView.animateWithDuration(1, animations: {
            self.sc_superView.contentInset.top = self.defaultContentInsetTop
        }) { (_) in
            self.currentStage = .Draging
            self.timeLink?.invalidate()
            self.currentProgress = 0
        }
    }
    
    @objc private func lineItemLoadingAnimation (lineItem: SCLineView) {
        
        lineItem.alpha = 1
    
        UIView .animateWithDuration(0.5, animations: {
            lineItem.alpha = self.kNormalAlpha
            lineItem.updateLineWidth(2 * self.lineWidth)
    
        }) { (_) in
            lineItem.updateLineWidth(self.lineWidth)
        }
        
        if lineItem.tag == lineArr.count - 1 && currentStage == .Refreshing {
            startLoadingAnimation()
        }
        
    }
    
    @objc private func lineItemBackAnimation() {
        currentProgress = max(0, currentProgress - CGFloat(1.0 / 60))
    }
    
    // MARK: - @objc Action
    
    // MARK: - lazy Loading
}

func relative(point: CGPoint, x: CGFloat, y: CGFloat) -> CGPoint{
    return CGPoint.init(x: point.x + x, y: point.y + y)
}

