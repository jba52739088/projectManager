//
//  apiMananger.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/6/16.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

let appDelegate = UIApplication.shared.delegate as! AppDelegate

extension UIViewController {
    
    // 登入
    func loginRequest(account: String, password: String, _ completionHandler: @escaping (Bool) -> Void) {
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/Login/\(account)/\(password)"
        Alamofire.request(url).responseJSON { (response) -> Void in
            if let JSON = response.result.value as? Dictionary<String,AnyObject> {
                if let Result = JSON["Result"] as? Bool,
                    let token = JSON["token"] as? String{
                    if Result {
                        appDelegate.token = token
                      completionHandler(true)
//                        self.calendarRequest(from: "", end: "", { (_) in
//                            print("123")
//                        })
                    }else {
                      completionHandler(false)
                    }
                }
            }else {
                print("loginRequest: get JSON error")
            }
        }
    }
    
    // 註冊
    func registerRequest(account: String, password: String, name: String, ID: String, address: String, phone: String, cellphone: String, mail: String, _ completionHandler: @escaping (Bool, String) -> Void){
        let parameters = ["M_SN":ID, "M_ACCOUNT":account, "M_PASSWORD":password, "M_NAME":name, "M_TYPE":"C", "M_GENDER":"M", "M_ADDRESS":address, "M_TEL_D":phone, "M_MAIL":mail] as [String : Any]
        Alamofire.request("http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/AddCustomer", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let JSON = response.result.value as? [String:AnyObject] {
                    if let result = JSON["result"] as? Bool,
                       let msg = JSON["msg"] as? String{
                        if result {
                            completionHandler(true, "")
                        }else {
                            completionHandler(false, msg)
                        }
                    }
                }else {
                    print("registerRequest: get JSON error")
                }
        }
    }
    
    // 取得行事曆
    func calendarRequest(from: String, end: String, _ completionHandler: @escaping ([eventModel]?) -> Void) {
        var allEvents: [eventModel] = []
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/GetCalendar/\(from)/\(end)"
        let headers = ["Authorization": "Bearer \(token)"]
        Alamofire.request(url, headers: headers).responseJSON { (response) -> Void in
            if let results = response.result.value as? [Dictionary<String,AnyObject>] {
                for result in results {
                    let aEvent = eventModel(CE_ID: result["CE_ID"] as? String ?? "",
                                            M_ID: result["M_ID"] as? String ?? "",
                                            P_ID: result["P_ID"] as? String ?? "",
                                            OWNER_ID: result["OWNER_ID"] as? String ?? "",
                                            GUEST: result["GUEST"] as? String ?? "",
                                            P_NAME: result["P_NAME"] as? String ?? "",
                                            P_CLASS: result["P_CLASS"] as? String ?? "",
                                            C_DATE_START: result["C_DATE_START"] as? String ?? "",
                                            C_DATE_END: result["C_DATE_END"] as? String ?? "",
                                            MEETING_TYPE: result["MEETING_TYPE"] as? String ?? "",
                                            MEETING_TITLE: result["MEETING_TITLE"] as? String ?? "",
                                            MEETING_PLACE: result["MEETING_PLACE"] as? String ?? "",
                                            MEETING_INFO: result["MEETING_INFO"] as? String ?? "",
                                            STATUS: result["STATUS"] as? Int ?? 0,
                                            SIDE: result["SIDE"] as? String ?? "")
                    allEvents.append(aEvent)
                }
                completionHandler(allEvents)
            }else {
                print("calendarRequest: get JSON error")
            }
        }
    }
    
    // 取得專案類別
    func projectClassRequest(_ completionHandler: @escaping ([Dictionary<String,String>]?) -> Void) {
        var allClasses: [Dictionary<String,String>] = []
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/Project/GetProjectClass/"
        let headers = ["Authorization": "Bearer \(token)"]
        Alamofire.request(url, headers: headers).responseJSON { (response) -> Void in
            if let results = response.result.value as? [Dictionary<String,String>] {
                for result in results {
                    guard let PC_ID = result["PC_ID"] as? String,           //  ID
                          let PC_NAME = result["PC_NAME"] as? String,       //  類別名稱
                          let PC_UPD = result["PC_UPD"] as? String          //  類別更新時間
                        else { return }
                    var _class: Dictionary<String,String> = [:]
                    _class["PC_ID"] = PC_ID
                    _class["PC_NAME"] = PC_NAME
                    _class["PC_UPD"] = PC_UPD
                    allClasses.append(_class)
                }
                completionHandler(allClasses)
            }else {
                print("projectClassRequest: get JSON error")
            }
        }
    }

