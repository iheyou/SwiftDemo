//
//  HYRootViewController.swift
//  UITableViewTest
//
//  Created by hy on 2016/11/4.
//  Copyright © 2016年 hy.com. All rights reserved.
//

import Foundation
import UIKit

class HYRootViewController: UITabBarController {
    var items = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        //首页
        let vc1 = HYFirstViewController()
        vc1.tabBarItem = UITabBarItem.init(tabBarSystemItem: .featured, tag: 0)
        let nav1 = UINavigationController.init(rootViewController: vc1)
        nav1.title = "首页"
        nav1.navigationBar.backgroundColor = UIColor.darkGray
        //第二页
        let vc2 = HYSecondViewController()
        vc2.tabBarItem = UITabBarItem.init(tabBarSystemItem: .bookmarks, tag: 1)
        let nav2 = UINavigationController.init(rootViewController: vc2)
        nav2.title = "第二页"
        
        items = [nav1,nav2]
        self.viewControllers = items
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
