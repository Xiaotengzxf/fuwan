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
let  topicViewHeight = 120

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
            make.height.equalTo(bannerCarouselViewHeight + topicViewHeight + 10)
        }

        bannerCarousel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(bannerCarouselViewHeight)
        }
        
        topicView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(bannerCarousel.snp.bottom)
            make.height.equalTo(topicViewHeight)
        }
        
        tableView.tableHeaderView = headView
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

/*{
 "status": "success",
 "datas": [
 {
 "lists": [
 {
 
 },
 {
 "id": "8",
 "name": "2",
 "url": "",
 "pic": "https://mst.fuwan369.com/admin/20170506/20170506191620590db084f2d72.png",
 "end": "1532966400",
 "listorder": "0",
 "modelid": "0"
 },
 {
 "id": "9",
 "name": "3",
 "url": "",
 "pic": "https://mst.fuwan369.com/admin/20170506/20170506191634590db0922b3c9.png",
 "end": "1532966400",
 "listorder": "0",
 "modelid": "0"
 }
 ],
 "type": "index_banner"
 },
 {
 "lists": [],
 "type": "search_default_text"
 },
 {
 "lists": [],
 "type": "hot_search_word"
 },
 {
 "lists": [],
 "type": "index_four_ad"
 },
 {
 "lists": [],
 "type": "index_recom_ad"
 },
 {
 "lists": [
 {
 "id": "22",
 "name": "娱乐",
 "url": "",
 "pic": "https://mst.fuwan369.com/admin/20170527/2017052721121159297b2bb6bfd.png",
 "end": "1530028800",
 "listorder": "0",
 "modelid": "40"
 },
 {
 "id": "23",
 "name": "酒店",
 "url": "",
 "pic": "https://mst.fuwan369.com/admin/20170527/2017052721134559297b899fb63.png",
 "end": "1530028800",
 "listorder": "0",
 "modelid": "34"
 },
 {
 "id": "24",
 "name": "餐饮",
 "url": "",
 "pic": "https://mst.fuwan369.com/admin/20170527/2017052721215859297d762ad8d.png",
 "end": "1529942400",
 "listorder": "0",
 "modelid": "33"
 },
 {
 "id": "25",
 "name": "旅游",
 "url": "",
 "pic": "https://mst.fuwan369.com/admin/20170527/2017052721221659297d886f05c.png",
 "end": "1530028800",
 "listorder": "0",
 "modelid": "36"
 },
 {
 "id": "26",
 "name": "车辆",
 "url": "",
 "pic": "https://mst.fuwan369.com/admin/20170527/2017052721223159297d97f2eb7.png",
 "end": "1530028800",
 "listorder": "0",
 "modelid": "37"
 },
 {
 "id": "27",
 "name": "商城",
 "url": "",
 "pic": "https://mst.fuwan369.com/admin/20170527/2017052721231759297dc51e84e.png",
 "end": "1530028800",
 "listorder": "0",
 "modelid": "41"
 },
 {
 "id": "28",
 "name": "社区",
 "url": "",
 "pic": "https://mst.fuwan369.com/admin/20170527/2017052721233559297dd7e7072.png",
 "end": "1530115200",
 "listorder": "0",
 "modelid": "35"
 },
 {
 "id": "29",
 "name": "游戏",
 "url": "game",
 "pic": "https://mst.fuwan369.com/admin/20170527/2017052721265559297e9f7c130.png",
 "end": "1530028800",
 "listorder": "0",
 "modelid": "0"
 },
 {
 "id": "30",
 "name": "公告",
 "url": "",
 "pic": "https://mst.fuwan369.com/admin/20170527/2017052721272159297eb94df22.png",
 "end": "1529942400",
 "listorder": "0",
 "modelid": "39"
 },
 {
 "id": "31",
 "name": "更多",
 "url": "",
 "pic": "https://mst.fuwan369.com/admin/20170527/201705272311585929973ef11bc.png",
 "end": "1530028800",
 "listorder": "0",
 "modelid": "0"
 }
 ],
 "type": "index_module"
 }
 ]
 }*/


