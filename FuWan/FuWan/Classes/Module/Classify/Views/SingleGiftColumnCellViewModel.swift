//
//  SingleGiftColumnCellViewModel.swift
//  someone
//
//  Created by zxf on 2017/4/21.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class SingleGiftColumnCellDataModel: NSObject {
    
    let title = ["美物","手工","吃货","萌萌哒","动漫迷","小清新","科技范","熊孩子","烂漫","任性","欧巴","御姐","公主","音乐范","艺术气质","闺蜜","同学","创意"]
    var classifyTitle:String?
    
    init(withIndex index:Int) {
        classifyTitle = title[index]
    }
    
}

class SingleGiftColumnCellViewModel: NSObject {
    var dataModel:SingleGiftColumnCellDataModel?
    
    var titleButtonText:String?
    
    init(withModel model:SingleGiftColumnCellDataModel) {
        self.dataModel = model
        
        titleButtonText = model.classifyTitle
    }
}
