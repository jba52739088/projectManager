//
//  scheduleAddVC.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/7/3.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import UIKit

class scheduleAddVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmBtn: UIBarButtonItem!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    let timePicker = UIDatePicker()
    
    var event: eventModel!
    var projectClass: [String] = []
    var matchedMembers: [MatchedMember] = []
    var alerts = ["5分鐘前": 5, "15分鐘前": 15, "30分鐘前": 30, "1小時前": 60, "2小時前": 120, "1天前": 1440, "2天前": 2880]
    var didSelectAlert = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let _date = formatter.string(from: date).components(separatedBy: " ")[0]
        let _time = formatter.string(from: date).components(separatedBy: " ")[1]
        let currentTime = _date + "T" + _time
        self.event = eventModel(CE_ID: "", M_ID: "-1", P_ID: "", OWNER_ID: "", GUEST: "", P_NAME: "", P_CLASS: "", C_DATE_START: currentTime, C_DATE_END: currentTime, MEETING_TYPE: "", MEETING_TITLE: "", MEETING_PLACE: "", MEETING_INFO: "", STATUS: 1, SIDE: "")
        
        let footView = UIView()
        footView.backgroundColor = UIColor.lightGray
        self.tableView.tableFooterView = footView
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.lightGray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getProjectClass()
        self.getMatchedMembers()
        self.tableView.reloadData()
    }
    
    @IBAction func doConfirm(_ sender: Any) {
        
        
        self.checkScheduleRequest(m_id: self.event.M_ID, startDate: self.event.startDate, startHour: self.event.startTime.components(separatedBy: ":")[0], startMinute: self.event.startTime.components(separatedBy: ":")[1], endDate: self.event.endDate, endHour: self.event.endTime.components(separatedBy: ":")[0], endMinute: self.event.endTime.components(separatedBy: ":")[1]) { (isSucceed) in
            
            if isSucceed {
                print("okok")
                self.insertCalendarRequest(event: self.event, { (isSucceed, message) in
                    if isSucceed {
                        self.navigationController?.popToRootViewController(animated: true)
                    }else {
                        print("22222")
                    }
                })
            }
        }
    }
    
    @IBAction func doCancel(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func getProjectClass() {
        var classArray: [String] = []
        self.projectClassRequest({ (_classes) in
            guard let classes = _classes else { return }
            for _class in classes {
                classArray.append(_class["PC_NAME"]!)
            }
            self.projectClass = classArray
        })
    }
    
    func getMatchedMembers() {
        self.matchedMemberRequest { (_members) in
            guard let members = _members else { return }
            self.matchedMembers = members
        }
    }
    
    func startTimePicker()  {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        timePicker.datePickerMode = UIDatePickerMode.dateAndTime
        timePicker.frame = CGRect(x: 0, y: 0, width: 250, height: 300)
        timePicker.backgroundColor = UIColor.white
        vc.view.addSubview(timePicker)
        let editRadiusAlert = UIAlertController(title: "選擇日期", message: "", preferredStyle: UIAlertControllerStyle.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (_) in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            self.event.C_DATE_START = formatter.string(from: self.timePicker.date)
            let _date = formatter.string(from: self.timePicker.date).components(separatedBy: " ")[0]
            let _time = formatter.string(from: self.timePicker.date).components(separatedBy: " ")[1]
            self.event.startDate = _date
            self.event.startTime = _time
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
            
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    
    func endTimePicker()  {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        timePicker.datePickerMode = UIDatePickerMode.dateAndTime
        timePicker.frame = CGRect(x: 0, y: 0, width: 250, height: 300)
        timePicker.backgroundColor = UIColor.white
        vc.view.addSubview(timePicker)
        let editRadiusAlert = UIAlertController(title: "選擇日期", message: "", preferredStyle: UIAlertControllerStyle.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (_) in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            self.event.C_DATE_END = formatter.string(from: self.timePicker.date)
            let _date = formatter.string(from: self.timePicker.date).components(separatedBy: " ")[0]
            let _time = formatter.string(from: self.timePicker.date).components(separatedBy: " ")[1]
            self.event.endDate = _date
            self.event.endTime = _time
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
            
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    
    @objc func titleTextFieldDidChange(_ textField: UITextField) {
        guard let title = textField.text else { return }
        self.event.MEETING_TITLE = title
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
    }
    
    @objc func placeTextFieldDidChange(_ textField: UITextField) {
        guard let place = textField.text else { return }
        self.event.MEETING_PLACE = place
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
    }
    
    @objc func projectNameTextFieldDidChange(_ textField: UITextField) {
        guard let projectName = textField.text else { return }
        self.event.P_NAME = projectName
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
    }
    
    @objc func infoTextFieldDidChange(_ textField: UITextField) {
        guard let info = textField.text else { return }
        self.event.MEETING_INFO = info
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
    }
    
    func showClassSelectionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for _class in self.projectClass {
            alert.addAction(UIAlertAction(title: _class, style: .default, handler: { (_) in
                self.event.P_CLASS = _class
                UIView.performWithoutAnimation {
                    self.tableView.reloadData()
                }
            }))
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            self.event.P_CLASS = ""
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
        }))
        self.presentAlert(alert, animated: true)
    }
    
    func showMembersSelectionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for member in self.matchedMembers {
            alert.addAction(UIAlertAction(title: member.M_NAME, style: .default, handler: { (_) in
                self.event.M_ID = member.M_SN
                self.event.GUEST = member.M_NAME
                UIView.performWithoutAnimation {
                    self.tableView.reloadData()
                }
            }))
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            self.event.M_ID = "-1"
            self.event.GUEST = ""
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
        }))
        self.presentAlert(alert, animated: true)
    }
    
    func showAlertsSelectionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for _alert in self.alerts {
            alert.addAction(UIAlertAction(title: _alert.key, style: .default, handler: { (_) in
                self.didSelectAlert = _alert.key
                UIView.performWithoutAnimation {
                    self.tableView.reloadData()
                }
            }))
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            self.didSelectAlert = ""
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
        }))
        self.presentAlert(alert, animated: true)
    }
}

