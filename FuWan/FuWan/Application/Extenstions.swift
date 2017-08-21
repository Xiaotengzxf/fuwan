//
//  Extenstions.swift
//  Fuwan
//
//  Created by ANKER on 2017/8/18.
//  Copyright © 2017年 zxf. All rights reserved.
//

import Foundation

extension String {
    func validataPhone() -> Bool {
        let predicate =  NSPredicate(format: "SELF MATCHES %@", "^((13[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$")
        return predicate.evaluate(with: self, substitutionVariables: nil)
    }
}
