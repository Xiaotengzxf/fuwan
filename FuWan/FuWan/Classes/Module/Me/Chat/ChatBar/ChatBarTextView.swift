//
//  ChatBarTextView.swift
//  小礼品
//
//  Created by zxf on 2017/6/3.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class ChatBarTextView: UITextView {
//MARK : 属性
    open var message: String!
    open var oldText: String?
//MARK : 构造方法
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK : 开放接口
    func clearText() {
        message = ""
        oldText = ""
        text = ""
    }
    
    //: 更新字符
    func updateText() {
        var newText:String = ""
        if let index = oldText?.endIndex {
            newText = text.substring(from: index)
        }
        else {
            newText = text
            
        }
        
        oldText = text
        
        if let msg = message {
            message = msg.appending(newText)
        }
        else {
            message = newText
        }
    }
}
