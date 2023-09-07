//
//  TaskList.swift
//  RealmApp
//
//  Created by Кирилл on 26.08.2023.
//

import Foundation
import RealmSwift

class TaskList: Object {
    @Persisted var name = ""
    @Persisted var data = Date()
    @Persisted var tasks = List<Task>()
}

class Task: Object {
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var date = Date()
    @Persisted var isComplete = false
}
