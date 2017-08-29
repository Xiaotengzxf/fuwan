//
//  BannerCarouselView.swift
//  someone
//
//  Created by zxf on 2017/4/18.
//  Copyright © 2017年 zxf. All rights reserved.
//  图片轮播器

import UIKit
import SnapKit
import QorumLogs
import SwiftyJSON

let timeInterval = 2.0
let pageLoopCount = 1000
let cellHeight:CGFloat = 300.0
let pageCotrolYOffSetOfBottom:CGFloat = 12.0

class BannerCarouselView: UICollectionView {
    
    var viewDelegate: BannerCarouselViewDelegate?
    
    var arrModel : [JSON] = []
//MARK: 属性
    fileprivate let identifier = "BannerCarouselCell"
    //: 定时器
    private var timer:Timer?
//MARK: 懒记载
    lazy var pageControl:UIPageControl = { () -> UIPageControl in
        let control = UIPageControl()
        
        control.currentPageIndicatorTintColor = SystemNavgationBarTintColor
        
        control.pageIndicatorTintColor = UIColor(white: 0, alpha: 0.1)
        
        return control
    }()
//MARK: 构造方法
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupBannerCarouselView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
//MARK: 私有方法
    private func setupBannerCarouselView() {
        backgroundColor = SystemGlobalBackgroundColor
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        isPagingEnabled = true
        delegate = self
        dataSource = self
        
        register(BannerCarouselViewCell.self, forCellWithReuseIdentifier: identifier)
        
        addSubview(pageControl)
        
       
    }
    
    func setupBannerCarouselViewSubView() {
    
        DispatchQueue.once(token: "pageControl.layout") {
            self.pageControl.center.x = self.bounds.width * 0.5;
            self.pageControl.frame.origin.y = self.bounds.height - (pageCotrolYOffSetOfBottom + self.pageControl.bounds.height);
            
            //: 移动到中心位置
            scrollToItem(at: IndexPath(item: arrModel.count * pageLoopCount/2, section: 0) , at:.left, animated: true)
        }
       
    }
    
    //: 开始自动轮播
    func startAutoCarousel() {
        let timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(changePage), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer, forMode: .commonModes)
        self.timer = timer
    }
    
    //: 结束自动轮播
    func stopAutoCarousel() {
        if self.timer != nil && self.timer!.isValid {
            self.timer?.invalidate()
        }
        
        self.timer = nil
    }
//MARK: 内部响应方法
    @objc private func changePage() {
        let current = indexPathsForVisibleItems.last
        var item = current!.item + 1
        
        if current!.item + 1 > arrModel.count * pageLoopCount / 2 + pageLoopCount * (arrModel.count - 1)/2 {
            item = arrModel.count * pageLoopCount / 2
        }
        scrollToItem(at: IndexPath(item: item, section: 0) , at:.left, animated: true)
    }
}

//MARK: 代理方法 -> UICollectionViewDelegate
extension BannerCarouselView:UICollectionViewDelegate,UICollectionViewDataSource {
    //: 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //: 页数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrModel.count * pageLoopCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! BannerCarouselViewCell
        
        
        cell.viewModel = arrModel[indexPath.row % arrModel.count]
        
        return cell
    }
    
    //: 点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewDelegate?.selectRow(row: indexPath.row % arrModel.count, json: arrModel[indexPath.row % arrModel.count])
    }
    
}

extension BannerCarouselView:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        pageControl.center.x = scrollView.contentOffset.x + (ScreenWidth * 0.5)
        let page = (scrollView.contentOffset.x / scrollView.bounds.width + 0.5).truncatingRemainder(dividingBy: CGFloat(arrModel.count))

        pageControl.currentPage = Int(page)
    }
    
    //: 停止轮播
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoCarousel()
    }
    
    //: 开始轮播
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startAutoCarousel()
    }
}

class BannerCaruselLayout:UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        itemSize = CGSize(width: collectionView!.bounds.width, height: cellHeight)
    }
}

protocol BannerCarouselViewDelegate {
    func selectRow(row : Int, json: JSON)
}
