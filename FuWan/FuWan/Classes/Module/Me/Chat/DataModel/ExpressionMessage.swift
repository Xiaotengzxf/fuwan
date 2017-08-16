//
//  ExpressionMessage.swift
//  someone
//
//  Created by zxf on 2017/4/28.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class ExpressionMessage: MessageModel {
    var emoji:Emoji?
    
    var path:String?
    
    var url:String?
    
//: 构造方法
    override init() {
        super.init()
        type = .Expression
    }
}
