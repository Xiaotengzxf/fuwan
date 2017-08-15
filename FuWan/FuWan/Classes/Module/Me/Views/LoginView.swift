//
//  LoginView.swift
//  小礼品
//
//  Created by zxf on 2017/4/25.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let defaultValue:CGFloat = 60.0
class LoginView: UIView {

    
//MARK: 属性
    weak var delegate:LoginViewDelegate?
    //: 定时器
    private var timer:Timer?
    fileprivate static var second:CGFloat = defaultValue

//MARK: 懒加载
    
    lazy var loginButton:UIButton = { () -> UIButton in
        let button = UIButton(type: .custom)
        button.setTitle("登 录", for: .normal)
        button.titleLabel?.font = fontSize18
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white, for: .disabled)
        button.setBackgroundImage(UIImage.image(withColor: SystemNavgationBarTintColor, withSize: CGSize.zero), for: .normal)
        button.setBackgroundImage(UIImage.image(withColor: SystemTintDisableColor, withSize: CGSize.zero), for: .disabled)
        button.isEnabled = false
        return button
    }()
    
    lazy var registerButton:UIButton = { () -> UIButton in
        let button = UIButton(type: .custom)
        button.setTitle("还没有账户？立即注册", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = fontSize14
        return button
    }()
    
    lazy var forgetPwdButton:UIButton = { () -> UIButton in
        let button = UIButton(type: .custom)
        button.setTitle("忘记密码？", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = fontSize14
        return button
    }()
    
    lazy var phoneText:UITextField = { () -> UITextField in
        let field = UITextField()
        field.font = fontSize16
        field.placeholder = "请输入手机号"
        field.keyboardType = .phonePad
        field.tintColor = SystemNavgationBarTintColor
        
        return field
    }()
    
    lazy var passwordText:UITextField = { () -> UITextField in
        let field = UITextField()
        field.font = fontSize16
        field.placeholder = "输入验证码"
        field.keyboardType = .numbersAndPunctuation
        field.tintColor = SystemNavgationBarTintColor
        field.isSecureTextEntry = true
        
        return field
    }()
    
    lazy var phoneInputBottomLine:UIView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = UIColor.gray

        return view
    }()
    lazy var paswordBottomLine:UIView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()

    lazy var qqButton:UIButton = { () -> UIButton in
        let button = UIButton(type: .custom)
        button.tag = SocietyType.qq.rawValue
        button.setImage(#imageLiteral(resourceName: "qq"), for: .normal)
        return button
    }()
    
    lazy var sinaButton:UIButton = { () -> UIButton in
        let button = UIButton(type: .custom)
        button.tag = SocietyType.sina.rawValue
        button.setImage(#imageLiteral(resourceName: "webo"), for: .normal)
        return button
    }()
    
    lazy var wechatButton:UIButton = { () -> UIButton in
        let button = UIButton(type: .custom)
        button.tag = SocietyType.wechat.rawValue
        button.setImage(#imageLiteral(resourceName: "wechat"), for: .normal)
        return button
    }()
    
//MARK: 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLoginView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLoginViewSubView()
    }
//MARK: 私有方法
    private func setupLoginView() {
    
        addSubview(loginButton)
        addSubview(registerButton)
        addSubview(forgetPwdButton)
        addSubview(passwordText)
        addSubview(phoneText)
        addSubview(phoneInputBottomLine)
        addSubview(paswordBottomLine)
        addSubview(qqButton)
        addSubview(wechatButton)
        addSubview(sinaButton)
        
    
        loginButton.addTarget(self, action: #selector(loginButtonClick), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonClick), for: .touchUpInside)
        forgetPwdButton.addTarget(self, action: #selector(forgetPwdButtonClick), for: .touchUpInside)
        
        qqButton.addTarget(self, action: #selector(SocietyLoginButtonClick(button:)), for: .touchUpInside)
        wechatButton.addTarget(self, action: #selector(SocietyLoginButtonClick(button:)), for: .touchUpInside)
        sinaButton.addTarget(self, action: #selector(SocietyLoginButtonClick(button:)), for: .touchUpInside)
        
        phoneText.addTarget(self, action: #selector(textFieldValueDidChange), for: .editingChanged)
        passwordText.addTarget(self, action: #selector(textFieldValueDidChange), for: .editingChanged)
    }
    
    private func setupLoginViewSubView() {
        
        loginButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-margin * 5)
            make.left.equalToSuperview().offset(margin * 2)
            make.right.equalToSuperview().offset(-(margin * 2))
            make.height.equalTo(margin * 4)
        }
        
        forgetPwdButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-margin * 2)
            make.bottom.equalTo(loginButton.snp.top).offset(-margin * 2)
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-margin * 2)
            make.top.equalTo(loginButton.snp.bottom).offset(margin * 2)
        }
        
        passwordText.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(margin * 2)
            make.bottom.equalTo(forgetPwdButton.snp.top).offset(-(margin*2))
            make.right.equalToSuperview().offset(-margin * 4)
            make.height.equalTo(margin * 4)
        }
        
        paswordBottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(passwordText)
            make.right.equalTo(loginButton)
            make.top.equalTo(passwordText.snp.bottom)
            make.height.equalTo(0.8)
        }
        
        phoneText.snp.makeConstraints { (make) in
            make.left.width.equalTo(paswordBottomLine)
            make.bottom.equalTo(passwordText.snp.top).offset(-margin)
            make.height.equalTo(margin * 4)
        }
        
        phoneInputBottomLine.snp.makeConstraints { (make) in
            make.left.width.equalTo(phoneText)
            make.top.equalTo(phoneText.snp.bottom)
            make.height.equalTo(paswordBottomLine)
        }
        
        wechatButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(registerButton.snp.bottom).offset(margin * 3)
            make.width.height.equalTo(margin*3.6)
        }
        
        sinaButton.snp.makeConstraints { (make) in
            make.top.size.equalTo(wechatButton)
            make.centerX.equalToSuperview().multipliedBy(0.5).offset(-margin)
        }
        
        qqButton.snp.makeConstraints { (make) in
            make.top.size.equalTo(wechatButton)
            make.centerX.equalToSuperview().multipliedBy(1.5).offset(margin)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
        
    }
    
//MARK: 内部响应
    @objc private func closeLoginView() {
        delegate?.loginViewCloseButtonClick()
    }
    
    @objc private func loginButtonClick() {
        delegate?.loginViewLoginButtonClick(withPhone: phoneText.text, withPassword: passwordText.text)
    }
    
    @objc private func registerButtonClick() {
        delegate?.loginViewTurnToRegisterViewButtonClick()
    }
    
    func forgetPwdButtonClick() {
        
    }


    @objc private func SocietyLoginButtonClick(button:UIButton) {
        delegate?.loginViewSocietyLoginButtonClick(withType: SocietyType(rawValue: button.tag)!)
    }
    
    @objc private func textFieldValueDidChange() {
        loginButton.isEnabled = !passwordText.text!.isEmpty && !phoneText.text!.isEmpty
    }
    
}


//MARK: 协议
protocol LoginViewDelegate:NSObjectProtocol {
    func loginViewCloseButtonClick()
    func loginViewLoginButtonClick(withPhone phone:String?,withPassword passwd:String?)
    func loginViewTurnToRegisterViewButtonClick()
    func loginViewSocietyLoginButtonClick(withType type:SocietyType)
}

public enum SocietyType : Int {
    
    case wechat 
    
    case sina
    
    case qq

}


