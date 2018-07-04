//
//  didAddVC.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/7/5.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import UIKit

class didAddVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addShopBtn: UIBarButtonItem!
    
    var matchedMembers: [MatchedMember] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getMatchedMembers()
        
    }

    @IBAction func tapAddShopBtn(_ sender: Any) {
        
    }
    
    func getMatchedMembers() {
        self.matchedMemberRequest { (_members) in
            guard let members = _members else { return }
            self.matchedMembers = members
            self.tableView.reloadData()
        }
    }
    
}

extension didAddVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchedMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.selectionStyle = .none
        cell.textLabel?.text = self.matchedMembers[indexPath.row].M_NAME
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
