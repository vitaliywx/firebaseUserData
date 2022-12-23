//
//  ViewController.swift
//  FireBaseUserData
//
//  Created by Vitalii Homoniuk on 22.12.2022.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    var tasks = [Task]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Savoye LET", size: 30)!,
            NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.shared.getAllData(vc: self)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        APIManager.shared.logout()
        tasks.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func addButton(_ sender: Any) {
        setupTask(isAdd: true)
    }
    
    @IBAction func testButton(_ sender: Any) {
        for i in tasks {
            print(i.taskId)
        }
    }
    
}
 
extension HomeViewController {
    
    func setupTask(isAdd: Bool, index: Int = 0) {
        let alertController = UIAlertController(title: isAdd ? "Add task" : "Update task", message: isAdd ? "Please enter your task detail" : "Please update your task detail", preferredStyle: .alert)
        let save = UIAlertAction(title: isAdd ? "Save" : "Update", style: .default) { _ in
            if let text = alertController.textFields?[0].text {
                if isAdd {
                    APIManager.shared.postData(text: text)
                } else {
                    let task = self.tasks[index]
                    APIManager.shared.updateData(newValue: text, taskId: task.taskId)
                    self.tasks[index] = Task(text: text, taskId: task.taskId)
                    self.tableView.reloadData()
                }
                self.tableView.reloadData()
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addTextField { textField in
            if isAdd {
                textField.placeholder = "Enter your text"
            } else {
                textField.text = self.tasks[index].text
            }
        }
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = tasks[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            self.setupTask(isAdd: false, index: indexPath.row)
        }
        edit.backgroundColor = .systemMint
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            let task = self.tasks[indexPath.item]
            self.tasks.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .top)
            let taskId = task.taskId
            APIManager.shared.deleteData(taskId: taskId)
            self.tableView.reloadData()
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipeConfiguration
    }
}
