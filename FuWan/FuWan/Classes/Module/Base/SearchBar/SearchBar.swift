//
//  SearchBar.swift
//  someone
//
//  Created by zxf on 2017/4/21.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit



class SearchBar: UISearchBar {


//MARK: 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSearchBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: 私有方法
    private func setupSearchBar() {
        backgroundColor = UIColor.clear
        sizeToFit()
        //: 移除灰色背景
        subviews[0].subviews[0].removeFromSuperview()
    }

//MARK： 外部接口方法
    func customBorder(withColor color:UIColor) {
        guard let textField = value(forKey: "searchField") as? UITextField else {
            return
        }
        
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = bounds.height * 0.3
        textField.layer.borderColor = color.cgColor
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        
        setImage(#imageLiteral(resourceName: "Info_more_search.png"), for: .search, state: .normal)
        setImage(#imageLiteral(resourceName: "audio_nav.png"), for: .bookmark, state: .normal)

    }
    
    

}
