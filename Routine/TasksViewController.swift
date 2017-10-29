//
//  ViewController.swift
//  Routine
//
//  Created by Alex on 28.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var rightMenuButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.initialize(view: view)
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTasksViewController), name: Notification.Name(rawValue: "refreshTasksViewController"), object: nil)


    }
    
    override func viewDidAppear(_ animated: Bool) {
        // первый проект
        if stored.projects.count == 0 {
            stored.projectViewControllerStyle = .new
            performSegue(withIdentifier: "projectSegue", sender: self)
        } else
            if slider.openCount == 0 {
                slider.leftMenuOpen()
        }
    }
    


    func refreshTasksViewController() {
        DispatchQueue.main.async {
            self.tasksTableView.reloadData()
            self.projectTitleLabel.text = stored.tasks.currentSourceTitle
            
            if stored.taskSource == .project {
                self.rightMenuButton.isEnabled = true
            } else {
                self.rightMenuButton.isEnabled = false
            }
        }
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  stored.tasks.forCurrentSource.count
    }
    
    // отрисовка таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        
        let task = stored.tasks.forCurrentSource[indexPath.row]
        
        cell.titleLabel.text = task.title
        cell.commentLabel.text = task.comment

        cell.titleLabel.textColor = UIColor.black
        cell.commentLabel.textColor = UIColor.black
        
        if task.actuality == false {
            cell.titleLabel.textColor = UIColor.lightGray
            cell.commentLabel.textColor = UIColor.lightGray
        }
        
        return cell
    }
    
    //  нажатие на tableView cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        stored.taskViewControllerStyle = .edit
        
        if stored.taskSource == .project {
            stored.currentTaskIndex = indexPath.row
        } else {
            stored.currentProjectIndex = stored.findProjectIndex(forTask: stored.tasks.forCurrentSource[indexPath.row])
            stored.currentTaskIndex = stored.findTaskIndex(forTask: stored.tasks.forCurrentSource[indexPath.row])
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "taskSegue", sender: self)
    }

    // удаление ячейки
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // удаление по дате создания
            stored.tasks.remove(withDate: stored.tasks.forCurrentSource[indexPath.row].creationDate)
            tableView.deleteRows(at: [indexPath], with: .none)
            
        }
    }

    

    @IBAction func leftMenuClick(_ sender: Any) {
      slider.leftMenuOpen()
    }
    
    
    @IBAction func rightMenuClick(_ sender: Any) {
        let myActionSheet = UIAlertController(title: "Change action for current project", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let button1 = UIAlertAction(title: "Add new task", style: .default)  { (ACTION) in
            stored.taskViewControllerStyle = .new
            self.performSegue(withIdentifier: "taskSegue", sender: self)
        }
        
        let button2 = UIAlertAction(title: "Edit", style: .default)  { (ACTION) in
            stored.projectViewControllerStyle = .edit
            self.performSegue(withIdentifier: "projectSegue", sender: self)
        }
        
        let button3 = UIAlertAction(title: "Delete", style: .destructive)  { (ACTION) in
            self.deleteProjectClick()
        }
        
        let button4 = UIAlertAction(title: "Cancell", style: .cancel)  { (ACTION) in }
        
        myActionSheet.addAction(button1)
        myActionSheet.addAction(button2)
        myActionSheet.addAction(button3)
        myActionSheet.addAction(button4)
        
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    
    
    func deleteProjectClick () {
        
        let alertController = UIAlertController(title: "Attention!", message: "Are you sure that you want to delete this project with all they tasks?", preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Yes", style: .destructive)  { (_) in
            stored.projects.remove(at: stored.currentProjectIndex)
            stored.taskSource = .all
            self.viewDidAppear(true)
            
        }
        let cancelAction = UIAlertAction(title: "No", style: .default) { (_) in }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
  
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

