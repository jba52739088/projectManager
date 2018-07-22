//
//  matchedMemberModel.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/7/4.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import Foundation

class MatchedMember: NSObject {
    
    var R_ID: String = ""
    var MyName: String = ""
    var M_ACCOUNT: String = ""
    var M_SN: String = ""
    var M_NAME: String = ""
    var M_MAIL: String = ""
    var M_TEL_D: String = ""
    var Status: Int = 0
    var isHost: Bool = false
    var LastLogin: String = ""

    init(R_ID: String,
         MyName: String,
         M_ACCOUNT: String,
         M_SN: String,
         M_NAME: String,
         Status: Int,
         isHost: Bool) {
        self.R_ID = R_ID
        self.MyName = MyName
        self.M_ACCOUNT = M_ACCOUNT
        self.M_SN = M_SN
        self.M_NAME = M_NAME
        self.Status = Status
        self.isHost = isHost
    }
}

//    R_ID          關聯ID
//    MyName        本人名稱
//    isHost        是否為發出人
//    M_SN          對方ID
//    M_ACCOUNT     對方帳號
//    M_NAME        對方名稱
//    Status        狀態審核狀態
//    LastLogin     最後登入時間

