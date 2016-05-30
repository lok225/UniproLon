//
//  ViewController.swift
//  Unipro Løn
//
//  Created by Martin Lok on 26/11/2015.
//  Copyright © 2015 Martin Lok. All rights reserved.
//

import UIKit
import MessageUI

class UniproMainVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    // Mark: Constants & Variables
    
    var dataModel: DataModel!
    
    // MARK: Outlets
    
    @IBOutlet weak var lblThisMonthSalary: UILabel!
    @IBOutlet weak var lblUnigosMade: UILabel!
    @IBOutlet weak var lblTimeWorked: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateAllViews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.updateAllViews()
    }
    
    // MARK: - Update Views
    
    func updateAllViews() {
        updateTotalMoneyLabel()
        updateTimeWorkedLabel()
        updateUnigosMadeLabel()
    }
    
    func updateTotalMoneyLabel() {
        let totalMoney = dataModel.monthItems.first!.getTotalMoney()
        lblThisMonthSalary.text = "Rest løn i alt: \(totalMoney),-"
    }
    
    func updateUnigosMadeLabel() {
        let unigosMade = dataModel.monthItems.first!.unigoMade
        lblUnigosMade.text = "\(unigosMade)"
    }
    
    func updateTimeWorkedLabel() {
        let timeWorked = dataModel.monthItems.first!.timeWorked
        let timeString = getFormattedTimeWorkedAsText(false, time: timeWorked)
        lblTimeWorked.text = timeString
    }
    
    // MARK: - @IBActions
    
    @IBAction func unigoButtonPressed(sender: UIButton) {
        var monthItem = dataModel.monthItems.first!.unigoMade!
        
        switch sender.tag {
        case 1:
            monthItem += 1
        case 5:
            monthItem += 5
        case 10:
            monthItem += 10
        case -1:
            monthItem -= 1
        case -5:
            monthItem -= 5
        case -10:
            monthItem -= 10
        default:
            break
        }
        
        dataModel.monthItems.first!.unigoMade = monthItem
        
        updateUnigosMadeLabel()
        updateTotalMoneyLabel()
    }
    
    @IBAction func timeButtonPressed(sender: UIButton) {
        var monthItem = dataModel.monthItems.first!.timeWorked!
        
        switch sender.tag {
        case 15:
            monthItem += 15
        case 30:
            monthItem += 30
        case 60:
            monthItem += 60
        case -15:
            monthItem -= 15
        case -30:
            monthItem -= 30
        case -60:
            monthItem -= 60
        default:
            break
        }
        
        dataModel.monthItems.first!.timeWorked = monthItem
        
        updateTimeWorkedLabel()
        updateTotalMoneyLabel()
    }
    
    @IBAction func sendMail() {
        sendSpecielMail()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "HistorySegue" {
            let controller = segue.destinationViewController as! UniproHistoryVC
            controller.dataModel = self.dataModel
        }
    }
    
    // MARK: - MFMessageComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Cancelled")
            controller.dismissViewControllerAnimated(true, completion: { () -> Void in
                let alert = createAlertWithTitle("Fejl", message: "Du har annuleret mailen")
                self.presentViewController(alert, animated: true, completion: nil)
            })
        case MFMailComposeResultFailed.rawValue:
            print("Failed")
            break
        case MFMailComposeResultSent.rawValue:
            print("Sent")
            self.dataModel.monthItems.first!.endDate = NSDate()
            
            let item = MonthItem()
            self.dataModel.monthItems.append(item)
            self.dataModel.sortChecklists()
            self.updateAllViews()
            
            controller.dismissViewControllerAnimated(true, completion: nil)
        default:
            break
        }
    }
    
    
    // MARK: - Helper Functions
    
    func sendSpecielMail() {
        let item = dataModel.monthItems.first!
        
        if item.getTotalMoney() != 0 {
            if MFMailComposeViewController.canSendMail() {
                let mailVC = MFMailComposeViewController()
                mailVC.mailComposeDelegate = self
                mailVC.setToRecipients(["Martinlok@icloud.com"])
                mailVC.setSubject("Løn")
                mailVC.setMessageBody(createMailString(), isHTML: false)
                
                self.presentViewController(mailVC, animated: true, completion: nil)
            } else {
                let alert = createAlertWithTitle("Advarsel", message: "Kan ikke sende mail fra denne enhed")
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            let alert = createAlertWithTitle("Advarsel", message: "Ingen data tilføjet denne måned")
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func createMailString() -> String {
        let item = dataModel.monthItems.first!
        
        let firstString = "Hej Jeanette \n\n"
        var mainString = ""
        let finalString = "\n\nMvh. Martin Lok"
        
        if item.unigoMade != 0 && item.timeWorked != 0 {
            mainString = "I denne måned har jeg lavet \(item.unigoMade) Unigo og arbejdet i \(item.getFormattedTimeWorkedAsText(true)!). Det skulle gerne blive til \(item.getTotalMoney()),-"
        } else if item.unigoMade != 0 && item.timeWorked == 0 {
            mainString = "I denne måned har jeg lavet \(item.unigoMade) Unigo. Det skulle gerne blive til \(item.getTotalMoney()),-"
        } else if item.unigoMade == 0 && item.timeWorked != 0 {
            mainString = "I denne måned har jeg ikke lavet nogle Unigo, men har arbejdet i \(item.getFormattedTimeWorkedAsText(true)!). Det skulle gerne blive til \(item.getTotalMoney()),-."
        }
        
        return firstString + mainString + finalString
    }
    

}

