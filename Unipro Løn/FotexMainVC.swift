//
//  FotexMainVC.swift
//  Unipro Løn
//
//  Created by Martin Lok on 30/04/2016.
//  Copyright © 2016 Martin Lok. All rights reserved.
//

import UIKit
import CoreData

class FotexMainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var lblFøtexTotalLøn: UILabel!
    @IBOutlet weak var lblFøtexTillæg: UILabel!
    @IBOutlet weak var lblFøtexTimer: UILabel!
    @IBOutlet weak var lblFøtexVagter: UILabel!
    @IBOutlet weak var lblFøtexAM: UILabel!
    
    @IBOutlet weak var vagtTableView: UITableView!
    
    // MARK: - Variables & Konstants
    
    var managedObjectContext: NSManagedObjectContext!
    
    var vagter = [Vagt]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Vagt", inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "endTime", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchedVagter = try managedObjectContext.executeFetchRequest(fetchRequest)
            vagter = fetchedVagter as! [Vagt]
        } catch {
            fatalError("Error: \(error)")
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("AddVagt", sender: indexPath)
        
    }
    
    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vagter.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        
        let date = vagter[indexPath.row].endTime!
        
        cell.textLabel?.text = dateFormatter.stringFromDate(date)
        
        return cell
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddVagt" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! FotexAddVagtVC
            controller.managedObjectContext = self.managedObjectContext
            
            if let indexPath = sender as? NSIndexPath {
                let thisVagt = vagter[indexPath.row]
                controller.vagtToEdit = thisVagt
            }
        }
    }
 

}
