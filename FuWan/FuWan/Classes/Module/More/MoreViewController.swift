//
//  MoreViewController.swift
//  Fuwan
//
//  Created by ANKER on 2017/11/11.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let removeButton = UIButton()
        removeButton.frame = CGRect(x: ScreenWidth / 2 - 22, y: ScreenHeight - 48, width: 44, height: 44)
        removeButton.setBackgroundImage(UIImage(named: "tabbar_remove"), for: .normal)
        removeButton.addTarget(self, action: #selector(self.dismissForBack), for: .touchUpInside)
        self.view.addSubview(removeButton)
        
        expandFunctionView(frame: CGRect(x: 0, y: ScreenHeight - 180, width: ScreenWidth / 4, height: 70), color: UIColor(red: 238/255.0, green: 112/255.0, blue: 99/255.0, alpha: 1), imageName: "record_light", title: "直播")
        expandFunctionView(frame: CGRect(x: ScreenWidth / 4, y: ScreenHeight - 180, width: ScreenWidth / 4, height: 70), color: UIColor(red: 97/255.0, green: 190/255.0, blue: 38/255.0, alpha: 1), imageName: "juan", title: "圈子")
        expandFunctionView(frame: CGRect(x: ScreenWidth / 2, y: ScreenHeight - 180, width: ScreenWidth / 4, height: 70), color: UIColor(red: 71/255.0, green: 168/255.0, blue: 81/255.0, alpha: 1), imageName: "flashlight", title: "头条")
        expandFunctionView(frame: CGRect(x: ScreenWidth * 3 / 4, y: ScreenHeight - 180, width: ScreenWidth / 4, height: 70), color: UIColor(red: 95/255.0, green: 179/255.0, blue: 213/255.0, alpha: 1), imageName: "shop_light", title: "商家")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func expandFunctionView(frame : CGRect, color: UIColor, imageName: String, title : String) {
        let subView = UIView(frame: frame)
        let button = UIButton()
        button.backgroundColor = color
        button.setImage(UIImage(named: imageName), for: .normal)
        button.layer.cornerRadius = 25
        button.frame = CGRect(x: frame.size.width / 2 - 25, y: 0, width: 50, height: 50)
        button.tag = Int(frame.origin.x / (ScreenWidth / 4))
        button.addTarget(self, action: #selector(self.tapFunctionView(sender:)), for: .touchUpInside)
        subView.addSubview(button)
        let label = UILabel()
        label.text = title
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 13)
        label.frame = CGRect(x: 0, y: 50, width: frame.size.width, height: 20)
        label.textAlignment = .center
        subView.addSubview(label)
        
        self.view.addSubview(subView)
    }
    
    func tapFunctionView(sender: Any) {
        if let button = sender as? UIButton {
            switch button.tag {
            case 0:
                if let token = UserDefaults.standard.string(forKey: "token"), token.characters.count > 0 {
                    let moreDetailVC = MoreDetailViewController()
                    moreDetailVC.strUrl = LIVE_URL
                    moreDetailVC.title = "直播"
                    let nav = UINavigationController(rootViewController: moreDetailVC)
                    nav.modalTransitionStyle = .flipHorizontal
                    self.present(nav, animated: true, completion: {
                        
                    })
                }else{
                    self.view.makeToast("请先登录")
                }
                
            case 1:
                let moreDetailVC = MoreDetailViewController()
                moreDetailVC.strUrl = SENDMSG_URL
                moreDetailVC.title = "圈子"
                let nav = UINavigationController(rootViewController: moreDetailVC)
                nav.modalTransitionStyle = .flipHorizontal
                self.present(nav, animated: true, completion: {
                    
                })
            case 2:
                let moreDetailVC = MoreDetailViewController()
                moreDetailVC.strUrl = PUBLISH_URL
                moreDetailVC.title = "头条"
                let nav = UINavigationController(rootViewController: moreDetailVC)
                nav.modalTransitionStyle = .flipHorizontal
                self.present(nav, animated: true, completion: {
                    
                })
            case 3:
                let moreDetailVC = MoreDetailViewController()
                moreDetailVC.strUrl = MCENTER_URL
                moreDetailVC.title = "商家"
                let nav = UINavigationController(rootViewController: moreDetailVC)
                nav.modalTransitionStyle = .flipHorizontal
                self.present(nav, animated: true, completion: {
                    
                })
            default:
                fatalError()
            }
        }
    }
    
    func dismissForBack() {
        self.dismiss(animated: false) {
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
