//
//  String+Extension.swift
//  小礼品
//
//  Created by zxf on 2017/4/18.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

extension String {
    //: 返回字体宽度
    func stringWidth(withFont font:UIFont) -> CGFloat{
        return self.boundingRect(with: CGSize.zero, options: .init(rawValue: 0), attributes: [NSFontAttributeName:font], context: nil).width
    }
}
