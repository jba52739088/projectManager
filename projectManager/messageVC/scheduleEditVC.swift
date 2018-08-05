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
    var projectOption: [Dictionary<String,String>] = []
    var projectClass: [Dictionary<String,String>] = []
    var matchedMembers: [MatchedMember] = []
    var alerts: [Dictionary<String,String>] = [["不設定": "0"], ["5分鐘前": "5"],[ "15分鐘前": "15"], ["30分鐘前": "30"], ["1小時前": "60"], ["2小時前": "120"], ["1天前": "1440"], ["2天前": "2880"]]
    var didSelectAlert = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let footView = UIView()
        self.tableView.tableFooterView = footView
        self.tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getProjectClass()
        self.getMatchedMembers()
        self.tableView.reloadData()
    }
    
    @IBAction func doConfirm(_ sender: Any) {
        self.modifyCalendarRequest(event: self.event!, { (isSucceed, message) in
            if isSucceed {
                self.navigationController?.popToRootViewController(animated: true)
            }else {
                print("message: \(message)")
            }
        })
    }
    
    @IBAction func doCancel(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func getProjectClass() {
        var classArray: [Dictionary<String,String>] = []
        self.projectClassRequest({ (_classes) in
            guard let classes = _classes else { return }
            for _class in classes {
                classArray.append(["PC_NAME": _class["PC_NAME"]!, "PC_ID": _class["PC_ID"]!])
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
            self.event!.C_DATE_START = formatter.string(from: self.timePicker.date)
            let _date = formatter.string(from: self.timePicker.date).components(separatedBy: " ")[0]
            let _time = formatter.string(from: self.timePicker.date).components(separatedBy: " ")[1]
            self.event!.startDate = _date
            self.event!.startTime = _time
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
            self.event!.C_DATE_END = formatter.string(from: self.timePicker.date)
            let _date = formatter.string(from: self.timePicker.date).components(separatedBy: " ")[0]
            let _time = formatter.string(from: self.timePicker.date).components(separatedBy: " ")[1]
            self.event!.endDate = _date
            self.event!.endTime = _time
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
            
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    
    @objc func titleTextFieldDidChange(_ textField: UITextField) {
        guard let title = textField.text else { return }
        self.event!.MEETING_TITLE = title
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
    }
    
    @objc func placeTextFieldDidChange(_ textField: UITextField) {
        guard let place = textField.text else { return }
        self.event!.MEETING_PLACE = place
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
    }
    
    @objc func projectNameTextFieldDidChange(_ textField: UITextField) {
        guard let projectName = textField.text else { return }
        self.event!.P_NAME = projectName
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
    }
    
    @objc func infoTextFieldDidChange(_ textField: UITextField) {
        guard let info = textField.text else { return }
        self.event!.MEETING_INFO = info
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
    }
    
    func showClassSelectionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for _class in self.projectClass {
            alert.addAction(UIAlertAction(title: _class["PC_NAME"]!, style: .default, handler: { (_) in
                self.event!.P_CLASS = _class["PC_NAME"]!
                self.projectOptionRequest(pcid: _class["PC_ID"]!, { (_options) in
                    var optionArray: [Dictionary<String,String>] = []
                    guard let options = _options else { return }
                    for _option in options {
                        optionArray.append(["P_ID": _option["P_ID"]!, "P_NAME": _option["P_NAME"]!])
                    }
                    self.projectOption = optionArray
                })
                UIView.performWithoutAnimation {
                    self.tableView.reloadData()
                }
            }))
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            self.event!.P_CLASS = ""
            self.projectOption = []
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
                self.event!.M_ID = member.M_SN
                self.event!.GUEST = member.M_NAME
                UIView.performWithoutAnimation {
                    self.tableView.reloadData()
                }
            }))
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            self.event!.M_ID = "-1"
            self.event!.GUEST = ""
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
        }))
        self.presentAlert(alert, animated: true)
    }
    
    func showOptionsSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for _option in self.projectOption {
            alert.addAction(UIAlertAction(title: _option["P_NAME"]!, style: .default, handler: { (_) in
                self.event!.P_ID = _option["P_ID"]!
                self.event!.P_NAME = _option["P_NAME"]!
                UIView.performWithoutAnimation {
                    self.tableView.reloadData()
                }
            }))
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            self.event!.P_NAME = ""
            self.event!.P_ID = ""
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
        }))
        self.presentAlert(alert, animated: true)
    }
    
    func showAlertsSelectionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for _alert in self.alerts {
            alert.addAction(UIAlertAction(title: _alert.keys.first, style: .default, handler: { (_) in
                self.event!.NOTICE = _alert.values.first!
                self.didSelectAlert = _alert.keys.first!
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

extension scheduleEditVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let View = UIView()
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
            cell.textField.addTarget(self, action: #selector(self.titleTextFieldDidChange(_:)), for: UIControlEvents.editingDidEnd)
            cell.textField.placeholder = "標題"
            cell.label.text = "標題"
            if self.event!.MEETING_TITLE != "" {
                cell.textField.text = self.event!.MEETING_TITLE
            }else {
                cell.textField.text = nil
            }
            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleEditCell") as! scheduleEditlCell
            cell.textField.placeholder = "位置"
            cell.label.text = "位置"
            cell.textField.addTarget(self, action: #selector(self.placeTextFieldDidChange(_:)), for: UIControlEvents.editingDidEnd)
            if event!.MEETING_PLACE != "" {
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
            if event!.P_CLASS != "" {
                cell.contentLabel.text = self.event!.P_CLASS
            }else {
                cell.contentLabel.text = ""
            }
            
            return cell
        case 5:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleType_2Cell") as! scheduleType_2Cell
            cell.titleLabel.text = "專案名稱"
            if event!.P_NAME != "" {
                cell.contentLabel.text = self.event!.P_NAME
            }else {
                cell.contentLabel.text = nil
            }
            return cell
        case 6:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleType_2Cell") as! scheduleType_2Cell
            cell.titleLabel.text = "邀請對象"
            if event!.M_ID != "-1" && event!.GUEST != "" {
                cell.contentLabel.text = self.event!.GUEST
            }else {
                cell.contentLabel.text = ""
            }
            
            return cell
        case 7:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleType_2Cell") as! scheduleType_2Cell
            cell.titleLabel.text = "提示"
            if self.event!.NOTICE != "" {
                cell.contentLabel.text = getAlertString(time: self.event!.NOTICE)
            }else {
                cell.contentLabel.text = ""
            }
            return cell
        case 8:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleEditCell") as! scheduleEditlCell
            cell.textField.placeholder = "備註"
            cell.label.text = "備註"
            cell.textField.addTarget(self, action: #selector(self.infoTextFieldDidChange(_:)), for: UIControlEvents.editingDidEnd)
            if event!.MEETING_INFO != "" {
                cell.textField.text = self.event!.MEETING_INFO
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
            self.showOptionsSheet()
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
    
    func getAlertString(time: String) -> String {
        switch time {
        case "0":
            return "不設定"
        case "5":
            return "5分鐘前"
        case "15":
            return "15分鐘前"
        case "30":
            return "30分鐘前"
        case "60":
            return "1小時前"
        case "120":
            return "2小時前"
        case "1440":
            return "1天前"
        case "2880":
            return "2天前"
            
        default:
            return "不設定"
        }
    }
}

