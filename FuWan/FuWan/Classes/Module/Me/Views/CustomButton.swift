//
//  CustomButton.swift
//  someone
//
//  Created by zxf on 2017/4/24.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
import SnapKit

class CustomButton: UIButton {

//MARK: 重写布局
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let centerMargin = margin * 0.2
        let imageOffsetY = (bounds.height - imageView!.bounds.height - titleLabel!.bounds.height - centerMargin) * 0.5
        let imageOffsetX = (bounds.width - imageView!.bounds.width) * 0.5
        let titleOffsetX = (bounds.width - titleLabel!.bounds.width) * 0.5
        
        imageView!.frame.origin.y = imageOffsetY
        imageView!.frame.origin.x = imageOffsetX
        
    
        titleLabel!.frame.origin.y = imageView!.frame.maxY + centerMargin
        titleLabel!.frame.origin.x = titleOffsetX
        
        
    }
}
