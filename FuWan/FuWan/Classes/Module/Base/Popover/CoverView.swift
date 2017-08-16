//
//  CoverView.swift
//  someone
//
//  Created by zxf on 2017/4/23.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class CoverView: UIView {

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        backgroundColor = UIColor(white: 0.0, alpha: 0.3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
