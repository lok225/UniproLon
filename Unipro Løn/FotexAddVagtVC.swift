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
                print("Hej")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = vagtToEdit {
            title = "Ændre Vagt"
        }
        
        startTimePicker.date = startTime
        endTimePicker.date = endTime
    }
    
    override func viewDidAppear(animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        
        let vagt: Vagt
        vagt = NSEntityDescription.insertNewObjectForEntityForName("Vagt", inManagedObjectContext: managedObjectContext) as! Vagt
        vagt.startTime = NSDate(timeIntervalSince1970: 1)
        vagt.endTime = NSDate()
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Error: \(error)")
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
