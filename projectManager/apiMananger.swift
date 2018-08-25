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
        let parameters = ["M_ROCID":ID, "M_ACCOUNT":account, "M_PASSWORD":password, "M_NAME":name, "M_TYPE":"C", "M_GENDER":"M", "M_ADDRESS":address, "M_TEL_D":phone, "M_MAIL":mail] as [String : Any]
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
    
    // 取得自己會員資料
    func getSelfInfoRequest(_ completionHandler: @escaping (String?) -> Void) {
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/GetMember/"
        let headers = ["Authorization": "Bearer \(token)"]
        Alamofire.request(url, headers: headers).responseJSON { (response) -> Void in
            if let results = response.result.value as? Dictionary<String,AnyObject> {
                let selfName = results["M_NAME"] as? String ?? ""
                completionHandler(selfName)
            }else {
                print("getIDbyTokenRequest: get JSON error")
            }
        }
    }
    
    // 取得收件夾的括號數量
    func getInboxNumRequest(_ completionHandler: @escaping (Int?) -> Void) {
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/GetInboxNum/false"
        let headers = ["Authorization": "Bearer \(token)"]
        Alamofire.request(url, headers: headers).responseJSON { (response) -> Void in
            if let results = response.result.value as? Int {
                completionHandler(results)
            }else {
                print("getIDbyTokenRequest: get JSON error")
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
                                            SIDE: result["SIDE"] as? String ?? "",
                                            NOTICE: result["NOTICE"] as? String ?? "0")
                    allEvents.append(aEvent)
                }
                completionHandler(allEvents)
            }else {
                print("calendarRequest: get JSON error")
            }
        }
    }
    
    // 搜尋行事曆
    func searchCalendarRequest(m_name: String, b_mid: String, from: String, end: String, _ completionHandler: @escaping ([eventModel]?) -> Void) {
        var allEvents: [eventModel] = []
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/SearchCalendar/"
        let headers = ["Authorization": "Bearer \(token)"]
        let parameters = ["m_name":m_name, "b_mid":b_mid, "start_date":from, "end_date":end] as [String : Any]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
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
                                                SIDE: result["SIDE"] as? String ?? "",
                                                NOTICE: result["NOTICE"] as? String ?? "0")
                        allEvents.append(aEvent)
                    }
                    completionHandler(allEvents)
                }else {
                    print("searchCalendarRequest: get JSON error")
                }
        }
    }
    
    func searchCalendarRequest(keyword: String, b_mid: String, from: String, end: String, _ completionHandler: @escaping ([eventModel]?) -> Void) {
        var allEvents: [eventModel] = []
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/SearchCalendar/"
        let headers = ["Authorization": "Bearer \(token)"]
        let parameters = ["keyword":keyword, "b_mid":b_mid, "start_date":from, "end_date":end] as [String : Any]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
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
                                                SIDE: result["SIDE"] as? String ?? "",
                                                NOTICE: result["NOTICE"] as? String ?? "0")
                        allEvents.append(aEvent)
                    }
                    completionHandler(allEvents)
                }else {
                    print("searchCalendarRequest: get JSON error")
                }
        }
    }
    
    // 刪除行事曆
    func deleteCalendarRequest(ceid: String, _ completionHandler: @escaping (Bool, String) -> Void) {
        var allEvents: [eventModel] = []
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/DeleteCalendar/"
        let headers = ["Authorization": "Bearer \(token)"]
        let parameters = ["ce_id":ceid] as [String : Any]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
                    print("deleteCalendarRequest: get JSON error")
                }
        }
    }
    
    // 取得專案bookinglistlist
    func bookinglistlistRequest(m_id: String, year: String, month: String, day: String, _ completionHandler: @escaping ([String]?) -> Void) {
        var list: [String] = []
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/GetFreeTime/\(m_id)/\(year)-\(month)-\(day)"
        let headers = ["Authorization": "Bearer \(token)"]
        Alamofire.request(url, headers: headers).responseJSON { (response) -> Void in
            if let results = response.result.value as? [Dictionary<String,AnyObject>] {
                for result in results {
                    guard let SH = result["start_hour"] as? Int,
                        let EH = result["end_hour"] as? Int,
                        let SM = result["start_min"] as? Int,
                        let EM = result["end_min"] as? Int
                        else { return }
                    let time = String(format: "%02d%02d-%02d%02d", SH, SM, EH, EM)
                    list.append(time)
                }
                completionHandler(list)
            }else {
                print("projectClassRequest: get JSON error")
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
    // 取得已加入商家
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
    
    // 取得專案選項
    func projectOptionRequest(pcid: String, _ completionHandler: @escaping ([Dictionary<String,String>]?) -> Void) {
        var allClasses: [Dictionary<String,String>] = []
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/Project/GetProjectListbyClass/\(pcid)"
        let headers = ["Authorization": "Bearer \(token)"]
        Alamofire.request(url, headers: headers).responseJSON { (response) -> Void in
            if let results = response.result.value as? [Dictionary<String,String>] {
                for result in results {
                    guard let P_ID = result["P_ID"] as? String,           //  ID
                        let P_NAME = result["P_NAME"] as? String         //  類別名稱
                        else { return }
                    var _class: Dictionary<String,String> = [:]
                    _class["P_ID"] = P_ID
                    _class["P_NAME"] = P_NAME
                    allClasses.append(_class)
                }
                completionHandler(allClasses)
            }else {
                print("projectClassRequest: get JSON error")
            }
        }
    }
    
    // 檢查是否衝突
    func checkScheduleRequest(m_id: String, startDate: String, startHour: String, startMinute: String, endDate: String, endHour: String, endMinute: String, _ completionHandler: @escaping (Bool, [Dictionary<String,String>]?) -> Void) {
        var allmatchedMembers: [MatchedMember] = []
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/GetOverlapCalendar/\(m_id)/\(startDate)/\(startHour)/\(startMinute)/\(endDate)/\(endHour)/\(endMinute)"
        let headers = ["Authorization": "Bearer \(token)"]
        Alamofire.request(url, headers: headers).responseJSON { (response) -> Void in
            if let results = response.result.value as? Array<Any>, results.count == 0{
                if results.count == 0 {
                    completionHandler(true, nil)
                }
            }else if let result = response.result.value as? Bool{
                if result == false {
                    completionHandler(true, nil)
                }
            }else if let results = response.result.value as? [Dictionary<String,AnyObject>] {
                var conflictArray: [Dictionary<String,String>] = []
                for result in results {
                    var aConflict = Dictionary<String,String>()
                    aConflict["GUEST"] = result["GUEST"] as? String ?? ""
                    aConflict["MEETING_TITLE"] = result["MEETING_TITLE"] as? String ?? ""
                    aConflict["C_DATE_START"] = result["C_DATE_START"] as? String ?? ""
                    aConflict["C_DATE_END"] = result["C_DATE_END"] as? String ?? ""
                    conflictArray.append(aConflict)
                }
                completionHandler(false, conflictArray)
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
        let parameters = ["m_id":event.M_ID, "p_id":event.P_ID, "C_DATE_START":C_DATE_START, "start_hour":"0", "start_minute":"0", "C_DATE_END":C_DATE_END, "end_hour":"0", "end_minute":"0", "meeting_title":event.MEETING_TITLE, "meeting_place":event.MEETING_PLACE, "meeting_info":event.MEETING_INFO, "notice":event.NOTICE] as [String : Any]
        
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
    
    // 修改行程
    func modifyCalendarRequest(event: eventModel, _ completionHandler: @escaping (Bool, String) -> Void){
        guard let token = appDelegate.token else { return }
        let headers = ["Authorization": "Bearer \(token)"]
        let start_hour = event.startTime.components(separatedBy: ":")[0]
        let start_minute = event.startTime.components(separatedBy: ":")[1]
        let end_hour = event.endTime.components(separatedBy: ":")[0]
        let end_minute = event.endTime.components(separatedBy: ":")[1]
        let C_DATE_START = event.C_DATE_START.components(separatedBy: "T")[0]
        let C_DATE_END = event.C_DATE_END.components(separatedBy: "T")[0]
        let parameters = ["ce_id":event.CE_ID, "m_id":event.M_ID, "p_id":event.P_ID, "C_DATE_START":C_DATE_START, "start_hour":start_hour, "start_minute":start_minute, "C_DATE_END":C_DATE_END, "end_hour":end_hour, "end_minute":end_minute, "meeting_title":event.MEETING_TITLE, "meeting_place":event.MEETING_PLACE, "meeting_info":event.MEETING_INFO, "notice":event.NOTICE] as [String : Any]
        
        Alamofire.request("http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/UpdateCalendar/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
    
    // 新增商家, 進行掃描, 取得字串之後
    func insertMatchedMemberRequest(invite_id: String, _ completionHandler: @escaping (Bool, String) -> Void){
        guard let token = appDelegate.token else { return }
        let headers = ["Authorization": "Bearer \(token)"]
        let parameters = ["invite_id":invite_id]
        
        Alamofire.request("http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/SendMatchRequest", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                if let JSON = response.result.value as? [String:AnyObject] {
                    if let result = JSON["result"] as? Bool,
                        let msg = JSON["msg"] as? String,
                        let M_NAME = JSON["M_NAME"] as? String{
                        if result {
                            completionHandler(true, M_NAME)
                        }else {
                            completionHandler(false, msg)
                        }
                    }
                }else {
                    print("registerRequest: get JSON error")
                }
        }
    }
    
    // 取得收件夾新邀請
    func getInboxNewRequest(_ completionHandler: @escaping ([Dictionary<String,String>]?) -> Void) {
        var allRequest: [Dictionary<String,String>] = []
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/GetInbox/false"
        let headers = ["Authorization": "Bearer \(token)"]
        Alamofire.request(url, headers: headers).responseJSON { (response) -> Void in
            if let results = response.result.value as? [Dictionary<String,AnyObject>] {
                for result in results {
                    guard let P_CLASS = result["P_CLASS"] as? String,           //  ID
                        let MEETING_TITLE = result["MEETING_TITLE"] as? String,           //  ID
                        let GUEST = result["GUEST"] as? String,           //  ID
                        let C_DATE_END = result["C_DATE_START"] as? String,           //  ID
                        let CE_ID = result["CE_ID"] as? String         //  類別名稱
                        else { return }
                    var _class: Dictionary<String,String> = [:]
                    _class["P_CLASS"] = P_CLASS
                    _class["MEETING_TITLE"] = MEETING_TITLE
                    _class["GUEST"] = GUEST
                    _class["C_DATE_START"] = C_DATE_END
                    _class["CE_ID"] = CE_ID
                    allRequest.append(_class)
                }
                completionHandler(allRequest)
            }else {
                print("projectClassRequest: get JSON error")
            }
        }
    }
    
    // 取得收件夾已回覆
    func getInboxDoneRequest(_ completionHandler: @escaping ([Dictionary<String,String>]?) -> Void) {
        var allRequest: [Dictionary<String,String>] = []
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/GetInbox/true"
        let headers = ["Authorization": "Bearer \(token)"]
        Alamofire.request(url, headers: headers).responseJSON { (response) -> Void in
            if let results = response.result.value as? [Dictionary<String,AnyObject>] {
                for result in results {
                    guard let P_CLASS = result["P_CLASS"] as? String,           //  ID
                        let MEETING_TITLE = result["MEETING_TITLE"] as? String,           //  ID
                        let GUEST = result["GUEST"] as? String,           //  ID
                        let C_DATE_START = result["C_DATE_START"] as? String,           //  ID
                        let CE_ID = result["CE_ID"] as? String,       //  類別名稱
                        let STATUS = result["STATUS"] as? Int         //  類別名稱
                        else { return }
                    var _class: Dictionary<String,String> = [:]
                    _class["P_CLASS"] = P_CLASS
                    _class["MEETING_TITLE"] = MEETING_TITLE
                    _class["GUEST"] = GUEST
                    _class["C_DATE_START"] = C_DATE_START
                    _class["CE_ID"] = CE_ID
                    _class["STATUS"] = "\(STATUS)"
                    allRequest.append(_class)
                }
                completionHandler(allRequest)
            }else {
                print("projectClassRequest: get JSON error")
            }
        }
    }
    
    // 回應邀請
    func responseRequest(ce_id: String,  isAccept: Bool, _ completionHandler: @escaping () -> Void){
        guard let token = appDelegate.token else { return }
        let headers = ["Authorization": "Bearer \(token)"]
        let parameters = ["ce_id":ce_id, "isAccept":isAccept] as [String : Any]
        
        Alamofire.request("http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/UpdateCalendarAcceptStatus", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                if let JSON = response.result.value as? [String:AnyObject] {
                    if let result = JSON["result"] as? Bool,
                        let msg = JSON["msg"] as? String{
                        if result {
                            completionHandler()
                        }else {
                            completionHandler()
                        }
                    }
                }else {
                    print("registerRequest: get JSON error")
                }
        }
    }
    
    // 商家端：取得待審核商家
    func getWatingMatchMemberRequest(_ completionHandler: @escaping ([MatchedMember]?) -> Void) {
        var allmatchedMembers: [MatchedMember] = []
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/GetWatingMatchMember/"
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
                    aMatchedMember.M_MAIL = result["M_MAIL"] as? String ?? ""
                    aMatchedMember.M_TEL_D = result["M_TEL_D"] as? String ?? ""
                    aMatchedMember.LastLogin = result["LastLogin"] as? String ?? ""
                    allmatchedMembers.append(aMatchedMember)
                }
                completionHandler(allmatchedMembers)
            }else {
                print("getWatingMatchMemberRequest: get JSON error")
            }
        }
    }
    
    // 商家端：取得已審核商家
    func getAuditedMatchMemberRequest(_ completionHandler: @escaping ([[String: String]]?) -> Void) {
        var allmatchedMembers: [[String: String]] = []
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/GetAuditedMatchMember/"
        let headers = ["Authorization": "Bearer \(token)"]
        Alamofire.request(url, headers: headers).responseJSON { (response) -> Void in
            if let results = response.result.value as? [Dictionary<String,AnyObject>] {
                for result in results {
                    let aMatchedMember = [result["M_NAME"] as? String ?? "": result["LastLogin"] as? String ?? ""]
                    allmatchedMembers.append(aMatchedMember)
                }
                completionHandler(allmatchedMembers)
            }else {
                print("getAuditedMatchMemberRequest: get JSON error")
            }
        }
    }
    
    // 商家端：取得QRCode
    func getIDbyTokenRequest(_ completionHandler: @escaping (String?) -> Void) {
        guard let token = appDelegate.token else { return }
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/GetIDbyToken/"
        let headers = ["Authorization": "Bearer \(token)"]
        Alamofire.request(url, headers: headers).responseJSON { (response) -> Void in
            if let results = response.result.value as? String {
                completionHandler(results)
            }else {
                print("getIDbyTokenRequest: get JSON error")
            }
        }
    }
}

