//
//  ImageChatCell.swift
//  someone
//
//  Created by zxf on 2017/4/28.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class ImageChatCell: BaseChatCell {
//MARK: 属性
    var viewModel:ImageChatCellViewModel? {
        didSet {
            super.baseViewModel = viewModel
            
            if let path = viewModel!.imagePath {
                imageMessage.image = UIImage(named: path)
            }
        }
    }
//MARK: 懒加载
    lazy var imageMessage:UIImageView = { () -> UIImageView in
       let view = UIImageView()
        
        return view
    }()
//MARK: 构造方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupImageChatCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: 私有方法
    private func setupImageChatCell() {
        addSubview(imageMessage)
    }
}
