//
//  AppDelegate.swift
//  Roll Companion (Swift)
//
//  Created by Jared Heddinger on 2/15/20.
//  Copyright © 2020 Jared Heddinger. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RollCompanion")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let defaultOptions = UserDefaults.init()
        let loadedData = defaultOptions.bool(forKey: "loadedData")
//        let loadedData = false
        if !loadedData {
            preloadData()
            defaultOptions.set(true, forKey: "loadedData")
        }
        
        
        if let rootNav = window?.rootViewController as? UINavigationController {
            let rootVC = rootNav.viewControllers[0] as! CharacterTableView
            rootVC.container = persistentContainer
        }

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
    }

    func preloadData() {
        preloadSpellData()
//        preloadRaceData()
    }
    
    func preloadSpellData() {
        print("Preloading Spells data.")
        
        removeSpellData()
        
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Spell", in: managedContext)!

//        if UIDevice.init().
        let bundle = Bundle.main
        let paths = bundle.paths(forResourcesOfType: "txt", inDirectory: "Spells")
        
        if (paths.count == 0) {
            fatalError()
        }

        var numFiles = 0
        print(paths.count)
        for file in paths {
            let fileName = NSURL(fileURLWithPath: file).lastPathComponent
            if fileName != ".DS_Store" {
                var lines : [String.SubSequence] = []
                do {
                    let content = try String(contentsOfFile: file, encoding: String.Encoding.utf8)
                    
                    lines = content.split(separator: "\n", maxSplits: 9, omittingEmptySubsequences: true)
                    
                    let spell = NSManagedObject(entity: entity, insertInto: managedContext)
                    
                    for line in lines {
                        let info = line.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)

                        if String(info[0]) == "ritual" || String(info[0]) == "upcast" {
                            spell.setValue((String(info[1]) == "1") ? true : false, forKey: String(info[0]))
                        }
                        else if String(info[0]) == "level" {
                            spell.setValue(Int(info[1]), forKey: String(info[0]))
                        }
                        else {
                            spell.setValue(String(info[1]), forKey: String(info[0]))
                        }
                    }
                    if spell.value(forKey: "text") != nil {
                        if ((spell.value(forKey: "text") as? String)?.lowercased().contains("at higher level"))! {
                            spell.setValue(true, forKey: "upcast")
                        }
                    }
                }
                catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                if managedContext.hasChanges {
                    managedContext.performAndWait {
                        do {
                            try managedContext.save()
                        }
                        catch {
                            fatalError("Failure to save context: \(error)")
                        }
                    }
                }
                numFiles += 1
            }
        }

        if managedContext.hasChanges {
            managedContext.performAndWait {
                do {
                    try managedContext.save()
                }
                catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
        print("Loading " + String(numFiles) + " files.")
    }
    
    func removeSpellData() {
        // Remove the existing items
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Spell")
        var spells : [Spell] = []
        do {
            try spells = managedContext.fetch(fetchRequest) as! [Spell]
        }
        catch {
            fatalError()
        }
        for spell in spells {
            managedContext.delete(spell)
        }
    }
    
//    func preloadRaceData() {
//        let races : [[String]] = [
//            ["Dragonborn", "2","0","0","0","0","1"],
//            ["Hill Dwarf", "0","0","2","0","1","0"],
//            ["Mountain Dwarf", "2","0","2","0","0","0"],
//            ["High Elf", "0","2","0","1","0","0"],
//            ["Wood Elf", "0","2","0","0","1","0"],
//            ["Deep Gnome", "0","1","0","2","0","0"],
//            ["Rock Gnome", "0","0","1","2","0","0"],
//            ["Half-Elf", "0","0","0","0","0","2"],
//            ["Lightfoot Halfling", "0","2","0","0","0","1"],
//            ["Stout Halfling", "0","2","1","0","0","0"],
//            ["Half-Orc", "2","0","1","0","0","0"],
//            ["Human", "1","1","1","1","1","1"],
//            ["Tiefling", "0","0","0","1","0","2"]
//        ]
//        
//        removeRaceData()
//        let managedContext = persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Race1", in: managedContext)!
//        
//        for datum in races {
//            let race = NSManagedObject(entity: entity, insertInto: managedContext)
//            race.setValue(datum[0], forKey: "name")
//            race.setValue(Int(datum[1]) ?? 0, forKey: "str")
//            race.setValue(Int(datum[2]) ?? 0, forKey: "dex")
//            race.setValue(Int(datum[3]) ?? 0, forKey: "con")
//            race.setValue(Int(datum[4]) ?? 0, forKey: "int")
//            race.setValue(Int(datum[5]) ?? 0, forKey: "wis")
//            race.setValue(Int(datum[6]) ?? 0, forKey: "cha")
//            
//        }
//        if managedContext.hasChanges {
//            managedContext.performAndWait {
//                do {
//                    try managedContext.save()
//                }
//                catch {
//                    fatalError("Failure to save context: \(error)")
//                }
//            }
//        }
        
//    }
//
//    func removeRaceData() {
//        // Remove the existing items
//        let managedContext = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Race1")
//        var races : [Race1] = []
//        do {
//            try races = managedContext.fetch(fetchRequest) as! [Race1]
//        }
//        catch {
//            fatalError()
//        }
//        for race in races {
//            managedContext.delete(race)
//        }
//    }
}

