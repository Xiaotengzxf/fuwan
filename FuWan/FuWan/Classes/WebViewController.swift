//
//  WebViewController.swift
//  Fuwan
//
//  Created by ANKER on 2017/8/15.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKScriptMessageHandler {
    
    var mWebView: WKWebView!
    var strUrl : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        //获取cookies并放入请求头部
        let userContentController = WKUserContentController()
        if let cookies = HTTPCookieStorage.shared.cookies{
            print(cookies)
            let script = getJSCookiesString(cookies: cookies)
            let cookieScript = WKUserScript(source: script, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
            userContentController.addUserScript(cookieScript)
        }
        userContentController.add(self, name: "jshook")
        let webviewConfig = WKWebViewConfiguration()
        webviewConfig.preferences = WKPreferences()
        webviewConfig.preferences.minimumFontSize = 10
        webviewConfig.preferences.javaScriptEnabled = true
        webviewConfig.preferences.javaScriptCanOpenWindowsAutomatically = false
        webviewConfig.userContentController = userContentController
        mWebView = WKWebView(frame: CGRect.zero, configuration: webviewConfig)
        mWebView.translatesAutoresizingMaskIntoConstraints = false
        mWebView.navigationDelegate = self
        mWebView.uiDelegate = self
        self.view.addSubview(mWebView)
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", options: .directionLeadingToTrailing, metrics: nil, views: ["webView" : mWebView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|", options: .directionLeadingToTrailing, metrics: nil, views: ["webView" : mWebView]))
        
        if strUrl != nil && strUrl!.hasPrefix("http") {
            let url = URL(string: strUrl!)
            let request = URLRequest(url: url!)
            mWebView.load(request)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    public func getJSCookiesString(cookies: [HTTPCookie]) -> String {
        var result = ""
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        for cookie in cookies {
            result += "document.cookie='\(cookie.name)=\(cookie.value); domain=\(cookie.domain); path=\(cookie.path); "
            if let date = cookie.expiresDate {
                result += "expires=\(dateFormatter.string(from: date)); "
            }
            if (cookie.isSecure) {
                result += "secure; "
            }
            result += "'; "
        }
        return result
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "jshook" {
            if let body = message.body as? [String : String] {
                if let function = body["function"] {
                    if function == "login" {
                        let controller = loginViewController()
                        controller.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            }
            
            
        }
    }

}

extension WebViewController : WKNavigationDelegate{
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        /// 获取网页title
        
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        
    }
    
}

