//
//  NetworkTools.swift
//  someone
//
//  Created by zxf on 2017/4/25.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import QorumLogs


typealias FinishedOperation = (_ success:Bool,_ result:JSON?,_ error:Error?) ->()

class NetworkTools: NSObject {
    static let shared = NetworkTools()

}

//MARK: 基本请求方法
extension NetworkTools {
    /** 
     handle处理响应结果
    
    - Parameters:
    - response: 响应对象
    - finished: 完成回调
    */
    fileprivate func handle(response: DataResponse<Any>, finished: @escaping FinishedOperation) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        switch response.result {
        case .success(let value):
            QL1(value)
            let json = JSON(value)
            finished(true, json, nil)
        case .failure(let error):
            finished(false, nil, error as NSError?)
        }
        
    }
    
    /**
     GET请求
     
     - parameter urlString:  urlString
     - parameter parameters: 参数
     - parameter finished:   完成回调
     */
    func get(_ url:String,parameters:[String:Any]?,finished:@escaping FinishedOperation) {
        //: 显示网络活动状态
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
        Alamofire.request(jointUrl(url: url), method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            self.handle(response: response, finished: finished)
        }.responseString { (response) in
            print("返回内容：\(response.result.value)")
        }
    }
    
    /**
     POST请求
     
     - parameter urlString:  urlString
     - parameter parameters: 参数
     - parameter finished:   完成回调
     */
    
    func post(_ url:String,parameters: [String : Any]?, headers: HTTPHeaders? = nil, finished: @escaping FinishedOperation ) {
        //: 显示网络活动状态
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Alamofire.request(jointUrl(url: url), method: .post, parameters: parameters, encoding: URLEncoding.default, headers:headers).responseJSON { (response) in
            self.handle(response: response, finished: finished)
            }.responseString { (response) in
                print("返回内容：\(response.result.value)")
        }
    }
    
    func jointUrl(url: String) -> String {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let area_id = UserDefaults.standard.string(forKey: "area_id") ?? ""
        let loc_area_id = UserDefaults.standard.string(forKey: "loc_area_id") ?? ""
        let pos = UserDefaults.standard.string(forKey: "pos") ?? ""
        return url + "?token=\(token)&area_id=\(area_id)&loc_area_id=\(loc_area_id)&pos=\(pos)"
    }
}
