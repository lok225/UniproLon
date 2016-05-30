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
    
    @IBOutlet weak var vagtTableView: UITableView!
    
    // MARK: - Variables & Konstants
    
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var vagterFetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName("Vagt", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        
        let sortDescriptor1 = NSSortDescriptor(key: "month", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "startTime", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        fetchRequest.fetchBatchSize = 20
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "month", cacheName: "Vagter")
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let kFotexFirstTime = "kFotexFirstTime"
    
    var totalLon: Double = 0.0 {
        didSet {
            lblFøtexTotalLøn.text = String(Int(totalLon)) + ",-"
            self.antalVagter = vagterFetchedResultsController.sections![0].numberOfObjects
            calculateTotalTillæg()
            calculateAntalTimer()
        }
    }
    var totalTillæg: Double = 0.0 {
        didSet {
            lblFøtexTillæg.text = "Deraf tillæg: " + String(Int(totalTillæg)) + ",-"
        }
    }
    var antalTimer: Double = 0.0 {
        didSet {
            lblFøtexTimer.text = "Antal timer: " + getAntalTimerAsString()
        }
    }
    var antalVagter: Int = 0 {
        didSet {
            lblFøtexVagter.text = "Antal vagter: " + String(antalVagter)
        }
    }
    
    // MARK: - Initial Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Den crasher hvis den er tom?
        if defaults.boolForKey(kFotexFirstTime) == false {
            let vagt = NSEntityDescription.insertNewObjectForEntityForName("Vagt", inManagedObjectContext: managedObjectContext) as! Vagt
            vagt.startTime = NSDate()
            vagt.endTime = NSDate(timeInterval: 1, sinceDate: vagt.startTime)
            vagt.month = vagt.getLonMonth()
            
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Error: \(error)")
            }
            
            defaults.setBool(true, forKey: kFotexFirstTime)
            defaults.synchronize()
        }
        
        performFetch()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        calculateTotalLon()
    }
    
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("AddVagt", sender: indexPath)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return vagterFetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionInfo = vagterFetchedResultsController.sections![section]
        let tempVagter = vagterFetchedResultsController.sections![section].objects as! [Vagt]
        let vagt = tempVagter[0]
        
        return sectionInfo.name + ", " + vagt.getLonYear()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = vagterFetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
        
        configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let vagt = vagterFetchedResultsController.objectAtIndexPath(indexPath) as! Vagt
        
        let startTimeFormatter = NSDateFormatter()
        startTimeFormatter.dateFormat = "EEEE d/M H:mm"
        let startDate = vagt.startTime!
        let startTimeString = startTimeFormatter.stringFromDate(startDate).capitalizedString
        
        let endTimeFormatter = NSDateFormatter()
        endTimeFormatter.timeStyle = .ShortStyle
        endTimeFormatter.dateStyle = .NoStyle
        let endDate = vagt.endTime!
        let endTimeString = endTimeFormatter.stringFromDate(endDate)
        
        cell.textLabel?.text = startTimeString + " - " + endTimeString
        cell.detailTextLabel?.text = String(Int(vagt.samletLon)) + ",-"
        
        if NSDate().differenceInMinsWithDate(startDate) > 0 {
            let color = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.0)
            cell.backgroundColor = color
        }
    }
    
    // Override to support conditional editing of the table view.
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if vagterFetchedResultsController.fetchedObjects!.count == 1 {
            let alert = createAlertWithTitle("Kan ikke slettes", message: "Kan ikke slettes, da det er den sidste")
            self.presentViewController(alert, animated: true, completion: nil)
            tableView.editing = false
        } else if editingStyle == .Delete {
            let location = vagterFetchedResultsController.objectAtIndexPath(indexPath) as! Vagt
            managedObjectContext.deleteObject(location)
            
            do {
                try managedObjectContext.save()
            } catch {
                fatalError(String(error))
            }
        }
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddVagt" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! FotexAddVagtVC
            controller.managedObjectContext = self.managedObjectContext
            
            if let indexPath = sender as? NSIndexPath {
                let thisVagt = vagterFetchedResultsController.objectAtIndexPath(indexPath) as! Vagt
                controller.vagtToEdit = thisVagt
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func performFetch() {
        do {
            try vagterFetchedResultsController.performFetch()
        } catch {
            fatalError(String(error))
        }
    }
    
    private func calculateTotalLon() {
        totalLon = 0
        for vagt in (vagterFetchedResultsController.sections![0].objects as! [Vagt]) {
            let løn = vagt.samletLon
            totalLon += løn
        }
    }

    private func calculateAntalTimer() {
        antalTimer = 0.0
        for vagt in (vagterFetchedResultsController.fetchedObjects as! [Vagt]) {
            let hours = vagt.vagtITimer
            antalTimer += hours
        }
    }
    
    private func getAntalTimerAsString() -> String {
        let minutes = antalTimer * 60
        
        return getFormattedTimeWorkedAsText(false, time: Int(minutes))!
    }
    
    private func calculateTotalTillæg() {
        totalTillæg = 0.0
        for vagt in (vagterFetchedResultsController.fetchedObjects as! [Vagt]) {
            let satser = vagt.totalSatser
            totalTillæg += satser
        }
    }
}

extension FotexMainVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        print("*** controllerWillChangeContent")
        vagtTableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            print("*** NSFetchedResultsChangeInsert (object)")
            vagtTableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            calculateTotalLon()
        case .Delete:
            print("*** NSFetchedResultsChangeDelete (object)")
            vagtTableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            calculateTotalLon()
        case .Update:
            print("*** NSFetchedResultsChangeUpdate (object)")
            configureCell(vagtTableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
            calculateTotalLon()
        case .Move:
            print("*** NSFetchedResultsChangeMove (object)")
            vagtTableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            vagtTableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Insert:
            print("*** NSFetchedResultsChangeInsert (section)")
            vagtTableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            print("*** NSFetchedResultsChangeDelete (section)")
            vagtTableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Update:
            print("*** NSFetchedResultsChangeUpdate (section)")
        case .Move:
            print("*** NSFetchedResultsChangeMove (section)")
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        print("*** controllerDidChangeContent")
        vagtTableView.endUpdates()
    }
}



