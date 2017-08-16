//
//  MoreKeyboard.swift
//  someone
//
//  Created by zxf on 2017/5/11.
//  Copyright © 2017年 zxf. All rights reserved.
//  更多选择键盘

import UIKit

class MoreKeyboard: BaseKeyboard {

//: 单例
    static let shared = MoreKeyboard()

//: 懒加载

//: 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMoreKeyboard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//: 私有方法
    private func setupMoreKeyboard() {
        backgroundColor = SystemGlobalBackgroundColor
    }

}
