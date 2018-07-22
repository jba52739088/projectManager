//
//  scheduleEditVC.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/6/24.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import UIKit

class scheduleEditVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmBtn: UIBarButtonItem!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    let timePicker = UIDatePicker()
    
    var event: eventModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let footView = UIView()
        footView.backgroundColor = UIColor.lightGray
        self.tableView.tableFooterView = footView
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.lightGray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    
    @IBAction func doConfirm(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func doCancel(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func openTimePicker()  {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        timePicker.datePickerMode = UIDatePickerMode.dateAndTime
        timePicker.frame = CGRect(x: 0, y: 0, width: 250, height: 300)
        timePicker.backgroundColor = UIColor.white
//        timePicker.addTarget(self, action: #selector(self.startTimeDiveChanged), for: UIControlEvents.valueChanged)
        vc.view.addSubview(timePicker)
        let editRadiusAlert = UIAlertController(title: "選擇日期", message: "", preferredStyle: UIAlertControllerStyle.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        editRadiusAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    
    @objc func startTimeDiveChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        print(formatter.string(from: sender.date))
        timePicker.removeFromSuperview() // if you want to remove time picker
    }
}

extension scheduleEditVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let View = UIView()
        View.backgroundColor = UIColor.lightGray
        return View
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var eventIsExist = false
        if self.event != nil{
            eventIsExist = true
        }
        switch indexPath.section {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleEditCell") as! scheduleEditlCell
            cell.textField.placeholder = "標題"
            if eventIsExist {
                cell.textField.text = self.event!.MEETING_TITLE
            }else {
                cell.textField.text = nil
            }
            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleEditCell") as! scheduleEditlCell
            cell.textField.placeholder = "位置"
            if eventIsExist {
                cell.textField.text = self.event!.MEETING_PLACE
            }else {
                cell.textField.text = nil
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
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleEditCell") as! scheduleEditlCell
            cell.textField.placeholder = "備註"
            if eventIsExist {
                cell.textField.text = ""
            }else {
                cell.textField.text = nil
            }
            if eventIsExist {
                
            }else {
                
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.tableView.frame.height * 1 / 15
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            return
        case 2:
            self.openTimePicker()
            return
        case 3:
            //
            return
        case 4:
            self.projectClassRequest({ (_classes) in
                //
            })
        case 5:
            return
        case 6:
            return
        case 7:
            return
        case 8:
            return
        default:
            return
        }
    }
}

