//
//  TopicViewCell.swift
//  someone
//
//  Created by zxf on 2017/4/20.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
import SnapKit

class TopicViewCell: UICollectionViewCell {
//MARK: 属性
    var viewModel:TopicViewModel? {
        didSet{
            imageView.image = viewModel?.image
        }
    }
//MARK: 懒加载
    lazy var imageView:UIImageView = UIImageView()
//MARK: 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTopicViewCell()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupTopicViewSubView()
    }
//MARK: 私有方法
    private func setupTopicViewCell() {
        addSubview(imageView)
    }
    
    private func setupTopicViewSubView() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
    }
}
