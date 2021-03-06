//
//  PopoverSortClassifyViewModel.swift
//  someone
//
//  Created by zxf on 2017/4/24.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class PopoverSortClassifyViewModel: NSObject {
    
    var buttonTitles:Array<String>?
    var popoverTitles:Array<Array<String>>?
    
    override init() {
        super.init()
        buttonTitles = ["对象","场合","个性","价格"]
        popoverTitles = [["全部", "男票", "女盆友", "闺蜜们", "基友", "爸爸妈妈", "小盆友", "同事"],
                         ["全部", "生日", "情人节", "结婚", "新年", "感谢", "纪念日", "乔迁", "圣诞节"],
                         ["全部", "萌", "小清新", "创意", "奇葩", "文艺范", "科技感", "设计感"],
                         ["全部", "50以下", "50-200", "200-500", "500-1000", "1000以上"]]
    }
}
