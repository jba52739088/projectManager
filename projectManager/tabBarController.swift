//
//  tabBarController.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/6/16.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import UIKit

class tabBarController: UITabBarController{

    @IBOutlet weak var _tabBar: UITabBar!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().backgroundImage = UIImage(named: "p-05_下方功能列(底圖)")
        self.tabBar.autoresizesSubviews = false
        self.tabBar.clipsToBounds = true
        self.tabBar.isTranslucent = false
        
        for item in self.tabBar.items!{
            item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
            item.image = item.image?.withRenderingMode(.alwaysOriginal)
        }
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            appDelegate.calendarVC?.isSearch = false
            appDelegate.calendarVC?.isSearchShop = false
            appDelegate.calendarVC?.searchEnd = ""
            appDelegate.calendarVC?.searchBegin = ""
            appDelegate.calendarVC?.searchKey = ""
            appDelegate.calendarVC?.search_b_mid = ""
            appDelegate.calendarVC?.selectedYear = ""
            appDelegate.calendarVC?.selectedMonth = ""
            appDelegate.calendarVC?.selectedDay = ""
            appDelegate.calendarVC?.searchShopName = nil
            appDelegate.calendarVC?.setUpDate()
        }
    }
}
