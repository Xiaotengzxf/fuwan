//
//  TopicViewModel.swift
//  小礼品
//
//  Created by zxf on 2017/4/20.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class TopicDataModel: NSObject {
    var topicImageUrls:Array<String>?
}


class TopicViewModel: NSObject {
    var dataModel:TopicDataModel?
    
    var image:UIImage
    
    init(withModel model:TopicDataModel) {
        self.dataModel = model
        image = UIImage(named: "strategy_\(Int(arc4random() % 17) + 1).jpg")!
    }
}
