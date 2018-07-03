//
//  projectModel.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/7/3.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import Foundation

class project: NSObject {
    var P_ID: String = ""
    var P_MID: String = ""
    var C_ACCOUNT: String = ""
    var C_NAME: String = ""
    var P_NAME: String = ""
    var P_CLASS: String = ""
    var P_DATE_START: String = ""
    var P_DATE_END: String = ""
    var P_INFO: String = ""
    var P_STATUS: String = ""
    
    init(P_ID: String,
         P_MID: String,
         C_ACCOUNT: String,
         C_NAME: String,
         P_NAME: String,
         P_CLASS: String,
         P_DATE_START: String,
         P_DATE_END: String,
         P_INFO: String,
         P_STATUS: String) {
        
        self.P_ID = P_ID
        self.P_MID = P_MID
        self.C_ACCOUNT = C_ACCOUNT
        self.C_NAME = C_NAME
        self.P_NAME = P_NAME
        self.P_CLASS = P_CLASS
        self.P_DATE_START = P_DATE_START
        self.P_DATE_END = P_DATE_END
        self.P_INFO = P_INFO
        self.P_STATUS = P_STATUS
    }
}

// P_ID          ID
// P_MID         邀請對象ID
// C_ACCOUNT     客戶帳號
// C_NAME        客戶名稱
// P_NAME        專案名稱
// P_CLASS       專案類別
// P_DATE_START  專案開始時間
// P_DATE_END    專案結束時間
// P_INFO        專案說明
// P_STATUS      專案狀態

