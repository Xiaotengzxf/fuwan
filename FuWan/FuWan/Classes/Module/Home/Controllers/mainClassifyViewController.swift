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
import Toaster

let  bannerCarouselViewHeight = 160

class mainClassifyViewController: BaseClassifyViewController, TopicCollectionViewDelegate, BannerCarouselViewDelegate, BMKLocationServiceDelegate {

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
    
    lazy var btnSearch: UIButton = {
        let btnSearch = UIButton(type: .custom)
        btnSearch.setTitle("请输入您想要搜索的内容", for: .normal)
        btnSearch.backgroundColor = UIColor.white
        btnSearch.layer.cornerRadius = 15
        btnSearch.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btnSearch.setTitleColor(UIColor.lightGray, for: .normal)
        btnSearch.addTarget(self, action: #selector(self.goToSearch(_:)), for: .touchUpInside)
        return btnSearch
    }()
    
    lazy var btnChat: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "chat"), for: .normal)
        button.addTarget(self, action: #selector(self.goToChat(_:)), for: .touchUpInside)
        return button
    }()
    
    var _locService : BMKLocationService!
    var loc : [String: String] = [:]
    var bLoadFinished = false
    
//MARK: 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMainClassifyView()

        NetworkTools.shared.get(Load_AD_URL + "index_banner,search_default_text,hot_search_word,index_four_ad,index_recom_ad,index_module", parameters: nil) {[weak self] (isSucess, result, error) in
            
            guard let result = result else {
                let alert = UIAlertController(title: "提示", message: "当前网络有问题，请先修复网络，再重新进入App！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                    
                }))
                self?.present(alert, animated: true, completion: {
                    
                })
                return
            }
            self?.bLoadFinished = true
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
        
        _locService = BMKLocationService()
        _locService.delegate = self
        _locService.startUserLocationService()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotification(notification:)), name: Notification.Name("mainClassifyViewController"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationApplicationWillEnterForeground(notification:)), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    func handleNotificationApplicationWillEnterForeground(notification: Notification) {
        if bLoadFinished == false {
            NetworkTools.shared.get(Load_AD_URL + "index_banner,search_default_text,hot_search_word,index_four_ad,index_recom_ad,index_module", parameters: nil) {[weak self] (isSucess, result, error) in
                
                guard let result = result else {
                    let alert = UIAlertController(title: "提示", message: "当前网络有问题，请先修复网络，再重新进入App！", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                        
                    }))
                    self?.present(alert, animated: true, completion: {
                        
                    })
                    return
                }
                self?.bLoadFinished = true
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
            let height : CGFloat = max(ScreenWidth * 2 / 5, 150) + 2
            make.height.equalTo(CGFloat(bannerCarouselViewHeight + 30) + height)
        }

        bannerCarousel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(bannerCarouselViewHeight)
        }
        
        topicView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(bannerCarousel.snp.bottom)
            make.height.equalTo(max(ScreenWidth * 2 / 5, 150) + 2)
        }
        
        labelTip.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.left.right.equalToSuperview()
            make.top.equalTo(topicView.snp.bottom).offset(5)
        }
        
        btnCity.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.left.equalTo(5)
            make.top.equalTo(15)
            make.width.equalTo(50)
        }
        
        btnChat.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.right.equalTo(-5)
            make.top.equalTo(15)
            make.width.equalTo(30)
        }
        
        btnSearch.snp.makeConstraints { (make) in
            make.left.equalTo(btnCity.snp.right).offset(5)
            make.right.equalTo(btnChat.snp.left).offset(-5)
            make.height.equalTo(30)
            make.top.equalTo(15)
        }
        
        tableView.tableHeaderView = headView
        headView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        tableView.tableHeaderView?.bounds = CGRect(x: 0, y: 0, width: ScreenWidth, height: CGFloat(bannerCarouselViewHeight + 70) + CGFloat(ScreenWidth * 2 / 5 + 10))
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
        headView.addSubview(btnSearch)
        headView.addSubview(btnChat)
    }
    
    func chooseCity(_ sender: Any) {
        let webView = WebViewController(url: AREA_URL + "?lan=&lai=")
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    func goToChat(_ sender: Any) {
        let message = MessageViewController()
        self.navigationController?.pushViewController(message, animated: true)
    }
    
    func goToSearch(_ sender: Any) {
        let searchView = ZSearchViewController()
        self.navigationController?.pushViewController(searchView, animated: true)
    }
    
    func handleNotification(notification: Notification) {
        if let content = notification.object as? String {
            let array = content.components(separatedBy: "&")
            var area_id = ""
            var area_name = ""
            for item in array {
                let arr = item.components(separatedBy: "=")
                if arr.count == 2 {
                    if arr[0] == "area_id" {
                        area_id = arr[1]
                    }else if arr[0] == "area_name" {
                        area_name = arr[1]
                    }
                }
            }
            if area_id.characters.count > 0 {
                UserDefaults.standard.set(area_id, forKey: "area_id")
            }
            if area_name.characters.count > 0 {
                UserDefaults.standard.set(area_name, forKey: "area_name")
            }

            UserDefaults.standard.synchronize()
            
            self.btnCity.setTitle(area_name, for: .normal)
        }
    }
    
    // MARK: - Delegate
    func selectedIndexPath(indexPath: IndexPath, item: JSON) {
        if let url = item["url"].string, url.characters.count > 0 && url.hasPrefix("http") {
            let webView = WebViewController(url: url)
            self.navigationController?.pushViewController(webView, animated: true)
            return
        }
        if let modelId = item["modelid"].string {
            if modelId == "0" {
                self.navigationController?.setNavigationBarHidden(false, animated: false)
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

    func didUpdate(_ userLocation: BMKUserLocation!) {
        
        var region: BMKCoordinateRegion = BMKCoordinateRegion()
        region.center.latitude = userLocation.location.coordinate.latitude
        region.center.longitude = userLocation.location.coordinate.longitude
        region.span.latitudeDelta = 0
        region.span.longitudeDelta = 0
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(userLocation.location) {[weak self] (array, error) in
            if array?.count ?? 0 > 0 {
                if let placemark = array?[0] {
                    if let city = placemark.locality {
                        self?.loc["city"] = city
                        self?.loc["district"] = placemark.subLocality ?? ""
                        self?.loc["ajax"] = "1"
                        NetworkTools.shared.post(LOC_URL, parameters: self!.loc, finished: {[weak self] (isSucess, json, error) in
                            guard let result = json else {
                                return
                            }
                            
                            if result["state"] == "success" {
                                if let info = result["info"].string {
                                    let array = info.components(separatedBy: "&")
                                    var area_id = ""
                                    var area_name = ""
                                    var pos = ""
                                    for item in array {
                                        let arr = item.components(separatedBy: "=")
                                        if arr.count == 2 {
                                            if arr[0] == "area_id" {
                                                area_id = arr[1]
                                            }else if arr[0] == "area_name" {
                                                area_name = arr[1]
                                            }else if arr[0] == "pos" {
                                                pos = arr[1]
                                            }
                                        }
                                    }
                                    if area_id.characters.count > 0 {
                                        UserDefaults.standard.set(area_id, forKey: "loc_area_id")
                                    }
                                    if area_name.characters.count > 0 {
                                        UserDefaults.standard.set(area_name, forKey: "loc_area_name")
                                    }
                                    if pos.characters.count > 0 {
                                        UserDefaults.standard.set(pos, forKey: "pos")
                                    }
                                    UserDefaults.standard.synchronize()
                                    if let area_name_old = UserDefaults.standard.string(forKey: "area_name") {
                                        if area_name_old != area_name {
                                            let alertController = UIAlertController(title: nil, message: "定位到您在【\(area_name)】\n是否切换城市进行探索？", preferredStyle: .alert)
                                            alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: {[weak self] (action) in
                                                if area_id.characters.count > 0 {
                                                    UserDefaults.standard.set(area_id, forKey: "area_id")
                                                }
                                                if area_name.characters.count > 0 {
                                                    UserDefaults.standard.set(area_name, forKey: "area_name")
                                                }
                                                UserDefaults.standard.synchronize()
                                                
                                                self?.btnCity.setTitle(area_name, for: .normal)
                                                
                                            }))
                                            alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
                                                
                                            }))
                                            self?.present(alertController, animated: true, completion: {
                                                
                                            })
                                        }
                                    }else{
                                        if area_id.characters.count > 0 {
                                            UserDefaults.standard.set(area_id, forKey: "area_id")
                                        }
                                        if area_name.characters.count > 0 {
                                            UserDefaults.standard.set(area_name, forKey: "area_name")
                                        }
                                        if pos.characters.count > 0 {
                                            UserDefaults.standard.set(pos, forKey: "pos")
                                        }
                                        UserDefaults.standard.synchronize()
                                        
                                        self?.btnCity.setTitle(area_name, for: .normal)
                                    }
                                    
                                }
                            }else{
                                UserDefaults.standard.set("1917", forKey: "area_id")
                                UserDefaults.standard.set("长垣", forKey: "area_name")
                                UserDefaults.standard.synchronize()
                                let alertController = UIAlertController(title: nil, message: result["info"].string ?? "", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: {[weak self] (action) in
                                    let webView = WebViewController(url: AREA_URL + "?lan=&lai=")
                                    self?.navigationController?.pushViewController(webView, animated: true)
                                }))
                                alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
                                    
                                }))
                                self?.present(alertController, animated: true, completion: {
                                    
                                })
                            }
                        })
                    }
                }
                self?._locService.stopUserLocationService()
            }
        }
    }
    
    func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
        print("User Heading")
    }
    
}
