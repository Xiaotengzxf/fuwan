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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       //: 配置打印
       setupPrintLog()
       //: 配置控制器
       setupRootViewController()
       //: 配置主题样式
       setupGlobalStyle()
       //: 配置系统通知
       setupGlobalNotice()
       //: 配置ShareSDK
       setupShareSDK()
        
        registerAPNS(application: application)
        BPush.registerChannel(launchOptions, apiKey: "uVkPUTLjGXy2SoL9tQlXA3Pu", pushMode: .development, withFirstAction: "打开", withSecondAction: "关闭", withCategory: "富玩", useBehaviorTextInput: true, isDebug: true)
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            BPush.handleNotification(userInfo as! [AnyHashable : Any])
        }
        return true
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

//MARK: 登陆业务逻辑
    //: 新特性
    func isNewFeatureVersion() -> Bool {
        
        let newVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
            as! String
        
        
        //: 旧版本到新版本为升序
        guard let sanboxVersion = UserDefaults.standard.object(forKey: "APPVersion") as? String , sanboxVersion.compare(newVersion) != .orderedAscending else {
            //: 跟新版本
            UserDefaults.standard.set(newVersion, forKey: "APPVersion")
            return true
        }
        
        
        return false
    }
    
    func defaultRootViewController() -> UIViewController {
        
        return MainViewController()
        //: 没有登陆跳转到系统主界面
//        guard LSXUserAccountModel.isLogin() else {
//            return MainViewController()
//        }
//
//        //: 判断是否新版本
//        if isNewFeatureVersion() {
//            return LSXNewFeatureViewController()
//        }
//        
//        //: 跳转到欢迎主界面
//        return LSXWelcomeViewController()
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
}

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
}
