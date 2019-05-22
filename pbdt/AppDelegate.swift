//
//  AppDelegate.swift
//  pbdt
//
//  Created by Andrew M Levy on 3/30/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
//let baseUrl: String = "http://localhost:3000"
let baseUrl: String = "https://pbdt.herokuapp.com"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var dateFilter: Date!
    var diaryEntries = [Food]()
    var currentUser: User!
    
    var infoViewIsShowing: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        dateFilter = Date()
        
        AppearanceConfig.setupNavigationBar()
        AppearanceConfig.setupStatusBar()
        AppearanceConfig.setupTabBar()
        //AppearanceConfig.setupKeyboard()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "pbdt")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - pop up view
    
    // pop up view
    func showInfoView(message: String, color: UIColor) {
        
        let statusBar_Height = UIApplication.shared.statusBarFrame.height
        
        if infoViewIsShowing == false {
            
            infoViewIsShowing = true
            
            // pop up view parameters
            let infoView_Width = CGFloat(self.window!.bounds.width) - CGFloat(6)
            let infoView_Height = CGFloat(40)
            let infoView_X = CGFloat(3)
            let infoView_Y = CGFloat(0 - infoView_Height)
            let infoView = UIView(frame: CGRect(x: infoView_X, y: infoView_Y, width: infoView_Width, height: infoView_Height))
            infoView.layer.cornerRadius = CGFloat(3)
            infoView.layer.borderWidth = CGFloat(2)
            infoView.layer.borderColor = UIColor.brandPrimary().cgColor
            //infoView.layer.cornerRadius = infoView_Height / 2
            infoView.layer.cornerRadius = CGFloat(5)
            self.window!.addSubview(infoView)
            
            let label_Height = CGFloat(20)
            let label_X = CGFloat(13)
            let label_Y = CGFloat(10)
            let label_Width = infoView_Width - CGFloat(26)
            let label = UILabel(frame: CGRect(x: label_X, y: label_Y, width: label_Width, height: label_Height))
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.backgroundColor = .clear
            label.textColor = UIColor.brandPrimary()
            label.textAlignment = .center
            infoView.addSubview(label)
            
            infoView.backgroundColor = color
            label.text = message
            
            // animate errorView
            UIView.animate(withDuration: 0.2, animations: {
                
                // move infoView down
                infoView.frame.origin.y = statusBar_Height
                //infoView.frame.origin.y = 200
                
                // if animation finished
            }, completion: { (finished:Bool) in
                
                // if true
                if finished {
                    
                    UIView.animate(withDuration: 0.2, delay: 2, options: [.allowUserInteraction, .curveLinear], animations: {
                        
                        // move errorView up
                        infoView.frame.origin.y = infoView_Y
                        
                        // if finished animation
                    }, completion: { (finished:Bool) in
                        
                        if finished {
                            infoView.removeFromSuperview()
                            label.removeFromSuperview()
                            self.infoViewIsShowing = false
                        }
                    })
                }
            })
        }
    }
    
    // MARK: - load foods
    
    func loadFoods() {
        
        let date = appDelegate.dateFilter.toString(format: "yyyy-MM-dd")
        
        let foodFetch: NSFetchRequest<Food> = NSFetchRequest(entityName: "Food")
        
        foodFetch.predicate = NSPredicate(format: "logDate = %@", "\(date)")
        
        let sectionSortDescriptions = NSSortDescriptor(key: "updatedAt", ascending: false)
        let sortDescripters = [sectionSortDescriptions]
        foodFetch.sortDescriptors = sortDescripters
        
        do {
            let fetchRequest = try context.fetch(foodFetch)
            appDelegate.diaryEntries = fetchRequest
        } catch {
            print("Error fetching foods: \(error)")
        }
    }
}

