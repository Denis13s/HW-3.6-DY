//
//  StorageManager.swift
//  HW-3.6-DY
//
//  Created by Denis Yarets on 25/11/2023.
//

import UIKit

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
}

extension StorageManager {
    
    func fetchData() {
        // MARK: Объясни в чем разница этих 2х подходов, пожалуйста
        /*
        let fetchRequest = Task.fetchRequest()
        
        do {
            tasks = try viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
         */
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveTask(with title: String?, completionHandler: (Task) -> Void ) {
        guard let title, !title.isEmpty else {
            print("Title can't be empty or missing")
            return
        }
        
        let task = Task(context: viewContext)
        task.title = title
        
        fetchData()
        
        completionHandler(task)
    }
    
    func editTask() {
    }
    
    func deleteTask(_ task: Task, completionHandler: () -> Void ) {
        viewContext.delete(task)
        
        fetchData()
        
        completionHandler()
    }
    
}
