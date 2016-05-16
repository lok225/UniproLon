//
//  AppDelegate.swift
//  Unipro Løn
//
//  Created by Martin Lok on 26/11/2015.
//  Copyright © 2015 Martin Lok. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let dataModel = DataModel()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        NSUserDefaults.standardUserDefaults().setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")

        
        let tabBarController = window!.rootViewController as! UITabBarController
        
        let uniproNavigationController = tabBarController.viewControllers![0] as! UINavigationController
        let uniproController = uniproNavigationController.viewControllers[0] as! UniproMainVC
        uniproController.dataModel = dataModel
        
        let fotexNavigationController = tabBarController.viewControllers![1] as! UINavigationController
        let fotexController = fotexNavigationController.topViewController as! FotexMainVC
        fotexController.managedObjectContext = managedObjectContext
        
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings( notificationSettings)

        let localNotification = UILocalNotification()
        localNotification.alertBody = "Send Mail"
        let components = NSDateComponents()
        components.year = 2016
        components.month = 1
        components.day = 19
        components.hour = 20
        components.minute = 0
    
        let currentCalendar = NSCalendar.currentCalendar()
        let date = currentCalendar.dateFromComponents(components)
        localNotification.fireDate = date!
        localNotification.repeatInterval = NSCalendarUnit.Month
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        let navigationController = window!.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! UniproMainVC
        controller.sendSpecielMail()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveData()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveData()
    }

    func saveData() {
        dataModel.saveMonthItems()
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        guard let modelURL = NSBundle.mainBundle().URLForResource("CoreDataModel", withExtension: "momd") else {
            fatalError("Could not find data model in app bundle")
        }
        guard let model = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing model from: \(modelURL)")
        }
        let urls = NSFileManager.defaultManager().URLsForDirectory( .DocumentDirectory, inDomains: .UserDomainMask)
        let documentsDirectory = urls[0]
        let storeURL = documentsDirectory.URLByAppendingPathComponent(
            "DataStore.sqlite")
        do {
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            return context
        } catch {
            fatalError("Error adding persistent store at \(storeURL): \(error)")
        }
    }()

}

