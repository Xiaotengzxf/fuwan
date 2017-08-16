//
//  TopicCollectionView.swift
//  someone
//
//  Created by zxf on 2017/4/20.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit



class TopicCollectionView: UICollectionView {
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
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TopicViewCell
        
        cell.viewModel = TopicViewModel(withModel: TopicDataModel())
        
        return cell
    }
}

let cellMargin:CGFloat = 10.0

class TopicFlowLayout:UICollectionViewFlowLayout{
    override func prepare() {
        super.prepare()
        
        minimumInteritemSpacing = cellMargin * 0.5
        minimumLineSpacing = cellMargin
        scrollDirection = .horizontal
        
        itemSize = CGSize(width: collectionView!.bounds.height - cellMargin*2, height: collectionView!.bounds.height - cellMargin*2)
    }
}
