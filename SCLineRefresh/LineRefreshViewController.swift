//
//  LineRefreshViewController.swift
//  SCLineRefresh
//
//  Created by SnowCheng on 16/8/21.
//  Copyright © 2016年 SnowCheng. All rights reserved.
//

import UIKit

class LineRefreshViewController: UIViewController, UITableViewDataSource {

    let tableView = UITableView()
    let customLine = CustomLineView()
    var refresh: SCLineFreshControl!
    let completeButton = UIButton()
    var typeString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.init(white: 0.8, alpha: 1)
        
        tableView.frame = view.bounds
        tableView.frame.origin.y = 300
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.lightGrayColor()
        
        refresh = SCLineFreshControl.init(plistName: "demo", lineWidth: 1, lineColor: UIColor.redColor(), horizontalRandom: 100, dropHeight: 100, scale: 0.5, reverseLoadingAnimation: false, internalAnimationFactor: 0.7)
        
        refresh.refreshHandle = { (sender) in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(UInt64(4 * 1000) * USEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                sender.endRefresh()
            })
            
        }
        
        view.addSubview(tableView)
        tableView.addSubview(refresh)
        
        let sel = Selector.init(typeString)
        if respondsToSelector(sel) {
            performSelector(sel)
        }
        
    }
    
    func setupSnowRefresh() {
        
        let line = drawLineView()
        line.bounds = CGRect.init(x: 0, y: 0, width: 100, height: 60)
        line.center = CGPointMake(view.center.x, 150)
        line.drawLine()
        view.addSubview(line)
        
        refresh.update("snow", lineWidth: 1, lineColor: UIColor.greenColor(), horizontalRandom: 200, dropHeight: 80, scale: 1, reverseLoadingAnimation: false, internalAnimationFactor: 0.7)
    }
    
    func setupStarRefresh() {
        
        let line = drawLineView()
        line.bounds = CGRect.init(x: 0, y: 0, width: 100, height: 60)
        line.center = CGPointMake(view.center.x, 150)
        line.drawStar()
        view.addSubview(line)
        
        refresh.update("star", lineWidth: 1, lineColor: UIColor.greenColor(), horizontalRandom: 200, dropHeight: 80, scale: 0.8, reverseLoadingAnimation: true, internalAnimationFactor: 1)
    }
    
    func setupCustomRefresh() {
        
        customLine.bounds = CGRect.init(x: 0, y: 0, width: 300, height: 150)
        customLine.center = CGPointMake(view.center.x, 150)
        customLine.backgroundColor = UIColor.lightGrayColor()
        customLine.beginDrawHandel = { [unowned self] in
            self.completeButton.setTitle("确定", forState: .Normal)
        }
        
        completeButton.setTitle("确定", forState: .Normal)
        completeButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
        completeButton.addTarget(self, action: #selector(LineRefreshViewController.btnAction), forControlEvents: .TouchUpInside)
        completeButton.sizeToFit()
        completeButton.center = CGPointMake(view.center.x, CGRectGetMaxY(customLine.frame) + 20)
       
        view.addSubview(customLine)
        view.addSubview(completeButton)
        
    }
    
    @objc private func btnAction() {
        let success = customLine.completeDraw()
        
        completeButton.setTitle(success ? "成功" : "失败", forState: .Normal)
        
        refresh.update("demo", lineWidth: 1, lineColor: UIColor.blackColor(), horizontalRandom: 200, dropHeight: 80, scale: 0.5, reverseLoadingAnimation: false, internalAnimationFactor: 0.7)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }

}
