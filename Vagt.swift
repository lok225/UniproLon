//
//  Vagt.swift
//  Unipro Løn
//
//  Created by Martin Lok on 12/05/2016.
//  Copyright © 2016 Martin Lok. All rights reserved.
//

import Foundation
import CoreData


class Vagt: NSManagedObject {
    
    private let calendar: NSCalendar = NSCalendar.currentCalendar()
    
    private let basisLon: Double = 63.86
    private let aftenSats: Double = 12.4
    private let lordagsSats: Double = 22.0
    private let sondagsSats: Double = 24.9
    
    var vagtITimer: Double {
        return Double(startTime.differenceInMinsWithDate(endTime)) / 60
    }
    
    var samletLon: Double {
        
        let weekDayComponent = calendar.component(.Weekday, fromDate: startTime)
        let hourOfDay = calendar.component(.Hour, fromDate: startTime)
        
        if weekDayComponent == 1 {
            return vagtITimer * (basisLon + sondagsSats)
        } else if weekDayComponent == 7 && hourOfDay >= 15 {
            return vagtITimer * (basisLon + lordagsSats)
        } else if hourOfDay >= 18 {
            return vagtITimer * (basisLon + aftenSats)
        }
        
        return vagtITimer * basisLon
    }
    
    func getLonMonth() -> Int {
    
        let calendar = NSCalendar.currentCalendar()
        let dayComponent = calendar.component(.Day, fromDate: startTime)
        var monthComponent = calendar.component(.Month, fromDate: startTime)
        
        if dayComponent > 18 {
            monthComponent += 1
        }
        
        return 1
    }

}

extension NSDate {
    
    func differenceInMinsWithDate(date: NSDate) -> Int {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        
        let components = calendar.components(.Minute, fromDate: self, toDate: date, options: [])
        
        print(components.minute)
        return components.minute
    }
    
}
