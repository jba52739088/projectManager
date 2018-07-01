//
//  calendarCell.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/5/31.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import UIKit

class calendarCell: UITableViewCell {
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var event: eventModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.projectTitleLabel.addLeftBorderWithColor(color: UIColor.black, width: 1)
        self.locationLabel.addLeftBorderWithColor(color: UIColor.black, width: 1)
    }
    
    func configCell(event: eventModel) {
        self.event = event
        let startTime = event.startTime.components(separatedBy: ":")
        self.startTimeLabel.text = startTime[0] + ":" + startTime[1]
        let endTime = event.endTime.components(separatedBy: ":")
        self.endTimeLabel.text = endTime[0] + ":" + endTime[1]
        self.projectTitleLabel.text = event.MEETING_TITLE
        self.locationLabel.text = event.MEETING_PLACE
        
    }


}


extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width,y: 0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addMiddleBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:self.frame.size.width/2, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
}
