//
//  StorageManager.swift
//  RealmApp
//
//  Created by Кирилл on 26.08.2023.
//

import Foundation
import RealmSwift

final class StorageManager {
    static let shared = StorageManager()
    let realm = try! Realm()
    
    private init() {}
    
    //MARK: - Task List
    
    func save(_ taskList: [TaskList]) {
        write {
            realm.add(taskList)
        }
    }
    
    func save(_ taskList: String, completion: (TaskList) -> Void) {
        write {
            let taskList = TaskList(value: [taskList])
            realm.add(taskList)
            completion(taskList)
        }
    }
    
    func delete(_ taskList: TaskList) {
        write {
            realm.delete(taskList.tasks)
            realm.delete(taskList)
        }
    }
   
    func edit(_ taskList: TaskList, newValue: String) {
        write {
            taskList.name = newValue
        }
    }
    
    func done(_ taskList: TaskList) {
        write {
            taskList.tasks.setValue(true, forKey: "isComplete")
        }
    }
    
    //MARK: - Tasks
    
    func save(_ task: String, withNote note: String, to taskList: TaskList, completion: (Task) -> Void) {
        write {
            let task = Task(value: [task, note])
            taskList.tasks.append(task)
            completion(task)
        }
    }
    
    func deleteTask(_ task: Task) {
        write {
            realm.delete(task)
        }
    }
    
    func editTask(_ task: Task, newName: String, newNote: String) {
        task.name = newName
        task.note = newNote
    }
    
    func doneTask(_ task: Task) {
        write {
            task.isComplete.toggle()
        }
    }
    
    //MARK: - Private Methods
    
    private func write(completion: () -> Void) {
        do {
            try realm.write({
                completion()
            })
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
