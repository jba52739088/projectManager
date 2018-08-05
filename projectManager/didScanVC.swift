//
//  didScanVC.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/7/5.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import UIKit

class didScanVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var didApplyLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    
    var memberName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getSelfInfoRequest { (selfName) in
            self.title = selfName
        }
        
        self.headerLabel.layer.borderColor = UIColor.black.cgColor
        self.headerLabel.layer.borderWidth = 2
        
        
        guard memberName != nil else { return }
        self.headerLabel.text = memberName!
        let actionString = "待「\(memberName!)」審核後加入"
        let mutableString = NSMutableAttributedString(string: actionString, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)])
        mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:2,length:memberName!.count))
        actionLabel.attributedText = mutableString
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    

}
