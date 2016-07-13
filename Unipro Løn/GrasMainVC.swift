//
//  GrasMainVC.swift
//  Løn
//
//  Created by Martin Lok on 14/07/2016.
//  Copyright © 2016 Martin Lok. All rights reserved.
//

import UIKit

import UIKit
import CoreData

class GrasMainVC: UIViewController {
    
    @IBOutlet weak var grasTableView: UITableView!
    
    @IBOutlet weak var lblSidenDato: UILabel!
    @IBOutlet weak var lblGrasLon: UILabel!
    
    var addView: AddDateView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
        addView?.removeFromSuperview()
    }
    
    @IBAction func plusButtonPressed(sender: UIBarButtonItem) {
        
        addView = AddDateView.createAddView(inView: self.view)
        addView.center.y -= addView.height
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UIView.animateWithDuration(0.4) {
            self.addView.center.y += self.addView.height
        }
    }
    
    func addButtonPressed(sender: UIButton) {
        
        let tempSuperView = sender.superview! as! AddDateView
        
        UIView.animateWithDuration(0.4, animations: {
            tempSuperView.center.y -= tempSuperView.height
        }) { (_) in
            UIApplication.sharedApplication().statusBarStyle = .Default
            tempSuperView.removeFromSuperview()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
    }
    
}

extension GrasMainVC: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension GrasMainVC: UITableViewDelegate {
    
}


