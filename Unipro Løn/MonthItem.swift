//
//  UnigoDataModel.swift
//  Unipro Løn
//
//  Created by Martin Lok on 01/12/2015.
//  Copyright © 2015 Martin Lok. All rights reserved.
//

import UIKit
import Foundation

class MonthItem: NSObject, NSCoding {

    var unigoMade: Int!
    var timeWorked: Int!
    var date = NSDate()
    
    init(unigoMade: Int, timeWorked: Int) {
        self.unigoMade = unigoMade
        self.timeWorked = timeWorked
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        unigoMade = aDecoder.decodeIntegerForKey("UnigoMade")
        timeWorked = aDecoder.decodeIntegerForKey("TimeWorked")
        date = aDecoder.decodeObjectForKey("Date") as! NSDate
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(unigoMade, forKey: "UnigoMade")
        aCoder.encodeInteger(timeWorked, forKey: "TimeWorked")
        aCoder.encodeObject(date, forKey: "Date")
    }
    
    func getTotalMoney() -> Int {
        let unigoMadeMoney = unigoMade * 10
        let timeWorkedMoney = timeWorked*80/60
        
        return unigoMadeMoney + timeWorkedMoney
    }
    
}
