//
//  messageVC.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/5/29.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import UIKit

class messageVC: UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
    }

    @IBAction func switchSegment(_ sender: Any) {
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
        
    }
    
}

extension messageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.segment.selectedSegmentIndex == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! msgCell
            
            return cell
        }else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "newsCell") as! newsCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scheduleDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "scheduleDetailVC") as! scheduleDetailVC
        self.navigationController?.pushViewController(scheduleDetailVC, animated: true)
    }
}
