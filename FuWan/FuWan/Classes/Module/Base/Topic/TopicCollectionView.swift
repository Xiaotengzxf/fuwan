//
//  TopicCollectionView.swift
//  someone
//
//  Created by zxf on 2017/4/20.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
import SwiftyJSON



class TopicCollectionView: UICollectionView {
    
    var collectionData: [JSON] = []
    fileprivate let identifier = "TopicCell"
//MARK: 构造方法
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupTopicView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: 私有方法
    private func setupTopicView() {
        backgroundColor = UIColor.white
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        delegate = self
        dataSource = self
        
        register(TopicViewCell.self, forCellWithReuseIdentifier: identifier)
    }
}

//MAKR: 数据源与代理方法
extension TopicCollectionView:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TopicViewCell
        let model = collectionData[indexPath.row]
        cell.imageView.sd_setImage(with: URL(string: model["pic"].stringValue), placeholderImage: nil)
        cell.label.text = model["name"].stringValue
        
        return cell
    }
}

class TopicFlowLayout:UICollectionViewFlowLayout{
    override func prepare() {
        super.prepare()
        
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        
        itemSize = CGSize(width: ScreenWidth / 5, height: ScreenWidth / 5)
    }
}
