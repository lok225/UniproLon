//
//  FotexAddVagtVC.swift
//  Unipro Løn
//
//  Created by Martin Lok on 11/05/2016.
//  Copyright © 2016 Martin Lok. All rights reserved.
//

import UIKit
import CoreData

class FotexAddVagtVC: UITableViewController {
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var startTime = NSDate()
    var endTime = NSDate()
    
    var vagtToEdit: Vagt? {
        didSet {
            if let vagt = vagtToEdit {
                startTime = vagt.startTime
                endTime = vagt.endTime
                print(vagt.samletLon)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        if let _ = vagtToEdit {
            title = "Ændre Vagt"
        }
        
        startTimePicker.date = startTime
        endTimePicker.date = endTime
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        
        let vagt: Vagt
        
        if let temp = vagtToEdit {
            vagt = temp
        } else {
            vagt = NSEntityDescription.insertNewObjectForEntityForName("Vagt", inManagedObjectContext: managedObjectContext) as! Vagt
        }
        
        vagt.startTime = startTimePicker.date
        vagt.endTime = endTimePicker.date
        vagt.month = vagt.getLonMonth()
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Error: \(error)")
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func startTimePickerChanged(sender: UIDatePicker) {
        
        endTimePicker.date = NSDate(timeInterval: 10800, sinceDate: startTimePicker.date)
    }
    

}
