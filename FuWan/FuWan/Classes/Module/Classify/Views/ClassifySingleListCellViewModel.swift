//
//  ClassifySingleListCellViewModel.swift
//  someone
//
//  Created by zxf on 2017/4/23.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class ClassifySingleListCellDataModel: NSObject {
    
}

class ClassifySingleListCellViewModel: NSObject {
    var dataModel:ClassifySingleListCellDataModel?
    
    var photoImage:UIImage?
    var titleLabelText:String?
    var tagLabelText:String?
    var tagNameLabelText:String?
    var priceButtonTitle:String?
    
    init(withModel model:ClassifySingleListCellDataModel) {
        self.dataModel = model
        
        photoImage = UIImage(named: "strategy_\(Int(arc4random() % 17) + 1).jpg")
        titleLabelText = "第68期|讲真，不规矩穿衣让你衣品开挂！"
        tagLabelText = "17-05"
        tagNameLabelText = "穿衣大队长"
        priceButtonTitle = "1789"
    }
}
