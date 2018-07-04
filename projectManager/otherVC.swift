//
//  otherVC.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/5/29.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import UIKit

class otherVC: UIViewController {
    
    @IBOutlet weak var msgBtn: UIButton!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var topupBtn: UIButton!
    @IBOutlet weak var willBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.title = "其他功能"
    }

    @IBAction func tapMessageBtn(_ sender: Any) {
    }
    
    @IBAction func tapScanBtn(_ sender: Any) {
    }
    
    @IBAction func tapTopupBtn(_ sender: Any) {
    }
    
    @IBAction func tapWillBtn(_ sender: Any) {
    }
}
