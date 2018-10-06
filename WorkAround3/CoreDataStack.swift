//
//  CoreDataStack.swift
//  WorkAround3
//
//  Created by SeoGiwon on 22/09/2018.
//  Copyright © 2018 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack {
    
    // MARK: Properties
    lazy var playItems: [PlayItem] = {
        let fetchRequest: NSFetchRequest<PlayItem> = PlayItem.fetchRequest()
        
        guard let playItems = try? self.persistentContainer.viewContext.fetch(fetchRequest) else {
            print("couldn't fetch play items from Core Data")
            return [PlayItem]()
        }
        
        return playItems
    }()
    
    var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
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
    
    // MARK: - init
    init() {
        // put sample data
        let fetchRequest: NSFetchRequest<PlayItem> = PlayItem.fetchRequest()
        guard let cnt = try? persistentContainer.viewContext.count(for: fetchRequest) else {
            return;
        }
        
        if (cnt == 0) {
            
            print("will put sample data")
            
            _ = PlayItem.samplePlayItems(context: persistentContainer.viewContext)
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print("couldn't put sample play items")
            }
            
            print("did put sample data")
            return
        }
    }
    
    // MARK: - Updating Core Data records
    func update(index: Int, playHead value: Double) {
        
        guard index > 0, index < playItems.count else {
            return
        }
        
        let playItem = playItems[index]
        playItem.playHead = value
        
        saveContext()
    }
    
    
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
}
