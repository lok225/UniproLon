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
    
    var måneder: [[Vagt]] {
        
        return [[Vagt()]]
    }
    
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

        setupCoreData()
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
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let vagt = vagter[0]
        let component = NSCalendar.currentCalendar().components([.Month, .Year], fromDate: vagt.startTime)
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = .Full
        let string = formatter.stringFromDateComponents(component)
        
        return string
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vagter.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let startTimeFormatter = NSDateFormatter()
        startTimeFormatter.timeStyle = .ShortStyle
        startTimeFormatter.dateStyle = .FullStyle
        let startDate = vagter[indexPath.row].startTime!
        let startTimeString = startTimeFormatter.stringFromDate(startDate)
        
        let endTimeFormatter = NSDateFormatter()
        endTimeFormatter.timeStyle = .ShortStyle
        endTimeFormatter.dateStyle = .NoStyle
        let endDate = vagter[indexPath.row].endTime!
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
                let thisVagt = vagter[indexPath.row]
                controller.vagtToEdit = thisVagt
            }
        }
    }
    
    // MARK: - Helper Functions
    
    
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
