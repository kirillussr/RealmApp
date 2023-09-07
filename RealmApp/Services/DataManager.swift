//
//  DataManager.swift
//  RealmApp
//
//  Created by Кирилл on 26.08.2023.
//

import Foundation

final class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    func createTempData(completion: @escaping () -> Void) {
        
        let shopingList = TaskList()
        shopingList.name = "Shopping List"
        
        let movesList = TaskList(
            value: [
                "Moves List",
                Date(),
                [
                    ["Best film ever"] as [Any],
                    ["The best of the best", "Must have", Date(), true]
                ]
            ] as [Any]
        )
        
        let milk = Task()
        milk.name = "Milk"
        milk.note = "2L"
        
        let bread = Task(value: ["Bread", "", Date(), true] as [Any])
        let apples = Task(value: ["name": "Apples", "note": "2kg"])
        
        shopingList.tasks.append(milk)
        shopingList.tasks.insert(contentsOf: [bread, apples], at: 1)
        
        DispatchQueue.main.async {
            StorageManager.shared.save([shopingList, movesList])
            completion()
        }
     }
}
