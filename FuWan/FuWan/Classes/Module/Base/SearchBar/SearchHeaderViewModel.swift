//
//  SearchHeaderViewModel.swift
//  小礼品
//
//  Created by zxf on 2017/4/22.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
class SearchViewDataModel: NSObject{
    
}

class SearchHeaderViewModel: NSObject {
    var dataModel:SearchViewDataModel?
    
    var titles:Array<String>?
    var titleLabelText:String?
    
    init(withModel model:SearchViewDataModel) {
        self.dataModel = model
        
        titleLabelText = "    大家都在搜"
        titles = ["零食", "手机壳", "双肩包", "钱包", "凉鞋", "手表", "情侣", "泳衣", "杯子", "连衣裙", "手链", "宿舍"]
    }
}
