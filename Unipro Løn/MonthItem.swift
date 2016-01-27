//
//  UnigoDataModel.swift
//  Unipro Løn
//
//  Created by Martin Lok on 01/12/2015.
//  Copyright © 2015 Martin Lok. All rights reserved.
//

import UIKit
import Foundation

public class MonthItem: NSObject, NSCoding {

    var unigoMade: Int!
    var timeWorked: Int!
    var date = NSDate()
    var endDate = NSDate()
    
    override init() {
        self.unigoMade = 0
        self.timeWorked = 0
        super.init()
    }
    
    init(unigoMade: Int, timeWorked: Int) {
        self.unigoMade = unigoMade
        self.timeWorked = timeWorked
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        unigoMade = aDecoder.decodeIntegerForKey("UnigoMade")
        timeWorked = aDecoder.decodeIntegerForKey("TimeWorked")
        date = aDecoder.decodeObjectForKey("Date") as! NSDate
        endDate = aDecoder.decodeObjectForKey("EndDate") as! NSDate
        super.init()
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(unigoMade, forKey: "UnigoMade")
        aCoder.encodeInteger(timeWorked, forKey: "TimeWorked")
        aCoder.encodeObject(date, forKey: "Date")
        aCoder.encodeObject(endDate, forKey: "EndDate")
    }
    
    func getTotalMoney() -> Int {
        let unigoMadeMoney = unigoMade * 10
        let timeWorkedMoney = timeWorked*80/60
        
        return unigoMadeMoney + timeWorkedMoney
    }
    
    func getHoursWorked() -> Int {
        return self.timeWorked / 60
    }
    
    func getFormattedTimeWorkedAsText(asText: Bool) -> String? {
        
        let hoursWorked = self.timeWorked / 60
        let minutesWorked = self.timeWorked % 60
        
        if asText {
            if hoursWorked == 0 && minutesWorked == 0 {
                return nil
            } else if hoursWorked == 0 {
                return "\(minutesWorked) minutter"
            } else if hoursWorked != 0 && minutesWorked == 0 {
              return "\(hoursWorked) timer"
            } else if hoursWorked == 1 && minutesWorked == 0 {
                return "\(hoursWorked) time"
            } else {
                return "\(hoursWorked) timer og \(minutesWorked) minutter"
            }
        } else {
            let totalTime = String(format: "%01d:%02d", hoursWorked, minutesWorked)
            return totalTime
        }
    }
    
    func getMonthsAsString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM, y"
        let firstDate = dateFormatter.stringFromDate(date)
        let lastDate = dateFormatter.stringFromDate(endDate)
        
        if firstDate == lastDate {
            return firstDate
        } else {
            return "\(firstDate) - \(lastDate)"
        }
    }
    
}