extension scheduleAddVC: UITableViewDelegate, UITableViewDataSource {
    
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

        switch indexPath.section {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleEditCell") as! scheduleEditlCell
            cell.scheduleAddVC = self
            cell.textField.addTarget(self, action: #selector(self.titleTextFieldDidChange(_:)), for: UIControlEvents.editingDidEnd)
            cell.textField.placeholder = "標題"
            if event.MEETING_TITLE != "" {
                cell.textField.text = self.event.MEETING_TITLE
            }else {
                cell.textField.text = nil
            }
            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleEditCell") as! scheduleEditlCell
            cell.textField.placeholder = "位置"
            cell.scheduleAddVC = self
            cell.textField.addTarget(self, action: #selector(self.placeTextFieldDidChange(_:)), for: UIControlEvents.editingDidEnd)
            if event.MEETING_PLACE != "" {
                cell.textField.text = self.event.MEETING_PLACE
            }else {
                cell.textField.text = nil
            }
            return cell
        case 2:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleType_1Cell") as! scheduleType_1Cell
            cell.titleLabel.text = "開始"
            if event.C_DATE_START != "" {
                let startDate = self.event!.startDate.components(separatedBy: "-")
                cell.contentLabel.text = "\(startDate[0])年\(startDate[1])月\(startDate[2])日 \(self.event!.startTime)"
            }else {
                cell.contentLabel.text = nil
            }
            
            return cell
        case 3:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleType_1Cell") as! scheduleType_1Cell
            cell.titleLabel.text = "結束"
            if event.C_DATE_END != "" {
                let endDate = self.event!.endDate.components(separatedBy: "-")
                cell.contentLabel.text = "\(endDate[0])年\(endDate[1])月\(endDate[2])日 \(self.event!.endTime)"
            }else {
                cell.contentLabel.text = nil
            }
            return cell
        case 4:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleType_2Cell") as! scheduleType_2Cell
            cell.titleLabel.text = "專案類型"
            if event.P_CLASS != "" {
                cell.contentLabel.text = self.event.P_CLASS
            }else {
                cell.contentLabel.text = ""
            }
            
            return cell
        case 5:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleEditCell") as! scheduleEditlCell
            cell.scheduleAddVC = self
            cell.textField.addTarget(self, action: #selector(self.projectNameTextFieldDidChange(_:)), for: UIControlEvents.editingDidEnd)
            cell.textField.placeholder = "專案名稱"
            if event.P_NAME != "" {
                cell.textField.text = self.event.P_NAME
            }else {
                cell.textField.text = nil
            }
            return cell
        case 6:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleType_2Cell") as! scheduleType_2Cell
            cell.titleLabel.text = "邀請對象"
            if event.M_ID != "-1" && event.GUEST != "" {
                cell.contentLabel.text = self.event.GUEST
            }else {
                cell.contentLabel.text = ""
            }
            return cell
        case 7:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleType_2Cell") as! scheduleType_2Cell
            cell.titleLabel.text = "提示"
            if self.didSelectAlert != "" {
                cell.contentLabel.text = self.didSelectAlert
            }else {
                cell.contentLabel.text = ""
            }
            return cell
        case 8:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleEditCell") as! scheduleEditlCell
            cell.textField.placeholder = "備註"
            cell.textField.addTarget(self, action: #selector(self.infoTextFieldDidChange(_:)), for: UIControlEvents.editingDidEnd)
            if event.MEETING_INFO != "" {
                cell.textField.text = self.event.MEETING_INFO
            }else {
                cell.textField.text = nil
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
            self.startTimePicker()
            return
        case 3:
            self.endTimePicker()
            return
        case 4:
            self.showClassSelectionSheet()
            return
        case 5:
            return
        case 6:
            self.showMembersSelectionSheet()
            return
        case 7:
            self.showAlertsSelectionSheet()
            return
        case 8:
            return
        default:
            return
        }
    }
}

extension UIViewController {
    
    func presentAlert(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)? = nil) {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            
            if let currentPopoverpresentioncontroller = viewControllerToPresent.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = self.view
                currentPopoverpresentioncontroller.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                currentPopoverpresentioncontroller.permittedArrowDirections = []
                self.present(viewControllerToPresent, animated: true, completion: nil)
            }
        }else{
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
}



