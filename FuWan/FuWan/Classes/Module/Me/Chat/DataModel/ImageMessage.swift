//
//  ImageMessage.swift
//  小礼品
//
//  Created by zxf on 2017/4/28.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class ImageMessage: MessageModel {
    //: 本地图片路径
    var imagePath:String?
    
    //: 网络图片路径
    var imageUrl:String?
 
//MARK: 构造方法
    override init() {
        super.init()
        type = .image
    }
}
