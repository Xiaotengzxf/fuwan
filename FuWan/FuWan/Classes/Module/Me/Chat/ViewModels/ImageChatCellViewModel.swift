//
//  ImageChatCellViewModel.swift
//  小礼品
//
//  Created by zxf on 2017/4/28.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class ImageChatCellViewModel: BaseChatCellViewModel {

    var imageSize:CGSize = .zero
    
    var imagePath:String?
    
    var imageUrl:String?
    
//MARK: 构造方法
    init(withImageMessage msg: ImageMessage) {
        super.init(withMsgModel: msg)
        
        imagePath = msg.imagePath
        imageUrl = msg.imageUrl
        
        
    }
}
