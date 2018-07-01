//
//  scheduleDetailVC.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/5/31.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import UIKit

class scheduleDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    var event: eventModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.deleteBtn.layer.borderWidth = 1
        self.deleteBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.deleteBtn.layer.cornerRadius = 3
        self.deleteBtn.layer.masksToBounds = true
        
        self.tableView.reloadData()
    }
    
    @IBAction func doEdit(_ sender: Any) {
        let scheduleEditVC = self.storyboard?.instantiateViewController(withIdentifier: "scheduleEditVC") as! scheduleEditVC
        scheduleEditVC.event = self.event
        self.navigationController?.pushViewController(scheduleEditVC, animated: true)
    }
    
    @IBAction func doDelete(_ sender: Any) {
    }
    
}

extension scheduleDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var eventIsExist = false
        if self.event != nil{
            eventIsExist = true
        }
        switch indexPath.section {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleTitleCell") as! scheduleTitleCell
            if eventIsExist {
                cell.titleLabel.text = self.event!.MEETING_TITLE
            }else {
                cell.titleLabel.text = ""
            }
            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleLocationCell") as! scheduleLocationCell
            if eventIsExist {
                cell.locationLabel.text = self.event!.MEETING_PLACE
            }else {
                cell.locationLabel.text = ""
            }
            return cell
        case 2:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleType_1Cell") as! scheduleType_1Cell
            cell.titleLabel.text = "開始"
            if eventIsExist {
                let startDate = self.event!.startDate.components(separatedBy: "-")
                cell.contentLabel.text = "\(startDate[0])年\(startDate[1])月\(startDate[2])日 \(self.event!.startTime)"
            }else {
                cell.contentLabel.text = ""
            }
            
            return cell
        case 3:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleType_1Cell") as! scheduleType_1Cell
            cell.titleLabel.text = "結束"
            if eventIsExist {
                let endDate = self.event!.endDate.components(separatedBy: "-")
                cell.contentLabel.text = "\(endDate[0])年\(endDate[1])月\(endDate[2])日 \(self.event!.endTime)"
            }else {
                cell.contentLabel.text = ""
            }
            return cell
        case 4:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleType_2Cell") as! scheduleType_2Cell
            cell.titleLabel.text = "專案類型"
            if eventIsExist {
                cell.contentLabel.text = self.event!.P_CLASS
            }else {
                cell.contentLabel.text = ""
            }
            
            return cell
        case 5:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleType_2Cell") as! scheduleType_2Cell
            cell.titleLabel.text = "專案名稱"
            if eventIsExist {
                cell.contentLabel.text = self.event!.P_NAME
            }else {
                cell.contentLabel.text = ""
            }
            
            return cell
        case 6:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleType_2Cell") as! scheduleType_2Cell
            cell.titleLabel.text = "邀請對象"
            if eventIsExist {
                cell.contentLabel.text = self.event!.GUEST
            }else {
                cell.contentLabel.text = ""
            }
            
            return cell
        case 7:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleType_2Cell") as! scheduleType_2Cell
            cell.titleLabel.text = "提示"
            if eventIsExist {
                
            }else {
                
            }
            cell.contentLabel.text = "15分鐘前"
            return cell
        case 8:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleType_2Cell") as! scheduleType_2Cell
            cell.titleLabel.text = "備註"
            cell.accessoryType = .none
            if eventIsExist {
                
            }else {
                
            }
            cell.contentLabel.text = ""
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.tableView.frame.height * 2 / 15
        }else {
            return self.tableView.frame.height * 1 / 15
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10
        case 1:
            return 1
        case 2:
            return 10
        case 3:
            return 1
        case 4:
            return 10
        case 5:
            return 1
        case 6:
            return 1
        case 7:
            return 10
        case 8:
            return 1
        default:
            return 1
        }
    }
}
