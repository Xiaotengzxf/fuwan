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

class mainClassifyViewController: BaseClassifyViewController, TopicCollectionViewDelegate, BannerCarouselViewDelegate, UISearchBarDelegate {

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
    lazy var btnCity: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("郑州", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(self.chooseCity(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var search: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "请输入您想要搜索的内容"
        searchbar.backgroundImage = UIImage()
        searchbar.backgroundColor = UIColor.white
        searchbar.layer.cornerRadius = 15
        searchbar.delegate = self
        return searchbar
    }()
    
    lazy var btnChat: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "chat"), for: .normal)
        button.addTarget(self, action: #selector(self.goToChat(_:)), for: .touchUpInside)
        return button
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
        
        btnCity.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.left.equalTo(5)
            make.top.equalTo(10)
            make.width.equalTo(50)
        }
        
        btnChat.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.right.equalTo(-5)
            make.top.equalTo(10)
            make.width.equalTo(30)
        }
        
        search.snp.makeConstraints { (make) in
            make.left.equalTo(btnCity.snp.right).offset(5)
            make.right.equalTo(btnChat.snp.left).offset(-5)
            make.height.equalTo(30)
            make.top.equalTo(10)
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
        bannerCarousel.viewDelegate = self
        tableView.tableHeaderView = headView
        headView.addSubview(btnCity)
        headView.addSubview(search)
        headView.addSubview(btnChat)
    }
    
    func chooseCity(_ sender: Any) {
        
    }
    
    func goToChat(_ sender: Any) {
        
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
    
    func selectRow(row : Int, json: JSON) {
        if let url = json["url"].string, url.characters.count > 0 {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            let webView = WebViewController(url: url)
            self.navigationController?.pushViewController(webView, animated: true)
            return
        }
//        if let modelId = json["modelid"].string {
//            if modelId == "0" {
//                let webView = WebViewController(url: CATEGORY_URL)
//                self.navigationController?.pushViewController(webView, animated: true)
//            }else {
//                let webView = WebViewController(url: MODULE_URL + modelId)
//                self.navigationController?.pushViewController(webView, animated: true)
//            }
//        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
