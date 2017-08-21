//
//  AccountModel.swift
//  someone
//
//  Created by zxf on 2017/4/25.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
import LSXPropertyTool
import QorumLogs

class AccountModel: NSObject,NSCoding {
    
    var info: String?
    var message: String?
    var referer: String?
    var state: String?
    var status = 0
    var url: String?
    
    //: 账户单例
    static func shareAccount() -> AccountModel? {
        if userAccount == nil {
            userAccount = NSKeyedUnarchiver.unarchiveObject(withFile: AccountModel.filePath) as? AccountModel
            
            return userAccount
        }
        else {
            return userAccount
        }
    }
    
    //: 构造方法
    override init() {
        super.init()
    }
    
    
    //: 判断用户是否登陆
    class func isLogin() -> Bool {
        return AccountModel.shareAccount() != nil
    }
    
    //: 注销登录
    class func logout() {
        
        //: 取消第三方登录授权
        ShareSDK.cancelAuthorize(SSDKPlatformType.typeQQ)
        ShareSDK.cancelAuthorize(SSDKPlatformType.typeSinaWeibo)
        ShareSDK.cancelAuthorize(SSDKPlatformType.typeWechat)
        
        // 清除内存中的账户数据和归档中的数据
        AccountModel.userAccount = nil
        do {
            try FileManager.default.removeItem(atPath: AccountModel.filePath)
        } catch {
            QL4("退出异常")
        }
    }
    
    func saveAccountInfo() {
        AccountModel.userAccount = self
        
        saveAccount()
    }
    
    fileprivate func saveAccount() {
        //: 归档
        NSKeyedArchiver.archiveRootObject(self, toFile: AccountModel.filePath)
    }
    
    // 持久保存到内存中
    fileprivate static var userAccount: AccountModel?
    
    //: 归档账号的路径
    static let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! + "/Account.plist"

    //: 实现归解档的NSCoding代理方法
    func encode(with aCoder: NSCoder){
        aCoder.encode(info, forKey: "info")
        aCoder.encode(message, forKey: "message")
        aCoder.encode(referer, forKey: "referer")
        aCoder.encode(state, forKey: "state")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(url, forKey: "url")
    }
    
    required  init?(coder aDecoder: NSCoder) {
       info = aDecoder.decodeObject(forKey: "info") as? String
       message = aDecoder.decodeObject(forKey: "message") as? String
       referer = aDecoder.decodeObject(forKey: "referer") as? String
       state = aDecoder.decodeObject(forKey: "state")  as? String
       status = aDecoder.decodeInteger(forKey: "status") as Int
       url = aDecoder.decodeObject(forKey: "url") as? String
    }
    
    func token() -> String? {
        var token : String?
        if let info = AccountModel.shareAccount()?.info {
            let array = info.components(separatedBy: "&")
            for item in array {
                if item.hasPrefix("token=") {
                    token = item.substring(from: item.index(item.startIndex, offsetBy: 6))
                }
            }
        }
        return token
    }
    
}

//MARK: 登陆相关
extension AccountModel {

    class func thirdAccountLogin(_ type: String, openid: String, token: String
        , nickname: String, avatar: String, sex: Int
        , finished: @escaping (_ success: Bool, _ tip: String) -> ()) {
        
        let parameters: [String : AnyObject] = [
            "type" : type as AnyObject,
            "identifier" : openid as AnyObject,
            "token" : token as AnyObject,
            "nickname" : nickname as AnyObject,
            "avatar" : avatar as AnyObject,
            "sex" : sex as AnyObject
        ]
        
    
        
        NetworkTools.shared.get(LOGIN_URL, parameters: parameters) { (isSucess, result, error) in
            
            guard let result = result else {
                finished(false, "您的网络不给力哦")
                return
            }
            
            if result["state"] == "success" {
        
                let account = ExchangeToModel.model(withClassName: "AccountModel", withDictionary: result.dictionaryObject!) as! AccountModel
                account.saveAccountInfo()
                
                finished(true,"登陆成功")
            }
            else {
                finished(false,result["message"].stringValue)
            }
        }
        
    }

}
