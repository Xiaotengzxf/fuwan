//
//  loginViewController.swift
//  someone
//
//  Created by zxf on 2017/4/25.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
import SnapKit
import LSXPropertyTool
import QorumLogs
import Toaster

class loginViewController: UIViewController {

//MARK: 懒加载
    lazy var mainView:LoginView = LoginView()
//MARK: 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "用户登录"
        self.view.backgroundColor = UIColor.white
        setupLoginView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupLoginViewSubView()
        
    }
//MARK: 私有方法
    private func setupLoginView() {
        mainView.delegate = self
        view.addSubview(mainView)
    }
    
    private func setupLoginViewSubView() {
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
    }
}

//MARK: 代理方法
extension loginViewController:LoginViewDelegate {
    func loginViewCloseButtonClick() {
        dismiss(animated: true, completion: nil)
    }
    
    func loginViewUsingPasswordButtonClick() {
        
    }
    
    func loginViewTurnToRegisterViewButtonClick() {
        present(RegisterViewController(), animated: true, completion: nil)
    }
    
    func loginViewLoginButtonClick(withPhone phone: String?, withPassword passwd: String?) { //15137152986
        guard let mobile = phone else {
            Toast(text: "手机号码不能为空").show()
            return
        }
        if !mobile.validataPhone() {
            Toast(text: "手机号码输入有误").show()
            return
        }
        guard let pwd = passwd else {
            Toast(text: "密码不能为空").show()
            return
        }
        var parameters : [String : Any] = ["ajax" : "1", "device_type" : "iOS"]
        parameters["username"] = mobile
        parameters["password"] = pwd
        parameters["imei"] = ""
        
        NetworkTools.shared.post(LOGIN_URL, parameters: parameters) { (isSuccess, result, error) in
            if isSuccess {
                if let state = result?["state"].string, state == "success" {
                    
                    let account = ExchangeToModel.model(withClassName: "AccountModel", withDictionary: result!.dictionaryObject!) as! AccountModel
                    account.saveAccountInfo()
                    
                    NotificationCenter.default.post(name: Notification.Name("Me"), object: 1)
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                
            }
        }
    }
                                   
    func loginViewSocietyLoginButtonClick(withType type: SocietyType) {
        
        switch type {
        //: QQ 登陆
        case SocietyType.qq:
            ShareSDK.getUserInfo(SSDKPlatformType.typeQQ, conditional: nil, onStateChanged: { (state, user, error) in
                if state == SSDKResponseState.success {
                    QL2("腾讯QQ授权登陆成功")
                    self.SDKLoginHandle(state, user: user!, type: "qq")
                }
            })
        //: 新浪微博 登陆
        case SocietyType.sina:
            ShareSDK.getUserInfo(SSDKPlatformType.typeSinaWeibo, conditional: nil, onStateChanged: { (state, user, error) in
                if state == SSDKResponseState.success {
                    QL2("新浪微博授权登陆成功")
                    self.SDKLoginHandle(state, user: user!, type: "sina")
                }
            })
        case SocietyType.wechat:
            ShareSDK.getUserInfo(SSDKPlatformType.typeWechat, conditional: nil, onStateChanged: { (state, user, error) in
                if state == SSDKResponseState.success {
                    QL2("微信授权登陆成功")
                    self.SDKLoginHandle(state, user: user!, type: "wechat")
                }
            })

        }
        
    }
    
    func SDKLoginHandle(_ state:SSDKResponseState,user:SSDKUser,type:String) {
        //: 用户ID
        let uid = user.uid ?? ""
        //: token
        let token = user.credential.token ?? ""
        //: 用户昵称
        let nickname = user.nickname ?? ""
        let say = user.aboutMe ?? ""
        
        let avatar = type == "weibo" ? (user.rawData["avatar_hd"] != nil ? user.rawData["avatar_hd"] as? String : user.icon) : (user.rawData["figureurl_qq_2"] != nil ? user.rawData["figureurl_qq_2"] as? String : user.icon)
        let sex = user.gender.rawValue == 0 ? 1 : 0
        
        ProgressHUD.show(withStatus: "正在登陆")
       
        AccountModel.thirdAccountLogin(type, openid: uid, token: token, nickname: nickname
                                 , avatar: avatar ?? "", sex: sex, finished:{ (success, msg) -> Void in
//: 采用的是别人的服务器，所以不做第三方真实登陆，自己的服务器真实登陆如下：
//                if success {
//                    ProgressHUD.dismiss()
//                    
//                }
//                else {
//                    ProgressHUD.showInfo(withStatus: msg)
//                }
                
                ProgressHUD.showInfo(withStatus: "登陆成功")
                  
                let parameters: [String : Any] = [
                    "uid" : uid,
                    "say" : say,
                    "nickname" : nickname,
                    "avatar" : avatar ?? "",
                    "sex" : sex
                ]
                  
                  let account = ExchangeToModel.model(withClassName: "AccountModel", withDictionary: parameters) as! AccountModel
                 
                  account.saveAccountInfo()
                                    
                  self.loginViewCloseButtonClick()
        })
        
    }
    
  
}
