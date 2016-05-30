//
//  Extra Functions.swift
//  Unipro Løn
//
//  Created by Martin Lok on 18/01/2016.
//  Copyright © 2016 Martin Lok. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
}

func createAlertWithTitle(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    
    return alert
}

func getFormattedTimeWorkedAsText(asText: Bool, time timeWorked: Int) -> String? {
    
    let hoursWorked = timeWorked / 60
    let minutesWorked = timeWorked % 60
    
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