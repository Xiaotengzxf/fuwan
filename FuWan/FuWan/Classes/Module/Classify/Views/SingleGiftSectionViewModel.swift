//
//  SingleGiftSectionViewModel.swift
//  someone
//
//  Created by zxf on 2017/4/21.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
class SingleGiftSectionDataModel: NSObject {
    let title = ["美物","手工","吃货","萌萌哒","动漫迷","小清新","科技范","熊孩子","烂漫","任性","欧巴","御姐","公主","音乐范","艺术气质","闺蜜","同学","创意"]
    var classifyTitle:String?
    init(withIndex index:Int) {
        classifyTitle = title[index]
    }
}

class SingleGiftSectionViewModel: NSObject {
    var dataModel:SingleGiftSectionDataModel
    
    var titleLabelText:String?
    
    init(withModel model:SingleGiftSectionDataModel) {
        self.dataModel = model
        titleLabelText = model.classifyTitle
    }
}
