//
//  calendarCollectionCell.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/6/3.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import UIKit

class calendarCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var schedule_1: UILabel!
    @IBOutlet weak var schedule_2: UILabel!
    @IBOutlet weak var schedule_3: UILabel!
    
    var calendarVC: calendarVC!
    var events: [eventModel] = []
    
    func configCell(_ _events: [eventModel]?) {
        if let events = _events {
//            self.events = events
            self.events = sortEventsByStartTime(events: events)
        }else {
            self.events = []
        }
        self.checkLabelShouldShow()
        
    }
    
    func checkLabelShouldShow() {
        switch self.events.count {
        case 0:
            self.schedule_1.alpha = 0
            self.schedule_2.alpha = 0
            self.schedule_3.alpha = 0
            self.schedule_1.isUserInteractionEnabled = false
            self.schedule_2.isUserInteractionEnabled = false
            self.schedule_3.isUserInteractionEnabled = false
        case 1:
            self.schedule_1.alpha = 1
            self.schedule_2.alpha = 0
            self.schedule_3.alpha = 0
            self.schedule_1.text = self.events[0].P_CLASS
            self.schedule_1.isUserInteractionEnabled = true
            self.schedule_2.isUserInteractionEnabled = false
            self.schedule_3.isUserInteractionEnabled = false
        case 2:
            self.schedule_1.alpha = 1
            self.schedule_2.alpha = 1
            self.schedule_3.alpha = 0
            self.schedule_1.text = self.events[0].P_CLASS
            self.schedule_2.text = self.events[1].P_CLASS
            self.schedule_1.isUserInteractionEnabled = true
            self.schedule_2.isUserInteractionEnabled = true
            self.schedule_3.isUserInteractionEnabled = false
        default:
            self.schedule_1.alpha = 1
            self.schedule_2.alpha = 1
            self.schedule_3.alpha = 1
            self.schedule_1.text = self.events[0].P_CLASS
            self.schedule_2.text = self.events[1].P_CLASS
            self.schedule_3.text = self.events[2].P_CLASS
            self.schedule_1.isUserInteractionEnabled = true
            self.schedule_2.isUserInteractionEnabled = true
            self.schedule_3.isUserInteractionEnabled = true
        }
        
        let tap_1 = UITapGestureRecognizer(target: self, action: #selector(self.pushToScheduleDetailVC_0))
        let tap_2 = UITapGestureRecognizer(target: self, action: #selector(self.pushToScheduleDetailVC_1))
        let tap_3 = UITapGestureRecognizer(target: self, action: #selector(self.pushToScheduleDetailVC_2))
        self.schedule_1.addGestureRecognizer(tap_1)
        self.schedule_2.addGestureRecognizer(tap_2)
        self.schedule_3.addGestureRecognizer(tap_3)
    }
    
    @objc func pushToScheduleDetailVC_0() {
        let scheduleDetailVC = self.calendarVC?.storyboard?.instantiateViewController(withIdentifier: "scheduleDetailVC") as! scheduleDetailVC
        scheduleDetailVC.event = self.events[0]
        self.calendarVC?.navigationController?.pushViewController(scheduleDetailVC, animated: true)
    }
    
    @objc func pushToScheduleDetailVC_1() {
        let scheduleDetailVC = self.calendarVC?.storyboard?.instantiateViewController(withIdentifier: "scheduleDetailVC") as! scheduleDetailVC
        scheduleDetailVC.event = self.events[1]
        self.calendarVC?.navigationController?.pushViewController(scheduleDetailVC, animated: true)
    }
    
    @objc func pushToScheduleDetailVC_2() {
        let scheduleDetailVC = self.calendarVC?.storyboard?.instantiateViewController(withIdentifier: "scheduleDetailVC") as! scheduleDetailVC
        scheduleDetailVC.event = self.events[2]
        self.calendarVC?.navigationController?.pushViewController(scheduleDetailVC, animated: true)
    }
}

extension NSObject {
    
    func sortEventsByStartTime(events: [eventModel]) -> [eventModel] {
        var sortedEvents = events
        sortedEvents.sort(by: { (item1, item2) -> Bool in
            let user_1 = item1.timestamp
            let user_2 = item2.timestamp
            return user_1 < user_2
        })
        return sortedEvents
    }
}
