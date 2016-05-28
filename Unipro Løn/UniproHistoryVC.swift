//
//  UniproHistoryVC.swift
//  Unipro Løn
//
//  Created by Martin Lok on 13/01/2016.
//  Copyright © 2016 Martin Lok. All rights reserved.
//

import UIKit

class UniproHistoryVC: UITableViewController {

    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataModel.monthItems.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell", forIndexPath: indexPath)

        let item = dataModel.monthItems[indexPath.section]
        if item.getFormattedTimeWorkedAsText(true) != nil {
            cell.textLabel?.text = "\(item.unigoMade) Unigo + \(item.getFormattedTimeWorkedAsText(true)!)"
        } else {
            cell.textLabel?.text = "\(item.unigoMade) Unigo"
        }
        cell.detailTextLabel?.text = "\(item.getTotalMoney()),-"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let item = dataModel.monthItems[section]
        
        return item.getMonthsAsString().capitalizedString
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 || dataModel.monthItems.count == 1 {
            tableView.editing = false
        
            let alert = createAlertWithTitle("Kan ikke slettes", message: "Kan ikke slettes, da det er den nuværende")
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            dataModel.monthItems.removeAtIndex(indexPath.section)
            tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
        }
    }

}
