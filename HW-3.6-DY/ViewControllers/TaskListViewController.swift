//
//  TaskListViewController.swift
//  HW-3.6-DY
//
//  Created by Denis Yarets on 25/11/2023.
//

import UIKit

// MARK: - TaskListViewController
final class TaskListViewController: UITableViewController {
    
    private let storageManager = StorageManager.shared
    
    private let cellID = "cellTask"
    private var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        storageManager.fetchData {
            tasks = $0
            tableView.reloadData()
        }
    }
}

// MARK: - Editing Table Content Methods
private extension TaskListViewController {
    
    func save(_ text: String?) {
        storageManager.saveTask(with: text) {
            tasks.append($0)
            
            let indexPath = IndexPath(row: tasks.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func delete(at index: Int) {
        let task = tasks[index]
        
        storageManager.deleteTask(task) {
            tasks.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    func editTitle(for task: Task, with title: String?) {
        storageManager.edit(task: task, with: title) { task in
            let index = tasks.firstIndex(where: { $0 === task })
            if let index {
                tasks[index] = task
                tableView.reloadData()
            }
        }
    }
}

// MARK: - NavigationController Methods
private extension TaskListViewController {
    
    @objc func addNewTaskAlert() {
        showAlert(with: "Save new Task", and: "Input task details")
    }
    
    @objc func addNewTaskVC() {
        let taskVC = TaskViewController()
        taskVC.delegate = self
        navigationController?.pushViewController(taskVC, animated: true)
    }
    
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .white
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTaskAlert))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTaskVC))
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    
    func showAlert(with title: String, and message: String, task: Task? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive)
        let actionSave = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            task == nil ? save(alert.textFields?.first?.text) : editTitle(for: task!, with: alert.textFields?.first?.text)
        }
        alert.addAction(actionCancel)
        alert.addAction(actionSave)
        alert.addTextField {
            $0.placeholder = (task == nil) ? "Add Task" : nil
            $0.text = (task == nil) ? nil : task?.title
            
        }
        
        present(alert, animated: true)
    }
    
}

// MARK: TaskViewControllerDelegate
extension TaskListViewController: TaskViewControllerDelegate {
    func saveTask(with title: String) {
        save(title)
    }
}

// MARK: TableViewController...
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = tasks[indexPath.row].title
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlert(with: "Change the Title", and: "", task: tasks[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(at: indexPath.row)
        }
    }
    
}

