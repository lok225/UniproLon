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
    
    lazy var vagterFetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName("Vagt", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        
        // let sortDescriptor1 = NSSortDescriptor(key: "month", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "startTime", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor2]
        
        fetchRequest.fetchBatchSize = 20
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Vagter")
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    var vagter = [Vagt]()
    
//    var måneder: [[Vagt]] {
//        
//        return [[Vagt()]]
//    }
    
    var totalLon: Double = 0.0 {
        didSet {
            lblFøtexTotalLøn.text = String(Int(totalLon)) + ",-"
            lblFøtexAM.text = "Efter AM: " + String(totalAM) + ",-"
        }
    }
    var tillæg: Double = 0.0 {
        didSet {
            lblFøtexTillæg.text = "Deraf tillæg: " + String(tillæg) + ",-"
        }
    }
    var antalTimer: Double = 0.0 {
        didSet {
            lblFøtexTimer.text = "Antal timer: " + String(antalTimer)
        }
    }
    var antalVagter: Int = 0 {
        didSet {
            lblFøtexVagter.text = "Antal vagter: " + String(antalVagter)
        }
    }
    var totalAM: Double {
        return totalLon * 0.92
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performFetch()

//        let vagt = NSEntityDescription.insertNewObjectForEntityForName("Vagt", inManagedObjectContext: managedObjectContext) as! Vagt
//        vagt.startTime = NSDate()
//        vagt.endTime = NSDate(timeIntervalSinceNow: 10)
//        
//        do {
//            try managedObjectContext.save()
//        } catch {
//            fatalError("Error: \(error)")
//        }
        
        // setupCoreData()
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
        
//        let vagt = vagter[0]
//        let component = NSCalendar.currentCalendar().components([.Month, .Year], fromDate: vagt.startTime)
//        let formatter = NSDateComponentsFormatter()
//        formatter.unitsStyle = .Full
//        let string = formatter.stringFromDateComponents(component)
        
        return "Hej"
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = vagterFetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let vagt = vagterFetchedResultsController.objectAtIndexPath(indexPath) as! Vagt
        
        let startTimeFormatter = NSDateFormatter()
        startTimeFormatter.timeStyle = .ShortStyle
        startTimeFormatter.dateStyle = .FullStyle
        let startDate = vagt.startTime!
        let startTimeString = startTimeFormatter.stringFromDate(startDate)
        
        let endTimeFormatter = NSDateFormatter()
        endTimeFormatter.timeStyle = .ShortStyle
        endTimeFormatter.dateStyle = .NoStyle
        let endDate = vagt.endTime!
        let endTimeString = endTimeFormatter.stringFromDate(endDate)
        
        cell.textLabel?.text = startTimeString + " - " + endTimeString
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.editing = false
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
    
    private func setupCoreData() {
        
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
    
    private func calculateTotalLon() {
        for vagt in vagter {
            let løn = vagt.samletLon
            totalLon += løn
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
        case .Delete:
            print("*** NSFetchedResultsChangeDelete (object)")
            vagtTableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            print("*** NSFetchedResultsChangeUpdate (object)")
//            if let cell = vagtTableView.cellForRowAtIndexPath(indexPath!) {
//                let location = controller.objectAtIndexPath(indexPath!) as! Vagt
//                cell.configureForLocation(location)
//            }
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



