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