    // 取得邀請對象
    func matchedMemberRequest(_ completionHandler: @escaping ([MatchedMember]?) -> Void) {
        var allmatchedMembers: [MatchedMember] = []
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/GetMatchedMember/"
        let headers = ["Authorization": "Bearer \(token)"]
        Alamofire.request(url, headers: headers).responseJSON { (response) -> Void in
            if let results = response.result.value as? [Dictionary<String,AnyObject>] {
                for result in results {
                    guard let R_ID = result["R_ID"] as? String,
                          let MyName = result["MyName"] as? String,
                          let M_ACCOUNT = result["M_ACCOUNT"] as? String,
                          let M_SN = result["M_SN"] as? String,
                          let M_NAME = result["M_NAME"] as? String,
                          let Status = result["Status"] as? Int,
                          let isHost = result["isHost"] as? Bool
                        else { return }
                    let aMatchedMember = MatchedMember(R_ID: R_ID, MyName: MyName, M_ACCOUNT: M_ACCOUNT, M_SN: M_SN, M_NAME: M_NAME, Status: Status, isHost: isHost)
                    allmatchedMembers.append(aMatchedMember)
                }
                completionHandler(allmatchedMembers)
            }else {
                print("matchedMemberRequest: get JSON error")
            }
        }
    }
    
    // 檢查是否衝突
    func checkScheduleRequest(m_id: String, startDate: String, startHour: String, startMinute: String, endDate: String, endHour: String, endMinute: String, _ completionHandler: @escaping (Bool) -> Void) {
        var allmatchedMembers: [MatchedMember] = []
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/GetOverlapCalendar/\(m_id)/\(startDate)/\(startHour)/\(startMinute)/\(endDate)/\(endHour)/\(endMinute)"
        let headers = ["Authorization": "Bearer \(token)"]
        Alamofire.request(url, headers: headers).responseJSON { (response) -> Void in
            if let results = response.result.value as? Array<Any> {
                if results.count == 0 {
                    completionHandler(true)
                }
            }else if let result = response.result.value as? Bool{
                if result == false {
                    completionHandler(true)
                }
            }else {
                print("checkScheduleRequest: get JSON error")
            }
        }
    }
    
    // 新增行程
    func insertCalendarRequest(event: eventModel, _ completionHandler: @escaping (Bool, String) -> Void){
        guard let token = appDelegate.token else { return }
        let headers = ["Authorization": "Bearer \(token)"]
        let start_hour = event.startTime.components(separatedBy: ":")[0]
        let start_minute = event.startTime.components(separatedBy: ":")[1]
        let end_hour = event.endTime.components(separatedBy: ":")[0]
        let end_minute = event.endTime.components(separatedBy: ":")[1]
        let C_DATE_START = event.C_DATE_START.components(separatedBy: "T")[0]
        let C_DATE_END = event.C_DATE_END.components(separatedBy: "T")[0]
        let parameters = ["m_id":event.M_ID, "p_id":event.P_ID, "C_DATE_START":C_DATE_START, "start_hour":start_hour, "start_minute":start_minute, "C_DATE_END":C_DATE_END, "end_hour":end_hour, "end_minute":end_minute, "meeting_title":event.MEETING_TITLE, "meeting_place":event.MEETING_PLACE] as [String : Any]
        
        Alamofire.request("http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/InsertCalendar", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                if let JSON = response.result.value as? [String:AnyObject] {
                    if let result = JSON["result"] as? Bool,
                        let msg = JSON["msg"] as? String{
                        if result {
                            completionHandler(true, "")
                        }else {
                            completionHandler(false, msg)
                        }
                    }
                }else {
                    print("registerRequest: get JSON error")
                }
        }
    }
}
