//
//  TasksViewController.swift
//  RealmApp
//
//  Created by Кирилл on 26.08.2023.
//

import UIKit
import RealmSwift

final class TasksViewController: UITableViewController {
    
    var taskList: TaskList!
    
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = taskList.name
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        
        currentTasks = taskList.tasks.filter("isComplete = false")
        completedTasks = taskList.tasks.filter("isComplete = true")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let task = indexPath.section == 0
        ? currentTasks[indexPath.row]
        : completedTasks[indexPath.row]
        content.text = task.name
        content.secondaryText = task.note
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0
        ? currentTasks[indexPath.row]
        : completedTasks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.deleteTask(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] _, _, isDone in
            showAlert(with: task) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneTitle = indexPath.section == 0 ? "Done" : "Undone"
        
        let doneAction = UIContextualAction(style: .normal, title: doneTitle) { [weak self] _, _, isDone in
            StorageManager.shared.doneTask(task)
            
            let currentTaskIndex = IndexPath(
                row: self?.currentTasks.index(of: task) ?? 0,
                section: 0
            )
            let completedTaskIndex = IndexPath(
                row: self?.completedTasks.index(of: task) ?? 0,
                section: 1
            )
            
            let destinationIndexRow = indexPath.section == 0
            ? completedTaskIndex
            : currentTaskIndex
            
            tableView.moveRow(at: indexPath, to: destinationIndexRow)
            isDone(true)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
    
    @objc
    private func addButtonPressed() {
        showAlert()
    }
}

private extension TasksViewController {
    
    func showAlert(with task: Task? = nil, completion: (() -> Void)? = nil) {
        
        let title = task != nil ? "Edit List" : "New List"
        let alert = UIAlertController.createAlert(withTitle: title, andMesage: "What do you want to do?")
        
        alert.action(with: task) { [weak self] taskTitle, note in
            if let task = task, let completion = completion {
                StorageManager.shared.editTask(task, newName: taskTitle, newNote: note)
                completion()
            } else {
                self?.save(task: taskTitle, withNote: note)
            }
        }
        present(alert, animated: true)
    }
    
    func save(task: String, withNote note: String) {
        StorageManager.shared.save(task, withNote: note, to: taskList) { task in
            let rowIndex = IndexPath(row: currentTasks.index(of: task) ?? 0, section: 0)
            tableView.insertRows(at: [rowIndex], with: .automatic)
        }
    }
}
