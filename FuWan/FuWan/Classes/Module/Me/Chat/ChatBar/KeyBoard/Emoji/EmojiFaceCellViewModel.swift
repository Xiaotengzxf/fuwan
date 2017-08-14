//
//  EmojiFaceCellViewModel.swift
//  小礼品
//
//  Created by zxf on 2017/5/14.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class EmojiFaceCellViewModel: BaseEmojiCellViewModel {

    //: 属性
    var isImageViewHidden:Bool = false
    var isLabelHidden:Bool = false
    var image:UIImage?
    var lableText:String?
    
    override init(withEmoji emoji: Emoji) {
        super.init(withEmoji: emoji)
        
       
        if emoji.type == .Other {
            isImageViewHidden = true
            isLabelHidden = true
        }
        else  if emoji.type == .Delete{
            isImageViewHidden = false
            isLabelHidden = true
            image = #imageLiteral(resourceName: "DeleteEmoticonBtn.png")
        }
        else {
            
            if (emoji.type == .Face) {
                isImageViewHidden = false
                isLabelHidden = true
                
                if let name = emoji.name {
                    
                    image = UIImage(named: name)
                    
                }
            }
            else {
                isImageViewHidden = true
                isLabelHidden = false
                
                if let name = emoji.name {
                    lableText = name
                }
            }
        }
    }
}
