//
//  SingleGiftCellViewModel.swift
//  someone
//
//  Created by zxf on 2017/4/21.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class SingleGiftCellDataModel: NSObject {
    
}

class SingleGiftCellViewModel: NSObject {
    var dataModel:SingleGiftCellDataModel?
    var photoImage:UIImage?
    var titleLabelText:String?
    
    init(withModel model:SingleGiftCellDataModel) {
        self.dataModel = model
        photoImage = UIImage(named: "gifts_\(Int(arc4random() % 26) + 1).jpg")
        titleLabelText = "好多礼物"
        
    }
}
