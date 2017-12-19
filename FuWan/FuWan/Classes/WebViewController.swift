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
import DZNEmptyDataSet
import SwiftyJSON
import SVProgressHUD

class WebViewController: UIViewController, WKScriptMessageHandler, BMKLocationServiceDelegate {
    
    var mWebView: WKWebView!
    var indicatorView: UIActivityIndicatorView!
    var strUrl : String?
    var bSingle = false
    var _locService : BMKLocationService!
    var emptyDataSetShown = false
    
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
                    if let token = UserDefaults.standard.string(forKey: "token"), token.characters.count > 0 {
                        let array = self!.strUrl?.components(separatedBy: "#")
                        if (array?.count ?? 0) > 1 {
                            let suffix = "#\(array![1])"
                            if array![0].contains("?") {
                                self!.strUrl = "\(array![0])&token=\(token)\(suffix)"
                            }else{
                                self!.strUrl = "\(array![0])?token=\(token)\(suffix)"
                            }
                        }
                    }
                    let url = URL(string: self!.strUrl!)
                    let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
                    self!.mWebView.load(request)
                }
            }
        }
        
        mWebView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        
        
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicatorView)
        
        self.view.addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: mWebView, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: mWebView, attribute: .centerY, multiplier: 1, constant: 0))
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backItemImage"), style: .plain, target: self, action: #selector(self.tapBack))
        
        
        mWebView.scrollView.emptyDataSetDelegate = self
        mWebView.scrollView.emptyDataSetSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = UserDefaults.standard.string(forKey: "token"), token.characters.count > 0 {
            mWebView.evaluateJavaScript("reload_data('\(token)');") { (result, error) in
                
            }
        }else{
            mWebView.evaluateJavaScript("reload_data('');") { (result, error) in
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        mWebView.removeObserver(self, forKeyPath: "title")
    }
    
    func tapBack() {
        if mWebView.canGoBack {
            mWebView.goBack()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            title = mWebView.title
        }else  {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
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
            if let body = message.body as? [String : Any] {
                if let function = body["function"] as? String {
                    if function == "login" {
                        if let token = UserDefaults.standard.string(forKey: "token"), token.characters.count > 0 {
                            
                        }else{
                            if let _ = self.navigationController?.visibleViewController as? loginViewController {
                                
                            }else{
                                let controller = loginViewController()
                                controller.hidesBottomBarWhenPushed = true
                                self.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                    }else if function == "logOut" {
                        AccountModel.logout()
                        mWebView.evaluateJavaScript("removeUserInfo();", completionHandler: { (result, error) in
                            
                        })
                        //self.navigationController?.popViewController(animated: true)
                    }else if function == "closeWindow" {
                        self.navigationController?.popViewController(animated: true)
                    }else if function == "openWindow" {
                        if let strUrl = body["parameters"] as? String, strUrl.hasPrefix("http") {
                            print("跳转的url:\(strUrl)")
                            let webView = WebViewController(url: strUrl)
                            self.navigationController?.pushViewController(webView, animated: true)
                        }
                    }else if function == "copy" {
                        if let strContent = body["parameters"] as? String {
                            let paste = UIPasteboard.general
                            paste.string = strContent
                        }
                    }else if function == "Alert" {
                        if let strContent = body["parameters"] as? String {
                            self.showAlertView(message: strContent)
                        }
                    }else if function == "Toast" {
                        if let strContent = body["parameters"] as? String {
                            Toast(text: strContent).show()
                        }
                    }else if function == "forAreaResult" {
                        if let strContent = body["parameters"] as? String {
                            NotificationCenter.default.post(name: Notification.Name("mainClassifyViewController"), object: strContent)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else if function == "openWindowSetting" {
                        if let strUrl = body["parameters"] as? String, strUrl.hasPrefix("http") {
                            print("跳转的url:\(strUrl)")
                            let webView = WebViewController(url: strUrl)
                            self.navigationController?.pushViewController(webView, animated: true)
                        }
                    }else if function == "getVersion" {
                        mWebView.evaluateJavaScript("showVersion(\"{versionCode:\"\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "")\",versionName:\"富玩\"}\");", completionHandler: { (result, error) in
                            
                        })
                    }else if function == "update" {
                        Toast(text: "当前版本已是最新版").show()
                    }else if function == "setPageSetting" {
                        
                    }else if function == "shareWxTimeline" {
                        // title img url desc
                        if let dicContent = body["parameters"] as? [String: String] {
                            let shareParames = NSMutableDictionary()
                            shareParames.ssdkSetupShareParams(byText: dicContent["desc"]!,
                                                              images : UIImage(named: "logo1"),
                                                              url : URL(string: dicContent["url"]!),
                                                              title : dicContent["title"]!,
                                                              type : SSDKContentType.webPage)
                            ShareSDK.share(.subTypeWechatTimeline, parameters: shareParames, onStateChanged: { (state, value, entity, error) in
                                switch state{
                                    
                                case SSDKResponseState.success:
                                    Toast(text: "分享成功").show()
                                case SSDKResponseState.fail:
                                    Toast(text: "分享失败").show()
                                case SSDKResponseState.cancel:
                                    Toast(text: "取消了分享").show()
                                default:
                                    break
                                }
                            })
                        }
                    }else if function == "shareWxFriend" {
                        if let dicContent = body["parameters"] as? [String: String] {
                            let shareParames = NSMutableDictionary()
                            shareParames.ssdkSetupShareParams(byText: dicContent["desc"]!,
                                                              images : UIImage(named: "logo1"),
                            url : URL(string: dicContent["url"]!),
                            title : dicContent["title"]!,
                            type : SSDKContentType.webPage)
                            ShareSDK.share(.subTypeWechatSession, parameters: shareParames, onStateChanged: { (state, value, entity, error) in
                                switch state{
                                    
                                case SSDKResponseState.success:
                                    Toast(text: "分享成功").show()
                                case SSDKResponseState.fail:
                                    Toast(text: "分享失败").show()
                                case SSDKResponseState.cancel:
                                    Toast(text: "取消了分享").show()
                                default:
                                    break
                                }
                            })
                        }
                    }else if function == "shareSinaWb" {
                        if let dicContent = body["parameters"] as? [String: String] {
                            let shareParames = NSMutableDictionary()
                            shareParames.ssdkSetupShareParams(byText: dicContent["desc"]!,
                                                              images : UIImage(named: "logo1"),
                                                              url : URL(string: dicContent["url"]!),
                                                              title : dicContent["title"]!,
                                                              type : SSDKContentType.auto)
                            ShareSDK.share(.typeSinaWeibo, parameters: shareParames, onStateChanged: { (state, value, entity, error) in
                                switch state{
                                    
                                case SSDKResponseState.success:
                                    Toast(text: "分享成功").show()
                                case SSDKResponseState.fail:
                                    Toast(text: "分享失败").show()
                                case SSDKResponseState.cancel:
                                    Toast(text: "取消了分享").show()
                                default:
                                    break
                                }
                            })
                        }
                    }else if function == "shareQq" {
                        if let dicContent = body["parameters"] as? [String: String] {
                            let shareParames = NSMutableDictionary()
                            shareParames.ssdkSetupShareParams(byText: dicContent["desc"]!,
                                                              images : UIImage(named: "logo1"),
                                                              url : URL(string: dicContent["url"]!),
                                                              title : dicContent["title"]!,
                                                              type : SSDKContentType.auto)
                            ShareSDK.share(.subTypeQQFriend, parameters: shareParames, onStateChanged: { (state, value, entity, error) in
                                switch state{
                                    
                                case SSDKResponseState.success:
                                    Toast(text: "分享成功").show()
                                case SSDKResponseState.fail:
                                    Toast(text: "分享失败").show()
                                case SSDKResponseState.cancel:
                                    Toast(text: "取消了分享").show()
                                default:
                                    break
                                }
                            })
                        }
                    }else if function == "shareQzone" {
                        if let dicContent = body["parameters"] as? [String: String] {
                            let shareParames = NSMutableDictionary()
                            shareParames.ssdkSetupShareParams(byText: dicContent["desc"]!,
                                                              images : UIImage(named: "logo1"),
                                                              url : URL(string: dicContent["url"]!),
                                                              title : dicContent["title"]!,
                                                              type : SSDKContentType.auto)
                            ShareSDK.share(.subTypeQZone, parameters: shareParames, onStateChanged: { (state, value, entity, error) in
                                switch state{
                                    
                                case SSDKResponseState.success:
                                    Toast(text: "分享成功").show()
                                case SSDKResponseState.fail:
                                    Toast(text: "分享失败").show()
                                case SSDKResponseState.cancel:
                                    Toast(text: "取消了分享").show()
                                default:
                                    break
                                }
                            })
                        }
                    }else if function == "getLocaction" {
                        _locService = BMKLocationService()
                        _locService.delegate = self
                        _locService.startUserLocationService()
                    }else if function == "hideTitleBar" {
                        self.navigationController?.setNavigationBarHidden(true, animated: false)
                    }else if function == "weipay" {
                        if let token = UserDefaults.standard.string(forKey: "token"), token.characters.count > 0 {
                            if let dicContent = body["parameters"] as? [String: String] {
                                if let order_sn = dicContent["order_sn"] {
                                    NetworkTools.shared.get("https://www.fuwan369.com/index.php/user/oapi/weipay？token=\(token)&order_sn=\(order_sn)", parameters: nil) { (isSuccess, result, error) in
                                        if isSuccess {
                                            if result != nil {
                                                let request = PayReq()
                                                request.partnerId = result!["partnerid"].string
                                                request.prepayId = result!["prepayid"].string
                                                request.package = result!["package"].string
                                                request.nonceStr = result!["noncestr"].string
                                                request.timeStamp = UInt32(result!["timestamp"].string ?? "0") ?? 0
                                                request.sign = result!["sign"].string
                                                WXApi.send(request)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }else if function == "bLive" {
                        SVProgressHUD.show(withStatus: "加载中...")
                        NTESChatroomManger.shareInstance().anchorEnterChatroom({[weak self] (error, roomid) in
                            SVProgressHUD.dismiss()
                            if error == nil {
                                let push = NTESLiveStreamVC(chatroomId: roomid!)
                                push?.pushUrl = NTESLiveDataCenter.shareInstance().pushUrl
                                self?.present(push!, animated: true, completion: {
                                    
                                })
                            }else{
                                self?.view.makeToast("进入聊天室失败", duration: 2, position: CSToastPositionCenter)
                            }
                        })
                    }else if function == "bView" {
                         if let content = body["parameters"] as? String {
                            let array = content.components(separatedBy: "=")
                            SVProgressHUD.show(withStatus: "进入聊天室...")
                            NTESChatroomManger.shareInstance().audienceEnterChatroom(withRoomid: array[1], complete: {[weak self] (error, value) in
                                SVProgressHUD.dismiss()
                                if error == nil {
                                    NTESLiveDataCenter.shareInstance().pullUrl = NTESLiveDataCenter.shareInstance().rtmpPullUrl
                                    let pullUrl = NTESLiveDataCenter.shareInstance().pullUrl
                                    let vc = NTESPlayStreamVC(chatroomid: value, pullUrl: pullUrl)
                                    self?.present(vc!, animated: true, completion: {
                                        
                                    })
                                } else {
                                    self?.view.makeToast("进入聊天室失败", duration: 2, position: CSToastPositionCenter)
                                }
                            })
                        }
                    }else if function == "Call" {
                        if let content = body["parameters"] as? String {
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(URL(string: "tel://\(content)")!, options: [:],
                                                          completionHandler: {
                                                            (success) in
                                })
                            } else {
                                UIApplication.shared.openURL(URL(string: "tel://\(content)")!)
                            }
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
    
    
    func didUpdate(_ userLocation: BMKUserLocation!) {
        
        var region: BMKCoordinateRegion = BMKCoordinateRegion()
        region.center.latitude = userLocation.location.coordinate.latitude
        region.center.longitude = userLocation.location.coordinate.longitude
        region.span.latitudeDelta = 0
        region.span.longitudeDelta = 0
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(userLocation.location) {[weak self] (array, error) in
            if array?.count ?? 0 > 0 {
                if let placemark = array?[0] {
                    if let city = placemark.locality {
                        let loc = "{\"city\":\"\(city)\",\"district\":\"\(placemark.subLocality ?? "")\",\"ajax\":\"1\"}"
                        self?.mWebView.evaluateJavaScript("setLocation(\"\(loc)\";)", completionHandler: { (result, error) in
                            
                        })
                        
                        
                    }
                }
                self?._locService.stopUserLocationService()
            }
        }
    }

}

extension WebViewController : WKNavigationDelegate{
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        indicatorView.startAnimating()
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        indicatorView.stopAnimating()
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        /// 获取网页title
        if !bSingle {
            bSingle = true
            if let token = UserDefaults.standard.string(forKey: "token"), token.characters.count > 0 {
                mWebView.evaluateJavaScript("reload_data('\(token)');") { (result, error) in

                }
            }else{
                mWebView.evaluateJavaScript("reload_data('');") { (result, error) in

                }
            }
        }
        indicatorView.stopAnimating()
        emptyDataSetShown = false
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        indicatorView.stopAnimating()
        emptyDataSetShown = true
        mWebView.scrollView.reloadEmptyDataSet()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlString = webView.url?.absoluteString {
            if let orderInfoString = AlipaySDK.defaultService().fetchOrderInfo(fromH5PayUrl: urlString), orderInfoString.characters.count > 0 {
                AlipaySDK.defaultService().payOrder(orderInfoString, fromScheme: "alisdkdemo", callback: { (result) in
                    print("\(result)")
                })
                decisionHandler(.cancel)
                return
            }
        }
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
        indicatorView.stopAnimating()
        emptyDataSetShown = true
        mWebView.scrollView.reloadEmptyDataSet()
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


extension WebViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "logo")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "网络故障，请点击重试！")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        return NSAttributedString(string: "重试")
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return emptyDataSetShown
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        emptyDataSetShown = false
        mWebView.scrollView.reloadEmptyDataSet()
        mWebView.reloadFromOrigin()
    }
}

