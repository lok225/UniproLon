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
    
    // MARK: NSUserDefaults
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let kFotexFirstTime = "kFotexFirstTime"
    
    // MARK: Data Variabler
    
    var totalLon: Double = 0.0 {
        didSet {
            lblFøtexTotalLøn.text = String(Int(totalLon)) + ",-"
            self.antalVagter = vagterFetchedResultsController.sections![thisMonthIndex].numberOfObjects
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
    
    var thisMonthIndex: Int {
        
        var tempIndex = 0
        
        guard vagterFetchedResultsController.sections != nil else {
            return 0
        }
        
        for section in vagterFetchedResultsController.sections! {
            
            let vagt = section.objects![0] as! Vagt
            
            let calendar = NSCalendar.currentCalendar()
            let sectionDayComponent = calendar.component(.Day, fromDate: vagt.startTime)
            var sectionMonthComponent = calendar.component(.Month, fromDate: vagt.startTime)
            
            var thisMonthComponent = calendar.component(.Month, fromDate: NSDate())
            let thisMonthDayComponent = calendar.component(.Day, fromDate: NSDate())
            
            // TODO: d. 18 eller d. 1?
            // Har ikke besluttet om denne måned skal være til d. 18, eller d. 1.
            
            if sectionDayComponent > 18 {
                sectionMonthComponent += 1
            }
            
            if thisMonthDayComponent > 18 {
                thisMonthComponent += 1
            }
            
            if sectionMonthComponent != thisMonthComponent {
                tempIndex += 1
            } else {
                return tempIndex
            }
        }
        
        return tempIndex
    }
    
    // MARK: Colors
    
    let prettyBlueColor = UIColor(red: 0.59, green: 0.82, blue: 0.89, alpha: 1.0)
    let aBlueColor = UIColor(red: 0.04, green: 0.34, blue: 0.53, alpha: 1.0)
    let darkBlueColor = UIColor(red: 0.01, green: 0.18, blue: 0.35, alpha: 1.0)
    let lightDarkBlueColor = UIColor(red: 0.04, green: 0.25, blue: 0.47, alpha: 1.0)
    let gothicBlue = UIColor(red: 0.44, green: 0.58, blue: 0.67, alpha: 1.0)
    
    // MARK: - Initial Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkFirstTime()
        performFetch()
        
        setColors()
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
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 0.8 //make the header transparent
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return vagterFetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionInfo = vagterFetchedResultsController.sections![section]
        let tempVagter = vagterFetchedResultsController.sections![section].objects as! [Vagt]
        let vagt = tempVagter[0]
        
        let lonInt = Int(getTotalLonInSection(section))
        let lonString = "\(lonInt),-"
        let timerString = getAntalTimerAsStringInSection(section) + " t "
        
        return sectionInfo.name + ", " + vagt.getLonYear() + " - " + lonString + " " + timerString
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
        
        setColorsForCell(cell)
        
        // TODO: Speciel farve til vagt
        // Har ikke besluttet om alle kommende vagter skal være specielle farver, eller om det kun skal være den næste...
        if NSDate().differenceInMinsWithDate(startDate) > 0 {
            cell.backgroundColor = lightDarkBlueColor
        }
        
    }
    
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
    
    // MARK: - Views
    
    func setColors() {
        view.backgroundColor = darkBlueColor
        vagtTableView.backgroundColor = darkBlueColor
        vagtTableView.tintColor = UIColor.whiteColor()
        
        lblFøtexTimer.textColor = UIColor.whiteColor()
        lblFøtexTillæg.textColor = UIColor.whiteColor()
        lblFøtexVagter.textColor = UIColor.whiteColor()
        lblFøtexTotalLøn.textColor = UIColor.whiteColor()
    }
    
    func setColorsForCell(cell: UITableViewCell) {
        cell.backgroundColor = darkBlueColor
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.lightTextColor()
        
        let cellView = UIView()
        cellView.backgroundColor = gothicBlue
        cell.selectedBackgroundView = cellView
    }
    
    // MARK: - Helper Functions
    
    private func performFetch() {
        do {
            try vagterFetchedResultsController.performFetch()
        } catch {
            fatalError(String(error))
        }
    }
    
    private func checkFirstTime() {
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
    }
    
    // MARK: - Vagt Functions
    
    private func calculateTotalLon() {
        totalLon = 0
        for vagt in (vagterFetchedResultsController.sections![thisMonthIndex].objects as! [Vagt]) {
            let løn = vagt.samletLon
            totalLon += løn
        }
    }

    private func calculateAntalTimer() {
        antalTimer = 0.0
        for vagt in (vagterFetchedResultsController.sections![thisMonthIndex].objects as! [Vagt]) {
            let hours = vagt.vagtITimer
            antalTimer += hours
        }
    }
    
    private func calculateTotalTillæg() {
        totalTillæg = 0.0
        for vagt in (vagterFetchedResultsController.sections![thisMonthIndex].objects as! [Vagt]) {
            let satser = vagt.satser
            totalTillæg += satser
        }
    }
    
    private func getAntalTimerAsString() -> String {
        let minutes = antalTimer * 60
        
        return getFormattedTimeWorkedAsText(false, time: Int(minutes))!
    }
    
    func getTotalLonInSection(section: Int) -> Double {
        
        let vagter = vagterFetchedResultsController.sections![section].objects as! [Vagt]
        var lonInSection = 0.0
        
        for vagt in vagter {
            let lon = vagt.samletLon
            lonInSection += lon
        }
        
        return lonInSection
    }
    
    func getAntalTimerAsStringInSection(section: Int) -> String {
        let vagter = vagterFetchedResultsController.sections![section].objects as! [Vagt]
        var minutes = 0
        
        for vagt in vagter {
            let min = vagt.vagtITimer * 60
            minutes += Int(min)
        }
        
        return getFormattedTimeWorkedAsText(false, time: Int(minutes))!
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
        
        vagtTableView.reloadData()

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
        
        vagtTableView.reloadData()
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        print("*** controllerDidChangeContent")
        vagtTableView.endUpdates()
    }
}



