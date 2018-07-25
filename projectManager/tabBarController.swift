//
//  tabBarController.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/6/16.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import UIKit

class tabBarController: UITabBarController {

    @IBOutlet weak var _tabBar: UITabBar!
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
