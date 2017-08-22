//
//  mainClassifyViewController.swift
//  someone
//
//  Created by zxf on 2017/4/18.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

let  bannerCarouselViewHeight = 160

class mainClassifyViewController: BaseClassifyViewController, TopicCollectionViewDelegate {

//MARK: 懒加载
    lazy var headView:UIView = UIView()
    lazy var bannerCarousel = BannerCarouselView(frame: CGRect.zero, collectionViewLayout: BannerCaruselLayout())
    lazy var topicView = TopicCollectionView(frame: CGRect.zero, collectionViewLayout: TopicFlowLayout())
    lazy var labelTip : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "-- 猜你喜欢 --"
        label.textAlignment = .center
        return label
    }()
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
        
        labelTip.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.left.right.equalToSuperview()
            make.top.equalTo(topicView.snp.bottom).offset(5)
        }
        
        tableView.tableHeaderView = headView
        headView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        tableView.tableHeaderView?.bounds = CGRect(x: 0, y: 0, width: ScreenWidth, height: CGFloat(bannerCarouselViewHeight + 70) + CGFloat(ScreenWidth * 2 / 5 + 2))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //bannerCarousel.startAutoCarousel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //bannerCarousel.stopAutoCarousel()
    }
    // MARK: 私有方法
    private func setupMainClassifyView() {
        headView.addSubview(bannerCarousel)
        headView.addSubview(topicView)
        headView.addSubview(labelTip)
        topicView.topicDelegate = self
        tableView.tableHeaderView = headView
        
    }
    
    // MARK: - Delegate
    func selectedIndexPath(indexPath: IndexPath, item: JSON) {
        if let url = item["url"].string, url.characters.count > 0 {
            return
        }
        if let modelId = item["modelid"].string {
            if modelId == "0" {
                let webView = WebViewController(url: CATEGORY_URL)
                self.navigationController?.pushViewController(webView, animated: true)
            }else {
                let webView = WebViewController(url: MODULE_URL + modelId)
                self.navigationController?.pushViewController(webView, animated: true)
            }
        }
        
    }
    
}
