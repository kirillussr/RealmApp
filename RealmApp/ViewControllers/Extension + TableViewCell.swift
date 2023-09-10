//
//  Extension + TableViewCell 2.swift
//  RealmApp
//
//  Created by Кирилл on 10.09.2023.
//

import UIKit

extension UITableViewCell {
    
    func configure(with tasklist: TaskList) {
        let currentTask = tasklist.tasks.filter("isComplete = false")
        var content = defaultContentConfiguration()
        
        content.text = tasklist.name
        
        if tasklist.tasks.isEmpty {
            content.secondaryText = "0"
            accessoryType = .none
        } else if currentTask.isEmpty {
            content.secondaryText = nil
            accessoryType = .checkmark
        } else {
            content.secondaryText = currentTask.count.formatted()
            accessoryType = .none
        }
        
        contentConfiguration = content
    }
}
