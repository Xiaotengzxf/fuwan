//
//  PositionMessage.swift
//  someone
//
//  Created by zxf on 2017/4/29.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
import CoreLocation

class PositionMessage: MessageModel {
    //: 地址信息
    var address:String?
    
    //: 地址坐标
    var location:CLLocation?
    
//MARK: 构造方法
    override init() {
        super.init()
        type = .postion
    }
}
