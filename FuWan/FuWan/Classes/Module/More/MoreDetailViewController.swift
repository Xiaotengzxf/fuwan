//
//  MoreDetailViewController.swift
//  Fuwan
//
//  Created by ANKER on 2017/11/12.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class MoreDetailViewController: WebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backItemImage"), style: .plain, target: self, action: #selector(self.dismissForBack))
        let account = NTESAccount()
        NTESLoginManager.shared().loginUser(account) { (error) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dismissForBack() {
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
