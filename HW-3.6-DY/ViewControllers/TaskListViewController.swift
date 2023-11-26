//
//  TaskListViewController.swift
//  HW-3.6-DY
//
//  Created by Denis Yarets on 25/11/2023.
//

import UIKit
// Delete via editing style,

final class TaskListViewController: UITableViewController {
    
    private let storageManager = StorageManager.shared
    
    // Should be removed
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let cellID = "cellTask"
    private var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
    }
    
}

// MARK: Private methods
private extension TaskListViewController {
    
    @objc func addNewTaskAlert() {
        showAlert(with: "Save new Task", and: "Input task details")
    }
    
    @objc func addNewTaskVC() {
        let taskVC = TaskViewController()
        taskVC.delegate = self
        navigationController?.pushViewController(taskVC, animated: true)
    }
    
    func showAlert(with title: String, and message: String, task: Task? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive)
        let actionSave = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            task == nil ? save(alert.textFields?.first?.text) : edit(task!)
        }
        alert.addAction(actionCancel)
        alert.addAction(actionSave)
        alert.addTextField {
            $0.placeholder = (task == nil) ? "Add Task" : ""
            $0.text = (task == nil) ? nil : task?.title
            
        }
        
        present(alert, animated: true)
    }
    
    func save(_ text: String?) {
        guard let text, !text.isEmpty else { return }
        
        let task = Task(context: viewContext)
        task.title = text
        tasks.append(task)
        
        let indexPath = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        fetchData()
    }
    
    // MARK: Delete methos
    func delete(at index: Int) {
        let task = tasks[index]
        
        tasks.remove(at: index)
        // remove for tableView
        // romove from the dataCore
        tableView.reloadData()
        viewContext.delete(task)
        fetchData()
    }
    
    func edit(_ task: Task) {
        showAlert(with: "Change the Title", and: "", task: task)
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
        edit(tasks[indexPath.row])
    }
}
