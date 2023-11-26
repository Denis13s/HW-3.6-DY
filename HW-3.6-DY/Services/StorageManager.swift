//
//  StorageManager.swift
//  HW-3.6-DY
//
//  Created by Denis Yarets on 25/11/2023.
//

import Foundation
import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HW_3_6_DY")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let context: NSManagedObjectContext
    
    private init() {
        context = persistentContainer.viewContext
    }
    
}

extension StorageManager {
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData(completion: ([Task]) -> Void) {
        let fetchRequest = Task.fetchRequest()
        do {
            try completion(context.fetch(fetchRequest))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveTask(with title: String?, completionHandler: (Task) -> Void ) {
        guard let title, !title.isEmpty else {
            print("Title can't be empty or missing")
            return
        }
        
        let task = Task(context: context)
        task.title = title
        
        saveContext()
        completionHandler(task)
    }
    
    func edit(task: Task, with title: String?, completionHandler: (Task) -> Void) {
        guard let title, !title.isEmpty else {
            print("Title can't be empty or missing")
            return
        }
        task.title = title
        saveContext()
        completionHandler(task)
    }
    
    func deleteTask(_ task: Task, completionHandler: () -> Void ) {
        context.delete(task)
        saveContext()
        completionHandler()
    }
    
}
