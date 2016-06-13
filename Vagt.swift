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
    
    private let lordagSatsTime: Double = 15 * 60
    private let hverdagSatsTime: Double = 18 * 60
    
    var satser: Double = 0.0
    
    // TODO: Lav et interval for hver 60. minut, hvor jeg laver et array med timer. Derefter kan jeg tilføje penge, under satserne.
    
    var vagtITimer: Double {
        
        var min = startTime.differenceInMinsWithDate(endTime)
        
        if min >= 240 {
            min -= 30
        }
        
        return Double(min) / 60
    }
    
    var vagtIMin: Int {
        
        let min = startTime.differenceInMinsWithDate(endTime)
        
        return min
    }
    
    var samletLon: Double {
        
        let weekDayComponent = calendar.component(.Weekday, fromDate: startTime)
        
        let startHour = calendar.component(.Hour, fromDate: startTime)
        let startMinute = calendar.component(.Minute, fromDate: startTime)
        let startTimeOfDay = Double((startHour * 60) + startMinute)
        
        let endHour = calendar.component(.Hour, fromDate: endTime)
        let endMinute = calendar.component(.Minute, fromDate: endTime)
        var endTimeOfDay = Double((endHour * 60) + endMinute)
        
        let tillægDage: [Double] = [sondagsSats, aftenSats, aftenSats, aftenSats, aftenSats, aftenSats, lordagsSats]
        
        if vagtIMin >= 240 {
            endTimeOfDay -= 30
        }
        
        let tempVagtIMin: Int = Int(endTimeOfDay - startTimeOfDay)
        
        var lon = 0.0
        let grundLon = basisLon * vagtITimer
        var satsTime = 0
        
        // TODO: Ændre algoritme så starttiden tæller ind
        
        switch weekDayComponent {
        case 2,3,4,5,6:
            print("Hverdag")
            if endTimeOfDay > hverdagSatsTime {
                satsTime = Int(endTimeOfDay - hverdagSatsTime)
            }
        case 7:
            print("Lordag")
            if endTimeOfDay > lordagSatsTime {
                satsTime = Int(endTimeOfDay - lordagSatsTime)

            }
        default:
            break
        }
        
        if weekDayComponent == 1 {
            satser = vagtITimer * sondagsSats
        } else {
            print("Satstid før: \(satsTime)")
            if Int(satsTime) > tempVagtIMin {
                Int(satsTime) - tempVagtIMin % Int(satsTime)
                print("called")
                print("Satstid \(satsTime)")
            }
            
            satser = Double(satsTime / 60) * tillægDage[weekDayComponent - 1]
            
        }
        
        lon = grundLon + satser
        
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





