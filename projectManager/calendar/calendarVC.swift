//
//  calendarVC.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/5/29.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import UIKit

class calendarVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    @IBOutlet weak var searchTimeBtn: UIBarButtonItem!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var messageBtn: UIBarButtonItem!
    
    var navTitle: String = ""
    var months = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    var currentEvents: [eventModel] = []
    var sortedEvents: Dictionary<String,[eventModel]> = [:]
    var didSelectDate: [eventModel] = []
    
    var numberOfDaysInThisMonth:Int{
        let dateComponents = DateComponents(year: currentYear ,
                                            month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
        let range = Calendar.current.range(of: .day, in: .month,
                                           for: date)
        return range?.count ?? 0
    }
    
    var numberOfDaysInLastMonth:Int{
        
        var dateComponents = DateComponents(year: currentYear,
                                            month: currentMonth - 1)
        if currentMonth == 1 {
            dateComponents = DateComponents(year: currentYear - 1,
                                            month: 12)
        }
        let date = Calendar.current.date(from: dateComponents)!
        let range = Calendar.current.range(of: .day, in: .month,
                                           for: date)
        return range?.count ?? 0
    }
    
    var whatDayIsIt:Int{
        let dateComponents = DateComponents(year: currentYear ,
                                            month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
        return Calendar.current.component(.weekday, from: date)
    }
    
    var howManyItemsShouldIAddBefore:Int{
        return whatDayIsIt - 1
    }
    
    var howManyItemsShouldIAddAfter:Int{
        return 7 - whatDayIsIt
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setNavBar()
        self.setUpDate()
        self.setSwipeGesture()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    
    
    
    
    @IBAction func tapMessageBtn(_ sender: Any) {
    }
    
    @IBAction func tapSearchBtn(_ sender: Any) {
    }
    
    @IBAction func tapSearchTimeBtn(_ sender: Any) {
    }
    
    @IBAction func tapAddBtn(_ sender: Any) {
        if let scheduleAddVC = self.storyboard?.instantiateViewController(withIdentifier: "scheduleAddVC") as? scheduleAddVC {
            self.navigationController?.pushViewController(scheduleAddVC, animated: true)
        }
    }
    
    func setNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    func setUpDate(){
        self.title = months[currentMonth - 1]
        self.queryEvents()
        self.didSelectDate = []
        self.tableView.reloadData()
    }
    
    func queryEvents() {
        self.currentEvents = []
        var beginYear = self.currentYear
        var beginMonth = self.currentMonth
        var beginDay = 1
        var endYear = self.currentYear
        var endMonth = self.currentMonth
        var endDay = numberOfDaysInThisMonth
        if howManyItemsShouldIAddBefore != 0 {
            if self.currentMonth != 1 {
                beginMonth = self.currentMonth - 1
            }else {
                beginYear = self.currentYear - 1
                beginMonth = 12
            }
            beginDay = numberOfDaysInLastMonth - self.howManyItemsShouldIAddBefore + 1
        }
        if howManyItemsShouldIAddAfter > 1 && numberOfDaysInThisMonth != 31 || howManyItemsShouldIAddAfter > 2 && numberOfDaysInThisMonth == 31 || howManyItemsShouldIAddAfter > 0 && numberOfDaysInThisMonth < 30{
            if self.currentMonth != 12 {
                endMonth = self.currentMonth + 1
            }else {
                endYear = self.currentYear + 1
                endMonth = 1
            }
            endDay = 35 - self.howManyItemsShouldIAddBefore - self.numberOfDaysInThisMonth
        }
        let searchBegin = "\(beginYear)-\(beginMonth)-\(beginDay)"
        let searchEnd = "\(endYear)-\(endMonth)-\(endDay)"
//        print("\(searchBegin) - \(searchEnd)")
        self.calendarRequest(from: searchBegin, end: searchEnd) { (_events) in
            guard let events = _events else { return }
//            print("events.count = \(events.count)")
            self.currentEvents = events
            self.sortEvents()
        }
    }
    
    func sortEvents() {
        self.sortedEvents = [:]
        for event in self.currentEvents {
            let startDay = event.startDate
            let endDay = event.endDate
            if startDay == endDay {
                if self.sortedEvents["\(startDay)"] != nil {
                    self.sortedEvents["\(startDay)"]!.append(event)
                }else {
                    self.sortedEvents["\(startDay)"] = [event]
                }
            }else {
                if self.sortedEvents["\(startDay)"] != nil {
                    self.sortedEvents["\(startDay)"]!.append(event)
                }else {
                    self.sortedEvents["\(startDay)"] = [event]
                }
                if self.sortedEvents["\(endDay)"] != nil {
                    self.sortedEvents["\(endDay)"]!.append(event)
                }else {
                    self.sortedEvents["\(endDay)"] = [event]
                }
            }
        }
        self.collectionView.reloadData()
    }
    
    func setSwipeGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.collectionView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.collectionView.addGestureRecognizer(swipeLeft)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                self.lastMonth()
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                self.nextMonth()
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func nextMonth() {
        print("jump to nextMonth")
        currentMonth += 1
        if currentMonth == 13{
            currentMonth = 1
            currentYear += 1
        }
        setUpDate()
    }
    
    func lastMonth() {
        print("jump to lastMonth")
        currentMonth -= 1
        if currentMonth == 0{
            currentMonth = 12
            currentYear -= 1
        }
        setUpDate()
    }
    
    func getCurrentDate(indexPath: IndexPath) -> String {
        var year = self.currentYear
        var month = self.currentMonth
        var day = 1
        if indexPath.row < self.howManyItemsShouldIAddBefore{
            // 低於本月
            if self.currentMonth != 1 {
                year = self.currentYear
                month = self.currentMonth - 1
            }else {
                year = self.currentYear - 1
                month = 12
            }
            day = numberOfDaysInLastMonth - self.howManyItemsShouldIAddBefore + indexPath.row + 1
        }else if indexPath.row >= self.howManyItemsShouldIAddBefore + numberOfDaysInThisMonth{
            // 超過本月
            if self.currentMonth != 12 {
                year = self.currentYear
                month = self.currentMonth + 1
            }else {
                year = self.currentYear + 1
                month = 1
            }
            day = indexPath.row + 1 - numberOfDaysInThisMonth - howManyItemsShouldIAddBefore
        }else{
            // 本月
            year = self.currentYear
            month = self.currentMonth
            day = indexPath.row + 1 - howManyItemsShouldIAddBefore
        }
        
        var date = "\(year)-\(month)-\(day)"
        if month < 10 && day < 10 {
            date = "\(year)-0\(month)-0\(day)"
        }else if month >= 10 && day < 10 {
            date = "\(year)-\(month)-0\(day)"
        }else if month < 10 && day >= 10 {
            date = "\(year)-0\(month)-\(day)"
        }else {
            date = "\(year)-\(month)-\(day)"
        }
        
        return date
    }
}

extension calendarVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! calendarCollectionCell
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        if indexPath.row < self.howManyItemsShouldIAddBefore{
            // 低於本月
            cell.dateLabel.text = "\(numberOfDaysInLastMonth - self.howManyItemsShouldIAddBefore + indexPath.row + 1)"
        }else if indexPath.row >= self.howManyItemsShouldIAddBefore + numberOfDaysInThisMonth{
            // 超過本月
            cell.dateLabel.text = "\(indexPath.row + 1 - numberOfDaysInThisMonth - howManyItemsShouldIAddBefore)"
        }else{
            // 本月
            cell.dateLabel.text = "\(indexPath.row + 1 - howManyItemsShouldIAddBefore)"
        }

        let date = self.getCurrentDate(indexPath: indexPath)
        cell.calendarVC = self
        cell.configCell(self.sortedEvents[date])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        let height = collectionView.frame.height / 5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectDate = []
        let date = self.getCurrentDate(indexPath: indexPath)
        if let events = self.sortedEvents[date] {
            let sortedEvents = sortEventsByStartTime(events: events)
            self.didSelectDate = sortedEvents
        }
        self.tableView.reloadData()
        
    }
}

extension calendarVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let eventsCount = self.didSelectDate.count
        return eventsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! calendarCell
        cell.selectionStyle = .none
        cell.configCell(event: self.didSelectDate[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scheduleDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "scheduleDetailVC") as! scheduleDetailVC
        scheduleDetailVC.event = self.didSelectDate[indexPath.row]
        self.navigationController?.pushViewController(scheduleDetailVC, animated: true)
    }
}
