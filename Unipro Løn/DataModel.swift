//
//  DataModel.swift
//  Unipro Løn
//
//  Created by Martin Lok on 04/01/2016.
//  Copyright © 2016 Martin Lok. All rights reserved.
//

import Foundation

public class DataModel {
    
    let kFirstTime = "FirstTime"
    
    var monthItems = [MonthItem]()
    
    init() {
        loadMonthItems()
        if monthItems.count == 0 {
            monthItems.append(MonthItem(unigoMade: 0, timeWorked: 0))
        }
        // registerDefaults()
        // handleFirstTime()
    }
    
    // MARK: - Defaults
    
    func registerDefaults() {
        let dict = [ kFirstTime: true]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dict)
    }
    
    func handleFirstTime() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let firstTime = defaults.boolForKey(kFirstTime)
        
        print(firstTime)

        if firstTime {
            let item = MonthItem(unigoMade: 0, timeWorked: 0)
            monthItems.append(item)
            defaults.setBool(false, forKey: kFirstTime)
            defaults.synchronize()
            print("First Time")
        }
    }
    
    // MARK: - DataModel Saving & Loading
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        return paths[0]
    }
    
    func dataFilePath() -> String {
        
        // /Users/martinlok/Library/Developer/CoreSimulator/Devices/3E190D78-B602-442D-B5F2-876DD09F5D03/data/Containers/Data/Application/B626A0E6-783D-48AE-8241-1E569F9343B2/Documents
        
        return (documentsDirectory() as NSString).stringByAppendingPathComponent("UniproLon.plist")
    }
    
    func saveMonthItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(monthItems, forKey: "MonthItems")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
        
        print("saved")
    }
    
    func loadMonthItems() {
        let path = dataFilePath()
        
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                monthItems = unarchiver.decodeObjectForKey("MonthItems") as! [MonthItem]
                
                unarchiver.finishDecoding()
                
                sortChecklists()
            }
        }
        
    }
    
    // TODO: - Test
    
    func sortChecklists() {
        monthItems.sortInPlace { (monthItem1, monthItem2) -> Bool in
            monthItem1.date.compare(monthItem2.date) == .OrderedDescending
        }
    }

    
}
