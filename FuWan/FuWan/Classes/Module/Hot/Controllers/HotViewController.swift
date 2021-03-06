//
//  HotViewController.swift
//  someone
//
//  Created by zxf on 2017/4/15.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit
import WebKit

class HotViewController: WebViewController {

//MARK: 系统方法
    override func viewDidLoad() {
        strUrl = CATEGORY_URL
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
