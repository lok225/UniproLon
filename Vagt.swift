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
    private let aftenSats: Double = 12.6
    private let lordagsSats: Double = 22.38
    private let sondagsSats: Double = 25.3
    
    var totalSatser: Double = 0.0
    
    // TODO: Lav et interval for hver 60. minut, hvor jeg laver et array med timer. Derefter kan jeg tilføje penge, under satserne. 
    
    var vagtITimer: Double {
        
        var min = startTime.differenceInMinsWithDate(endTime)
        
        if min >= 240 {
            min -= 30
        }
        
        return Double(min) / 60
    }
    
    var samletLon: Double {
        
        let weekDayComponent = calendar.component(.Weekday, fromDate: startTime)
        let hourOfDay = calendar.component(.Hour, fromDate: startTime)
        
        var lon = 0.0
        
        if weekDayComponent == 1 {
            totalSatser += sondagsSats * vagtITimer
            lon = vagtITimer * (basisLon + sondagsSats)
        } else if weekDayComponent == 7 && hourOfDay >= 15 {
            lon = vagtITimer * (basisLon + lordagsSats)
        } else if hourOfDay >= 18 {
            totalSatser += aftenSats * vagtITimer
            lon = vagtITimer * (basisLon + aftenSats)
        } else {
            lon = vagtITimer * basisLon
        }
        
        return lon
    }
    
    func getLonMonth() -> String {
    
        let calendar = NSCalendar.currentCalendar()
        let dayComponent = calendar.component(.Day, fromDate: startTime)
        var monthComponent = calendar.component(.Month, fromDate: startTime)
        
        if dayComponent > 18 {
            monthComponent += 1
        }
        
        let monthString = monthComponent.getMonthAsString()
        
        return monthString
    }
    
    func getLonYear() -> String {
        
        let calendar = NSCalendar.currentCalendar()
        let yearComponent = calendar.component([.Year], fromDate: startTime)
        
        return String(yearComponent)
    }

}

extension NSDate {
    
    func differenceInMinsWithDate(date: NSDate) -> Int {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        
        let components = calendar.components(.Minute, fromDate: self, toDate: date, options: [])
        
        return components.minute
    }
    
}

extension Int {
    
    func getMonthAsString() -> String {
        
        let monthString: String!
        
        switch self {
        case 1:
            monthString = "Januar"
        case 2:
            monthString = "Februar"
        case 3:
            monthString = "Marts"
        case 4:
            monthString = "April"
        case 5:
            monthString = "Maj"
        case 6:
            monthString = "Juni"
        case 7:
            monthString = "Juli"
        case 8:
            monthString = "August"
        case 9:
            monthString = "September"
        case 10:
            monthString = "Oktober"
        case 11:
            monthString = "November"
        case 12:
            monthString = "December"
        default:
            monthString = ""
        }
        
        return monthString
    }
    
}





