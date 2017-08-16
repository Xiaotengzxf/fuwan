//
//  BaseEmojiCellViewModel.swift
//  someone
//
//  Created by zxf on 2017/5/14.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class BaseEmojiCellViewModel: NSObject {
    
    var emoji:Emoji?
    
    var hightLightImage:UIImage?
    
    var isShowHightLightImage:Bool?
    
    init(withEmoji emoji:Emoji) {
        self.emoji = emoji
    }
}
