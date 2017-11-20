//
//  MainViewController.swift
//  someone
//
//  Created by zxf on 2017/4/15.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {
    
    var vcMerchant : MerchantViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        //: 添加子控制器
        addChildViewController()
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotification(notification:)), name: Notification.Name("tabbar"), object: nil)
        
    }

    private func addChildViewController(){
        
        //_ = addChildViewController(controller: mainClassifyViewController(), title: "主页", imageName: "tabbar_home")
        _ = addChildViewController(controller: HomeViewController(), title: "主页", imageName: "tabbar_home")
        _ = addChildViewController(controller: HotViewController(), title: "服务", imageName: "tabbar_gift")
        _ = addChildVC(controller: UIViewController(), title: "", imageName: "tabbar_add")
        //_ = addChildViewController(controller: ClassifyViewController(), title: "直播", imageName: "tabbar_category")
        _ = addChildViewController(controller: FoundViewController(), title: "发现", imageName: "tabbar_found")
        _ = addChildViewController(controller: MeViewController(), title: "我的", imageName: "tabbar_me")
        
        if AccountModel.isLogin() {
            if vcMerchant == nil {
                vcMerchant = MerchantViewController()
                _ = self.addChildViewController(controller: vcMerchant!, title: "商家", imageName: "tab_shop")
            }
        }
    }
    
    private func addChildViewController(controller: UIViewController, title: String, imageName: String) -> UINavigationController {
        if title == "" {
            controller.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
            controller.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        }
        controller.tabBarItem.image = UIImage(named: imageName)
        controller.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")
        controller.title = title
        let nav = NavigationController()
        nav.addChildViewController(controller)
        addChildViewController(nav)
        
        return nav
    }
    
    private func addChildVC(controller: UIViewController, title: String, imageName: String) -> UIViewController {
        controller.tabBarItem.image = UIImage(named: imageName)
        controller.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")
        controller.title = title
        controller.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        controller.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        addChildViewController(controller)
        
        return controller
    }
    
    func addMerchant() {
        if vcMerchant == nil {
            vcMerchant = MerchantViewController()
            
            vcMerchant?.tabBarItem.image = UIImage(named: "tab_shop")
            vcMerchant?.tabBarItem.selectedImage = UIImage(named: "tab_shop" + "_selected")
            vcMerchant?.title = "商家"
            
            let nav = NavigationController()
            nav.addChildViewController(vcMerchant!)
            
            if var viewControllers = self.viewControllers {
                if !viewControllers.contains(nav) {
                    viewControllers.append(nav)
                    self.viewControllers = viewControllers
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleNotification(notification: Notification) {
        if let tag = notification.object as? Int {
            if tag == 1 {
                addMerchant()
            }else if tag == 2 {
                vcMerchant?.navigationController?.removeFromParentViewController()
                vcMerchant = nil
            }
        }
    }
    
    // MARK: UITabbarDelegate

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let _ = viewController as? UINavigationController {
            return true
        }else{
            let moreVC = MoreViewController()
            moreVC.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            moreVC.modalTransitionStyle = .crossDissolve
            moreVC.modalPresentationStyle = .overFullScreen
            self.present(moreVC, animated: false, completion: {
                
            })
            return false
        }
    }
}
