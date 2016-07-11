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
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var timesSegControl: UISegmentedControl!
    
    // MARK: - Constants
    
    let weekdayTitles: [String] = ["16-20", "16-21", "17-21", "18-21"]
    let weekdayStartTimes: [Int] = [16, 16, 17, 18]
    let weekdayEndTimes: [Int] = [20, 21, 21, 21]
    
    let saturdayTitles: [String] = ["6-10", "6-12", "12-18", "18-21"]
    let saturdayStartTimes: [Int] = [6, 6, 12, 18]
    let saturdayEndTimes: [Int] = [10, 12, 18, 21]
    
    let sundayTitles: [String] = ["7-13", "8-13", "13-18", "18-21"]
    let sundayStartTimes: [Int] = [7, 8, 13, 18]
    let sundayEndTimes: [Int] = [13, 13, 18, 21]
    
    // MARK: - Variables
    
    var calendar: NSCalendar!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var startTime = NSDate()
    var endTime = NSDate()
    var note: String?
    
    var vagtToEdit: Vagt? {
        didSet {
            if let vagt = vagtToEdit {
                startTime = vagt.startTime
                endTime = vagt.endTime
                
                if let note = vagt.note {
                    self.note = note
                }
            }
        }
    }
    
    // MARK: - Initial Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        calendar = NSCalendar.currentCalendar()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let _ = vagtToEdit {
            title = "Ændre Vagt"
            startTimePicker.date = startTime
            endTimePicker.date = endTime
            if let _ = note {
                noteTextField.text = note!
            }
        } else {
            endTimePicker.date = NSDate(timeInterval: 10800, sinceDate: startTimePicker.date)
        }
        setSegControl()
    }
    
    // MARK: - @IBActions
    
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
        vagt.monthNumber = vagt.getLonMonthInt()
        
        if let text = noteTextField.text {
            vagt.note = text
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Error: \(error)")
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func startTimePickerChanged(sender: UIDatePicker) {
        setSegControl()
        
        let startDateComponents = calendar.components([.Year, .Month, .Day], fromDate: sender.date)
        let endDateComponents = calendar.components([.Hour, .Minute], fromDate: endTimePicker.date)
        endDateComponents.setValue(startDateComponents.year, forComponent: .Year)
        endDateComponents.setValue(startDateComponents.month, forComponent: .Month)
        endDateComponents.setValue(startDateComponents.day, forComponent: .Day)
        let newEndDate = calendar.dateFromComponents(endDateComponents)
        endTimePicker.date = newEndDate!
    }
    
    @IBAction func endTimePickerChanged(sender: UIDatePicker) {
        setSegControl()
    }
    
    @IBAction func timeSegControlChanged(sender: UISegmentedControl) {

        let weekday = calendar.component(.Weekday, fromDate: startTimePicker.date)
        let index = sender.selectedSegmentIndex
        
        switch weekday {
        case 1:
            switch index {
            case 0...3:
                updateDatePickerFromSegmentControl(sundayStartTimes, endTimes: sundayEndTimes, atIndex: index)
            default:
                break
            }
        case 2,3,4,5,6:
            switch index {
            case 0...3:
                updateDatePickerFromSegmentControl(weekdayStartTimes, endTimes: weekdayEndTimes, atIndex: index)
            default:
                break
            }
        case 7:
            switch index {
            case 0...3:
                updateDatePickerFromSegmentControl(saturdayStartTimes, endTimes: saturdayEndTimes, atIndex: index)
            default:
                break
            }
        default:
            break
        }
        
    }
    
    // MARK: - Segment Control Functions
    
    func updateDatePickerFromSegmentControl(startTimes: [Int], endTimes: [Int], atIndex index: Int) {
        let startTime = startTimePicker.date
        
        let newStartTimeComp: NSDateComponents = calendar.components([.Year, .Month, .Day], fromDate: startTime)
        let newEndTimeComp: NSDateComponents = calendar.components([.Year, .Month, .Day], fromDate: startTime)
        
        newStartTimeComp.setValue(startTimes[index], forComponent: .Hour)
        newEndTimeComp.setValue(endTimes[index], forComponent: .Hour)
        
        switch startTimes[index] {
        case 17,18:
            newStartTimeComp.setValue(15, forComponent: .Minute)
        default:
            break
        }
        
        switch endTimes[index] {
        case 20,21:
            newEndTimeComp.setValue(15, forComponent: .Minute)
        default:
            break
        }
        
        startTimePicker.date = calendar.dateFromComponents(newStartTimeComp)!
        endTimePicker.date = calendar.dateFromComponents(newEndTimeComp)!
    }
    
    func setSegControl() {
        
        let startTime = startTimePicker.date
        let weekday = calendar.component(.Weekday, fromDate: startTime)
        
        switch weekday {
        case 1:
            setTitles(sundayTitles, animated: true)
            setSelectedSegment(sundayStartTimes, endTimes: sundayEndTimes)
        case 2,3,4,5,6:
            setTitles(weekdayTitles, animated: false)
            setSelectedSegment(weekdayStartTimes, endTimes: weekdayEndTimes)
        case 7:
            setTitles(saturdayTitles, animated: true)
            setSelectedSegment(saturdayStartTimes, endTimes: saturdayEndTimes)
        default:
            break
        }
    }
    
    func setTitles(titlesArray: [String], animated: Bool) {
        var i = 0
        timesSegControl.removeAllSegments()
        
        while i < titlesArray.count {
            // Animated ikke sat
            timesSegControl.insertSegmentWithTitle(titlesArray[i], atIndex: i, animated: false)
            i += 1
        }
        
        timesSegControl.insertSegmentWithTitle("Custom", atIndex: timesSegControl.numberOfSegments, animated: false)
    }
    
    func setSelectedSegment(startTimes: [Int], endTimes: [Int]) {
        
        // TODO: Ikke opdateret til minutter
        
        let startTime = startTimePicker.date
        let endTime = endTimePicker.date
        let startHour = calendar.component(.Hour, fromDate: startTime)
        let endHour = calendar.component(.Hour, fromDate: endTime)
        
        var i = 0
        while i < startTimes.count {
            if startTimes[i] == startHour && endTimes[i] == endHour {
                timesSegControl.selectedSegmentIndex = i
            }
            
            if timesSegControl.selectedSegmentIndex == -1 {
                timesSegControl.selectedSegmentIndex = 4
            }
            i += 1
            
        }
    }
}










