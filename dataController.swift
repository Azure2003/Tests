//
//  dataController.swift
//  Tester (iOS)
//
//  Created by Alex Zhou on 3/3/23.
//

import Foundation
import CoreData

class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "Model")
    init(){
        clearDatabase()
        container.loadPersistentStores{description, error in
            if let error=error{
                print("Core Data failed to load:\(error.localizedDescription)")
            }
        }
    }
    public func clearDatabase() {
        guard let url = container.persistentStoreDescriptions.first?.url else { return }
        
        let persistentStoreCoordinator = container.persistentStoreCoordinator

         do {
             try persistentStoreCoordinator.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
             try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
         } catch {
             print("Attempted to clear persistent store: " + error.localizedDescription)
         }
    }
}
