//
//  MainViewController.swift
//  someone
//
//  Created by zxf on 2017/4/15.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //: 添加子控制器
        addChildViewController()
    }

    private func addChildViewController(){
        
        addChildViewController(controller: mainClassifyViewController(), title: "主页", imageName: "tabbar_home")
        addChildViewController(controller: HotViewController(), title: "服务", imageName: "tabbar_gift")
        addChildViewController(controller: ClassifyViewController(), title: "直播", imageName: "tabbar_category")
        addChildViewController(controller: MeViewController(), title: "我的", imageName: "tabbar_me")
    }
    
    private func addChildViewController(controller: UIViewController, title: String, imageName: String) {
        controller.tabBarItem.image = UIImage(named: imageName)
        controller.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")
        controller.title = title
        
        let nav = NavigationController()
        nav.addChildViewController(controller)
        addChildViewController(nav)
    }

}
