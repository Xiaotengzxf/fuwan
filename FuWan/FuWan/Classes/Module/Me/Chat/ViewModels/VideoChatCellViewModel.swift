//
//  VideoChatCellViewModel.swift
//  someone
//
//  Created by zxf on 2017/4/28.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class VideoChatCellViewModel: BaseChatCellViewModel {
    
    init(withVideoMessage msg: VideoMessage) {
        super.init(withMsgModel: msg as MessageModel)
        
    }
}
