//
//  SearchViewController.swift
//  Fuwan
//
//  Created by ANKER on 2017/9/30.
//  Copyright © 2017年 zxf. All rights reserved.
//

import UIKit

class ZSearchViewController: UIViewController, UISearchBarDelegate {
    
    var searchBar : UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 250, height: 30)
        titleView.backgroundColor = UIColor.white
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        searchBar.placeholder = "请输入您想要搜索的内容"
        if let textfield = searchBar.value(forKey: "_searchField") as? UITextField {
            textfield.setValue(UIFont.systemFont(ofSize: 15), forKeyPath: "_placeholderLabel.font")
        }
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.white
        searchBar.delegate = self
        titleView.layer.cornerRadius = 15
        titleView.clipsToBounds = true
        titleView.addSubview(searchBar)
        self.navigationItem.titleView = titleView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.characters.count > 0 {
            
            let webView = WebViewController(url: SEARCH_URL + "\(text)")
            webView.title = "搜索结果"
            self.navigationController?.pushViewController(webView, animated: true)
        }
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
