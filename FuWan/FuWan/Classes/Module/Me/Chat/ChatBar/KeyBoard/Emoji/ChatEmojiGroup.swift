//
//  ChatEmojiGroup.swift
//  someone
//
//  Created by zxf on 2017/4/27.
//  Copyright © 2017年 zxf. All rights reserved.
//  表情组基本数据结构

import UIKit

public enum EmojiType : Int {
    
    case Emoji
    
    case Favorite
    
    case Face
    
    case Image
    
    case ImageTitle
    
    case Other
    
    case Delete
    
}

public enum LoadState : Int {
    
    case unDownload
    
    case download
    
    case downloading
    
}

class ChatBannerInfo: NSObject {
    var id:String?
    
    var url:String?
}

class ChatEmojiGroup: NSObject {
//MARK: 本地数据
    //: 表情数据
    var emojis:Array<Any>? {
        didSet{
                count = emojis!.count
                
                if type == .Emoji || type == .Face {
                    row = 3
                    col = 7
                }
                else {
                    row = 2
                    col = 4
                }
                
                pageItems = row * col
                pages = count / pageItems + (count % pageItems == 0 ? 0 : 1)
        }
    }
//MARK: 懒加载
    //: 表情类型
    var type:EmojiType?

//MARK: 基本信息描述
    //: 表情组id
    var id:String?
    
    //: 表情组name
    var name:String?
    
    //: 表情组path
    var path:String?
    
    //: 表情组头像path
    var iconPath:String?
    
    //: 表情组网络路径(如果来自网络)
    var iconUrl:String?
    
    //: 表情组总个数
    var count:Int = 0
    
    //: 表情组简略信息
    var info:String?
    
    //: 表情组详细信息
    var detailInfo:String?
    
    //: 表情组创建日期
    var date:Date?
    
    //: 表情组载入状态
    var status:LoadState?
    
    //: 作者
    var auth:String?
    
    //: 作者描述
    var authInfo:String?
    
//MARK: 表情组管理属性
    
    var banner:ChatBannerInfo?
    
    //: 每页表情数
    var pageItems:Int = 0
    
    //: 页数
    var pages:Int = 0

    //: 行数
    var row:Int = 0
    
    //: 列数
    var col:Int = 0

    
//MARK: 构造方法
    

}
