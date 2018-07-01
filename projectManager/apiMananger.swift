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
    
    func loginRequest(account: String, password: String, _ completionHandler: @escaping (Bool) -> Void) {
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/Login/\(account)/\(password)"
        Alamofire.request(url).responseJSON { (response) -> Void in
            if let JSON = response.result.value as? Dictionary<String,AnyObject> {
                if let Result = JSON["Result"] as? Bool,
                    let token = JSON["token"] as? String{
                    if Result {
                        appDelegate.token = token
                      completionHandler(true)
                        self.calendarRequest(from: "", end: "", { (_) in
                            print("123")
                        })
                    }else {
                      completionHandler(false)
                    }
                }
            }else {
                print("loginRequest: get JSON error")
            }
        }
    }
    
//    func registerRequest(account: String, password: String, name: String, ID: String, address: String, phone: String, cellphone: String, mail: String, _ completionHandler: @escaping (Bool) -> Void) {
//        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/AddCustomer/\(ID)/\(account)/\(password)/\(name)/\(account)/\(account)/\(account)/\(account)"
//        Alamofire.request(url).responseJSON { (response) -> Void in
//            if let JSON = response.result.value as? Dictionary<String,AnyObject> {
//                if let Result = JSON["Result"] as? Bool,
//                    let token = JSON["token"] as? String{
//                    if Result {
//                        appDelegate.token = token
//                        completionHandler(true)
//                        self.calendarRequest(from: "", end: "", { (_) in
//                            print("123")
//                        })
//                    }else {
//                        completionHandler(false)
//                    }
//                }
//            }else {
//                print("loginRequest: get JSON error")
//            }
//        }
//    }
    
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
    
    func calendarRequest(from: String, end: String, _ completionHandler: @escaping ([eventModel]?) -> Void) {
        var allEvents: [eventModel] = []
        guard let token = appDelegate.token else { return }
//        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/GetCalendar/2018-06-01/2018-06-30"
        let url = "http://edu.iscom.com.tw:2039/API/api/lawyer_WebAPI/GetCalendar/\(from)/\(end)"
//        print("url: \(url)")
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

}
