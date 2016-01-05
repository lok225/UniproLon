//
//  ViewController.swift
//  Unipro Løn
//
//  Created by Martin Lok on 26/11/2015.
//  Copyright © 2015 Martin Lok. All rights reserved.
//

import UIKit
import MessageUI

class MainViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
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
    
    // MARK: - Update Views
    
    func updateAllViews() {
        updateTotalMoneyLabel()
        updateTimeWorkedLabel()
        updateUnigosMadeLabel()
    }
    
    func updateTotalMoneyLabel() {
        let totalMoney = dataModel.monthItems[getArrayCount()].getTotalMoney()
        lblThisMonthSalary.text = "Rest løn i alt: \(totalMoney),-"
    }
    
    func updateUnigosMadeLabel() {
        let unigosMade = dataModel.monthItems[getArrayCount()].unigoMade
        lblUnigosMade.text = "\(unigosMade)"
    }
    
    func updateTimeWorkedLabel() {
        let hoursWorked = dataModel.monthItems[getArrayCount()].timeWorked / 60
        let minutesWorked = dataModel.monthItems[getArrayCount()].timeWorked % 60
        let totalTime = String(format: "%01d:%02d", hoursWorked, minutesWorked)
        // lblTimeWorked.text = "\(hoursWorked):\(minutesWorked)"
        lblTimeWorked.text = totalTime
    }
    
    // MARK: - @IBActions
    
    @IBAction func unigoButtonPressed(sender: UIButton) {
        var monthItem = dataModel.monthItems[getArrayCount()].unigoMade!
        
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
        
        dataModel.monthItems[getArrayCount()].unigoMade = monthItem
        
        updateUnigosMadeLabel()
        updateTotalMoneyLabel()
    }
    
    @IBAction func timeButtonPressed(sender: UIButton) {
        var monthItem = dataModel.monthItems[getArrayCount()].timeWorked!
        
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
        
        dataModel.monthItems[getArrayCount()].timeWorked = monthItem
        
        updateTimeWorkedLabel()
        updateTotalMoneyLabel()
    }
    
    @IBAction func sendMail() {
        if MFMailComposeViewController.canSendMail() {
           let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["Martinlok@icloud.com"])
            mailVC.setSubject("Løn")
            mailVC.setMessageBody("Her er min løn", isHTML: false)
            
            self.presentViewController(mailVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - MFMessageComposeViewControllerDelegate
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        
    }
    
    
    // MARK: - Helper Functions
    
    func getArrayCount() -> Int {
        let arrayCount = dataModel.monthItems.count - 1
        return arrayCount
    }
    

}

