//
//  Vagt+CoreDataProperties.swift
//  Unipro Løn
//
//  Created by Martin Lok on 12/05/2016.
//  Copyright © 2016 Martin Lok. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Vagt {

    @NSManaged var endTime: NSDate!
    @NSManaged var startTime: NSDate!
    @NSManaged var penge: Float
    
}
