//
//  HomeViewController.swift
//  Fuwan
//
//  Created by ANKER on 2017/11/11.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class HomeViewController: WebViewController {

    //MARK: 系统方法
    override func viewDidLoad() {
        strUrl = PORTAL_URL
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
