//
//  UnigoDataModel.swift
//  Unipro Løn
//
//  Created by Martin Lok on 01/12/2015.
//  Copyright © 2015 Martin Lok. All rights reserved.
//

import UIKit

public class MonthItem: NSObject {

    public var unigoCount: Int!
    public var timeWorked: Int!
    
    let date: NSDate!
    
    init(tempUnigoCount: Int, tempTimeWorked: Int) {
        unigoCount = tempUnigoCount
        timeWorked = tempTimeWorked
        
        date = NSDate()
    }
    
    override init() {
        unigoCount = 0
        timeWorked = 0
        date = NSDate()
    }
    
    /**
        Får String ud fra objektets dato
    
        - returns: En string i formatet Januar 2016
    */
    public func stringFromDate() -> String {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "MMMM Y"
        
        return dateFormatter.stringFromDate(date)
    }
    
    
}
