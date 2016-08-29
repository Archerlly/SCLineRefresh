//
//  ViewController.swift
//  SCLineRefresh
//
//  Created by SnowCheng on 16/8/15.
//  Copyright © 2016年 SnowCheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView()
        
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let string: String
        
        switch indexPath.row {
        case 0:
            string = "文字"
        case 1:
            string = "图案"
        case 2:
            string = "自绘"
        default:
            string = ""
        }
        
        cell.textLabel?.text = "\(indexPath.row + 1) \(string)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let string: String
        
        switch indexPath.row {
        case 0:
            string = "setupSnowRefresh"
        case 1:
            string = "setupStarRefresh"
        case 2:
            string = "setupCustomRefresh"
        default:
            string = ""
        }
        
        let refreshVC = LineRefreshViewController()
        refreshVC.typeString = string
        navigationController?.pushViewController(refreshVC, animated: true)
    }
    
}

