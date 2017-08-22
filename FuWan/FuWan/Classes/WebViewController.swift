//
//  WebViewController.swift
//  Fuwan
//
//  Created by ANKER on 2017/8/15.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
import WebKit
import Toaster

class WebViewController: UIViewController, WKScriptMessageHandler {
    
    var mWebView: WKWebView!
    var strUrl : String?
    var bSingle = false
    
    convenience init(url: String) {
        self.init()
        strUrl = url
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //获取cookies并放入请求头部
        let userContentController = WKUserContentController()
//        if let cookies = HTTPCookieStorage.shared.cookies{
//            print(cookies)
//            let script = getJSCookiesString(cookies: cookies)
//            let cookieScript = WKUserScript(source: script, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
//            userContentController.addUserScript(cookieScript)
//        }
        userContentController.add(self, name: "jshook")
        let webviewConfig = WKWebViewConfiguration()
        webviewConfig.preferences = WKPreferences()
        webviewConfig.preferences.minimumFontSize = 10
        webviewConfig.preferences.javaScriptEnabled = true
        webviewConfig.preferences.javaScriptCanOpenWindowsAutomatically = true
        webviewConfig.userContentController = userContentController
        mWebView = WKWebView(frame: CGRect.zero, configuration: webviewConfig)
        mWebView.translatesAutoresizingMaskIntoConstraints = false
        mWebView.navigationDelegate = self
        mWebView.uiDelegate = self
        mWebView.isUserInteractionEnabled = true
        self.view.addSubview(mWebView)
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", options: .directionLeadingToTrailing, metrics: nil, views: ["webView" : mWebView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|", options: .directionLeadingToTrailing, metrics: nil, views: ["webView" : mWebView]))
        
        mWebView.evaluateJavaScript("navigator.userAgent") {[weak self] (result, error) in
            if let useAgent = result as? String {
                self?.mWebView.customUserAgent = "\(useAgent);FuWanBroswer;FWB-IOS"
                
                if self!.strUrl != nil && self!.strUrl!.hasPrefix("http") {
                    let url = URL(string: self!.strUrl!)
                    let request = URLRequest(url: url!)
                    self!.mWebView.load(request)
                }
            }
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
                        if let _ = AccountModel.shareAccount()?.token() {
                            
                        }else{
                            let controller = loginViewController()
                            controller.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }else if function == "logOut" {
                        AccountModel.logout()
                        mWebView.evaluateJavaScript("removeUserInfo();", completionHandler: { (result, error) in
                            
                        })
                        //self.navigationController?.popViewController(animated: true)
                    }else if function == "closeWindow" {
                        self.navigationController?.popViewController(animated: true)
                    }else if function == "openWindow" {
                        if let strUrl = body["parameters"], strUrl.hasPrefix("http") {
                            let url = URL(string: strUrl)
                            let request = URLRequest(url: url!)
                            self.mWebView.load(request)
                        }
                    }else if function == "copy" {
                        if let strContent = body["parameters"] {
                            let paste = UIPasteboard.general
                            paste.string = strContent
                        }
                    }else if function == "Alert" {
                        if let strContent = body["parameters"] {
                            self.showAlertView(message: strContent)
                        }
                    }else if function == "Toast" {
                        if let strContent = body["parameters"] {
                            Toast(text: strContent).show()
                        }
                    }else if function == "forAreaResult" {
                        if let strContent = body["parameters"] {
                            Toast(text: strContent).show()
                        }
                    }
                }
            }
            
            
        }
    }
    
    func showAlertView(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true) { 
            
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
        if !bSingle {
            bSingle = true
            mWebView.evaluateJavaScript("reload_data();") { (result, error) in
                
            }
        }
        
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
}

extension WebViewController: WKUIDelegate {
    
    
    
    func webViewDidClose(_ webView: WKWebView) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 监听通过JS调用警告框
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // 监听通过JS调用提示框
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // 监听JS调用输入框
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        // 类似上面两个方法
    }
    
}

