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
    var openid = ""
    var access_token = ""
    var unionid = ""
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        
        NetworkTools.shared.post(LOGIN_URL, parameters: parameters) {[weak self] (isSuccess, result, error) in
            if isSuccess {
                if let state = result?["state"].string, state == "success" {
                    
                    let account = ExchangeToModel.model(withClassName: "AccountModel", withDictionary: result!.dictionaryObject!) as! AccountModel
                    account.saveAccountInfo()
                    
                    NotificationCenter.default.post(name: Notification.Name("Me"), object: 1)
                    self?.navigationController?.popViewController(animated: true)
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
        
        let openid = user.uid ?? ""
        let token = user.credential.token ?? ""
        var parameters : [String : Any] = [:]
        switch type {
        case "qq":
            parameters["qq_openid"] = openid
            parameters["login_from"] = "qq_openid"
        case "sina":
            parameters["weibo_openid"] = openid
            parameters["login_from"] = "weibo_openid"
        default:
            parameters["weixin_openid"] = openid
            parameters["login_from"] = "weixin_openid"
        }
        parameters["imei"] = ""
        parameters["token"] = token
        parameters["device_type"] = "iOS"
        parameters["ajax"] = "1"
        parameters["push_appid"] = BPush.getAppId()
        parameters["push_userid"] = BPush.getUserId()
        parameters["push_channelid"] = BPush.getChannelId()
        parameters["push_code"] = "0"
        
        ProgressHUD.show(withStatus: "正在登陆")
       
        AccountModel.thirdAccountLogin(parameters, finished:{ (success, msg) -> Void in
            
            ProgressHUD.dismiss()
            
            if success {
                ProgressHUD.showInfo(withStatus: "登陆成功")
                
                NotificationCenter.default.post(name: Notification.Name("Me"), object: 1)
                self.navigationController?.popViewController(animated: true)
                
            }else{
                ProgressHUD.showInfo(withStatus: msg)
            }
            
        })
        
    }
    
    // 获取
    func getAccess_token(code : String) {
        let urlPath = "https://api.weixin.qq.com/sns/oauth2/access_token?appid="
            + WX_APP_ID
            + "&secret="
            + WX_APP_SECRET
            + "&code="
            + code
            + "&grant_type=authorization_code"
        NetworkTools.shared.get(urlPath, parameters: nil) { (isSuccess, result, error) in
            if isSuccess {
                
            }
        }
        
    }
    
  
}
