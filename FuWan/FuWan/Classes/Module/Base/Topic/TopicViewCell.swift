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

//MARK: 懒加载
    lazy var imageView:UIImageView = UIImageView()
    lazy var label : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        return label
    }()
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
        addSubview(label)
    }
    
    private func setupTopicViewSubView() {
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.center.equalToSuperview()
        }
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
    }
}
