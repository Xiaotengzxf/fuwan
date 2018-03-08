//
//  AppDelegate.swift
//  someone
//
//  Created by zxf on 2017/4/14.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
import QorumLogs
import UserNotifications
import SVProgressHUD
import RealReachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var _mapManager: BMKMapManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       setupPrintLog() //: 配置打印
       setupRootViewController() //: 配置控制器
       setupGlobalStyle() //: 配置主题样式
       setupGlobalNotice() //: 配置系统通知
       setupShareSDK() //: 配置ShareSDK
        setLocation() // 定位
        
        registerAPNS(application: application)
        BPush.registerChannel(launchOptions, apiKey: "uVkPUTLjGXy2SoL9tQlXA3Pu", pushMode: .development, withFirstAction: "打开", withSecondAction: "关闭", withCategory: "富玩", useBehaviorTextInput: true, isDebug: true)
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            BPush.handleNotification(userInfo as! [AnyHashable : Any])
        }
        
        let appKey = NTESDemoConfig.shared().appKey
        let cerName = NTESDemoConfig.shared().cerName
        NIMSDK.shared().register(withAppID: appKey ?? "", cerName: cerName ?? "")
        NIMCustomObject.registerCustomDecoder(NTESAttachDecoder())
        NTESAuthorizationHelper.requestAblumAuthority { (error) in
            
        }
        NTESAuthorizationHelper.requestMediaCapturerAccess { (error) in
            
        }
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMaximumDismissTimeInterval(1)
        RealReachability.sharedInstance().autoCheckInterval = 1
        RealReachability.sharedInstance().startNotifier()
        NTESSandboxHelper.clearRecordVideoPath()
        
        _ = HKCheckVersionManager(appId: "1299001104")
        
        return true
    }
    
    func setLocation() {
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("q9j8lXngGgTFy1lzybschXSuG1r9jxn8", generalDelegate: nil)
        if ret == false {
            NSLog("manager start failed!")
        }
    }

    // register anple push notification sevice
    func registerAPNS(application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
    }

}

//MARK: 程序更新
extension AppDelegate {
    //: 使用打印工具
    fileprivate func setupPrintLog() {
        //: 使用调试打印工具
        QorumLogs.enabled = true
        QorumLogs.minimumLogLevelShown = 1
    }
    //: 配置主界面流程
    fileprivate func setupRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.backgroundColor = SystemGlobalBackgroundColor
        
        window?.rootViewController = defaultRootViewController()
        
        window?.makeKeyAndVisible()
    }
    
    //: 设置主题样式
    fileprivate func setupGlobalStyle() {
        UITabBar.appearance().tintColor = SystemNavgationBarTintColor
        UITabBar.appearance().isTranslucent = false
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: SystemNavgationBarTintColor], for: .selected)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: SystemTabBarTintColor], for: .normal)
        UINavigationBar.appearance().tintColor = UIColor.white
        
        ProgressHUD.setupProgressHUD()
  
    }
    //: 注册系统通知
    fileprivate func setupGlobalNotice() {
        //: 注册系统通知
        NotificationCenter.default.addObserver(self, selector: #selector(changeDefaultRootViewController(notification:)), name: NSNotification.Name(rawValue: SystemChangeRootViewControllerNotification), object: nil)

    }
    
    //: 配置ShareSDK
    fileprivate func setupShareSDK() {
        WXApi.registerApp("wxf9b24d55bdb6901d")
            ShareSDK.registerApp(SHARESDK_APP_KEY, activePlatforms: [
                SSDKPlatformType.typeSinaWeibo.rawValue,
                SSDKPlatformType.typeQQ.rawValue,
                SSDKPlatformType.typeWechat.rawValue], onImport: { (platform : SSDKPlatformType) in
                    switch platform {
                    case SSDKPlatformType.typeWechat:
                        ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                    case SSDKPlatformType.typeQQ:
                        ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                    case SSDKPlatformType.typeSinaWeibo:
                        ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                    default:
                        break
                    }
              //: 
            }){ (platform : SSDKPlatformType, appInfo : NSMutableDictionary?) in
                
                switch platform {
                case SSDKPlatformType.typeWechat:
                    //: 微信
                    appInfo?.ssdkSetupWeChat(byAppId: WX_APP_ID, appSecret: WX_APP_SECRET)
                    
                case SSDKPlatformType.typeQQ:
                    //: QQ
                    appInfo?.ssdkSetupQQ(byAppId: QQ_APP_ID,
                                         appKey : QQ_APP_KEY,
                                         authType : SSDKAuthTypeBoth)
                    //: Sina微博
                case SSDKPlatformType.typeSinaWeibo:
                    appInfo?.ssdkSetupSinaWeibo(byAppKey: WB_APP_KEY,
                                                appSecret: WB_APP_SECRET,
                                                redirectUri: WB_REDIRECT_URL,
                                                authType: SSDKAuthTypeBoth)
                default:
                    break
                }
                
            }
    }
    
    func defaultRootViewController() -> UIViewController {
        
        return MainViewController()

    }
    
    func changeDefaultRootViewController(notification:Notification) {
        
        QL2(notification.userInfo?[ToControllerKey])
        
        
        guard let controllerName = notification.userInfo?[ToControllerKey] as? String else {
            QL4("跳转根控制器失败，传入的控制器名称为空")
            return
        }
        
        guard let controller = UIViewController.controller(withName: controllerName) else {
            QL4("创建控制器失败")
            return
        }
        
        window?.rootViewController = controller
    }
    
}

extension AppDelegate {
    func applicationDidBecomeActive(_ application: UIApplication) {
     
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (result) in
                
            })
        }
        if url.host == "platformapi" {
            AlipaySDK.defaultService().processAuthResult(url, standbyCallback: { (result) in
                
            })
        }
        if let url = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, url == "com.tencent.xin" {
            WXApi.handleOpen(URL(string: url), delegate: self)
        }
        return true
    }
}

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
}

extension AppDelegate: WXApiDelegate {
    
    func onReq(_ req: BaseReq!) {
        
    }
    
    func onResp(_ resp: BaseResp!) {
        if let response = resp as? PayResp {
            //支付返回结果，实际支付结果需要去微信服务器端查询
            var strMsg = ""
            switch (resp.errCode) {
            case 0:
                strMsg = "支付结果：成功！"
                break
            default:
                strMsg = "支付结果：失败！retcode = \(resp.errCode), retstr = \(resp.errStr)"
                break;
            }
            let alert = UIAlertView(title: "支付结果", message: strMsg, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
}
