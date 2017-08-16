//
//  NSAttributedString+Extension.swift
//  someone
//
//  Created by zxf on 2017/4/29.
//  Copyright © 2017年 zxf. All rights reserved.
//

import Foundation
import UIKit


extension NSAttributedString {
    func sizeToFits(_ size:CGSize) -> CGSize {
        
        guard let font = attribute(NSFontAttributeName, at: 0, effectiveRange: nil) else {
            return CGSize.zero
        }
        
        return string.fitSize(size, font as! UIFont)
    }
    
    func sizeToFitsAttribute(_ size:CGSize) -> CGSize {
        
        return boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size
    }
}
