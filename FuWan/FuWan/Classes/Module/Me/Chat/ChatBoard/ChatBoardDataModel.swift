//
//  ChatBoardViewModel.swift
//  someone
//
//  Created by zxf on 2017/4/28.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class ChatBoardDataModel: NSObject {
    //: 转换后的视图模型数据
    var msgModels:NSMutableArray = NSMutableArray()
    var heights:NSMutableArray = NSMutableArray()
    
    //: 查询模型高度
    func viewHeight(msg:MessageModel) -> CGFloat {
        
        return BaseChatCellViewModel.create(withMsgModel: msg)!.viewFrame.height
    }
    //: 查找数据模型
    func indexForMsgModel(_ model:MessageModel,finshed:@escaping (_ index:Int,_ isFind:Bool) ->()){
        
        var hasObject:Bool = false
        var index = 0
        
        for i in 0..<msgModels.count {
            let msgModel = msgModels[i] as! MessageModel
            if model.isEqualModel(msgModel) {
                hasObject = true
                index = i
            }
        }

        finshed(index,hasObject)

    }
    
    //: 通过ID查找模块
    func indexForMsgModel(withID id:String,withType type:MessageType,finshed:@escaping (_ index:Int,_ isFind:Bool) ->()){
        
        var hasObject:Bool = false
        var index = 0
        
        for i in 0..<msgModels.count {
            let msgModel = msgModels[i] as! MessageModel
            if type == msgModel.type && msgModel.id == id {
                hasObject = true
                index = i
            }
        }
        
        finshed(index,hasObject)
        
    }
    
}
