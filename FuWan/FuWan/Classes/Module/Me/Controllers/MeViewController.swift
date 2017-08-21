//
//  MeViewController.swift
//  someone
//
//  Created by zxf on 2017/4/15.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
import WebKit

class MeViewController: WebViewController {

    
//MARK: 系统方法
    override func viewDidLoad() {
        strUrl = UCENTER_URL
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotification(notification:)), name: Notification.Name("Me"), object: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    // MARK: - Notification 15137152986
    func handleNotification(notification : Notification) {
        if let tag = notification.object as? Int {
            if tag == 1 {
                loadUserInfo()
            }
        }
    }
    
    // 加载用户的信息
    func loadUserInfo() {
        if let token = AccountModel.shareAccount()?.token() {
            self.mWebView.evaluateJavaScript("load_data('\(token)')", completionHandler: { (result, error) in
                
            })
        }
    }
    
    // 页面加载完成之后调用
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        /// 获取网页title
        super.webView(webView, didCommit: navigation)
        loadUserInfo()
        
    }
 
    
}
