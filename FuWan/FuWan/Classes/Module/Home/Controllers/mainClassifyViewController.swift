//
//  mainClassifyViewController.swift
//  someone
//
//  Created by zxf on 2017/4/18.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
import SnapKit

let  bannerCarouselViewHeight = 160

class mainClassifyViewController: BaseClassifyViewController {

//MARK: 懒加载
    lazy var headView:UIView = UIView()
    lazy var bannerCarousel = BannerCarouselView(frame: CGRect.zero, collectionViewLayout: BannerCaruselLayout())
    lazy var topicView = TopicCollectionView(frame: CGRect.zero, collectionViewLayout: TopicFlowLayout())
//MARK: 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMainClassifyView()

        NetworkTools.shared.get(Load_AD_URL + "index_banner,search_default_text,hot_search_word,index_four_ad,index_recom_ad,index_module", parameters: nil) {[weak self] (isSucess, result, error) in
            
            guard let result = result else {
                return
            }
            
            if result["status"] == "success" {
                if let datas = result["datas"].array {
                    for data in datas {
                        if let type = data["type"].string, type == "index_banner" {
                            self?.bannerCarousel.arrModel = data["lists"].arrayValue
                            self?.bannerCarousel.pageControl.numberOfPages = data["lists"].arrayValue.count
                            self?.bannerCarousel.reloadData()
                            self?.bannerCarousel.setupBannerCarouselViewSubView()
                        }else if let type = data["type"].string, type == "index_module" {
                            self?.topicView.collectionData = data["lists"].arrayValue
                            self?.topicView.reloadData()
                        }
                    }
                }
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        headView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalTo(ScreenWidth)
            let height : CGFloat = ScreenWidth * 2 / 5 + 2
            make.height.equalTo(CGFloat(bannerCarouselViewHeight + 30) + height)
        }

        bannerCarousel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(bannerCarouselViewHeight)
        }
        
        topicView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(bannerCarousel.snp.bottom)
            make.height.equalTo(ScreenWidth * 2 / 5 + 2)
        }
        
        tableView.tableHeaderView = headView
        tableView.tableHeaderView?.bounds = CGRect(x: 0, y: 0, width: ScreenWidth, height: CGFloat(bannerCarouselViewHeight + 30) + CGFloat(ScreenWidth * 2 / 5 + 2))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bannerCarousel.startAutoCarousel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        bannerCarousel.stopAutoCarousel()
    }
//MARK: 私有方法
    private func setupMainClassifyView() {
        headView.addSubview(bannerCarousel)
        headView.addSubview(topicView)
        tableView.tableHeaderView = headView
        
    }
}
