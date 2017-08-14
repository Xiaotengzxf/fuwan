//
//  Emoji.swift
//  小礼品
//
//  Created by zxf on 2017/4/27.
//  Copyright © 2017年 zxf. All rights reserved.
//  表情基本模型

import UIKit

class Emoji: NSObject {
    //: 表情分类
    var type:EmojiType?
    
    //: 表情所在的组ID
    var groupID:String?
    
    //: 表情id
    var id:String?
    
    //:表情名称
    var name:String?
    
    //: 表情本地存储地址
    var path:String? 
    
    //: 表情远端地址
    var url:String?
    
    //: 表情大小
    var size:CGSize?
    
//MARK: 外部接口方法
    func path(withGroupID groupID:String,withEmojiID id:String) -> String {
        return "\(FileManager.expressionPath(groupID: groupID))\(id)"
    }

}
