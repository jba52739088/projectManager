//
//  eventModel.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/6/16.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import Foundation

class eventModel: NSObject {
    var CE_ID: String = ""
    var M_ID: String = ""
    var P_ID: String = ""
    var OWNER_ID: String = ""
    var GUEST: String = ""
    var P_NAME: String = ""
    var P_CLASS: String = ""
    var C_DATE_START: String = ""
    var C_DATE_END: String = ""
    var MEETING_TYPE: String = ""
    var MEETING_TITLE: String = ""
    var MEETING_PLACE: String = ""
    var MEETING_INFO: String = ""
    var STATUS: Int = 0
    var SIDE: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var startTime: String = ""
    var endTime: String = ""
    var timestamp: String = ""

    
//    CE_ID: String,
//    M_ID: String,
//    P_ID: String,
//    OWNER_ID: String,
//    GUEST: String,
//    P_NAME: String,
//    P_CLASS: String,
//    C_DATE_START: String,
//    C_DATE_END: String,
//    MEETING_TYPE: String,
//    MEETING_TITLE: String,
//    MEETING_PLACE: String,
//    MEETING_INFO: String,
//    STATUS: Int,
//    SIDE: String
    
    
    
    init(CE_ID: String, M_ID: String, P_ID: String, OWNER_ID: String, GUEST: String, P_NAME: String, P_CLASS: String, C_DATE_START: String, C_DATE_END: String, MEETING_TYPE: String, MEETING_TITLE: String, MEETING_PLACE: String, MEETING_INFO: String, STATUS: Int, SIDE: String) {
        self.CE_ID = CE_ID
        self.M_ID = M_ID
        self.P_ID = P_ID
        self.OWNER_ID = OWNER_ID
        self.GUEST = GUEST
        self.P_NAME = P_NAME
        self.P_CLASS = P_CLASS
        self.C_DATE_START = C_DATE_START
        self.C_DATE_END = C_DATE_END
        self.MEETING_TYPE = MEETING_TYPE
        self.MEETING_TITLE = MEETING_TITLE
        self.MEETING_PLACE = MEETING_PLACE
        self.MEETING_INFO = MEETING_INFO
        self.STATUS = STATUS
        self.SIDE = SIDE
        
        self.startDate = C_DATE_START.components(separatedBy: "T")[0]
        self.endDate = C_DATE_END.components(separatedBy: "T")[0]
        self.startTime = C_DATE_START.components(separatedBy: "T")[1]
        self.endTime = C_DATE_END.components(separatedBy: "T")[1]
        
        
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dfmatter.date(from: self.startDate + " " + self.startTime)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        self.timestamp = "\(dateStamp)"
//        print("self.timestamp: \(self.timestamp)")
    }

}
