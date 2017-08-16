//
//  ExperssionChatCellViewModel.swift
//  someone
//
//  Created by zxf on 2017/4/28.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class ExpressionChatCellViewModel: BaseChatCellViewModel {

    var emojiSize:CGSize = .zero
    
    init(withExpressionMessage msg: ExpressionMessage) {
        super.init(withMsgModel: msg as MessageModel)
        
    }
}
