//
//  LeftViewController.swift
//  Routine
//
//  Created by Alex on 29.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    // высота при закрытой таблице со списком проектов
    let baseScrollViewHeight: CGFloat = 370-88
    var isProjectsTableOpen = false
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var isProjectsTableOpenIcon: UIImageView!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var tomorrowLabel: UILabel!
    @IBOutlet weak var allLabel: UILabel!
    
    @IBOutlet weak var projectsTable: UITableView!
    @IBOutlet weak var projectsTableConstraint: NSLayoutConstraint!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectsTable.delegate = self
        projectsTable.dataSource = self
        isProjectsTableOpen = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshProjectsViewController), name: Notification.Name(rawValue: "refreshProjectsViewController"), object: nil)

        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwipeOn(_:)))
        swipe.direction = .left
        self.view.addGestureRecognizer(swipe)
 
    }

  
    @IBAction func leftSwipeOn(_ sender: Any) {
        slider.close()
    }
    
    
    func refreshProjectsViewController () {
        DispatchQueue.main.async {
            self.todayLabel.text = stored.tasks.today.count.description
            self.tomorrowLabel.text = stored.tasks.tomorrow.count.description
            self.allLabel.text = stored.tasks.all.count.description
            self.scrollView.isScrollEnabled = true
            self.projectsTable.reloadData()
            self.setProjectTable(isOpen: self.isProjectsTableOpen)
        }
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  stored.projects.count
    }
    
    // отрисовка таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectTableViewCell
        cell.projectTitleLabel.text = stored.projects[indexPath.row].title
        cell.tasksCountLabel.text = stored.projects[indexPath.row].tasks.count.description
        return cell
    }
    
    //  нажатие на tableView cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        stored.taskSource = .project
        stored.currentProjectIndex = indexPath.row
        slider.close()
    }
    
    
        
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        slider.refreshForTransition(toSize: size)
    }


    @IBAction func todayClick(_ sender: Any) {
        stored.taskSource = .today
        slider.close()
    }

    @IBAction func tomorrowClick(_ sender: Any) {
        stored.taskSource = .tomorrow
        slider.close()
    }
    
    @IBAction func allClick(_ sender: Any) {
        stored.taskSource = .all
        slider.close()
    }
    
    @IBAction func projectsClick(_ sender: Any) {
        if stored.projects.count == 0 {
            return
        }
        isProjectsTableOpen = !isProjectsTableOpen
        setProjectTable(isOpen: isProjectsTableOpen)
    }

    
    @IBAction func logOutClick(_ sender: Any) {
        // выход из аккаунта гугл
    }

    
    
    // открытие/закрытие таблицы проектов
    func setProjectTable (isOpen: Bool) {
        
        DispatchQueue.main.async {
            if isOpen == true {
                self.isProjectsTableOpenIcon.image = #imageLiteral(resourceName: "up")
                UIView.animate(withDuration: 0.1) {
                    let cell = self.projectsTable.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectTableViewCell
                    self.projectsTableConstraint.constant = CGFloat (stored.projects.count) * cell.frame.height
                    self.scrollView.contentSize.height = self.baseScrollViewHeight + self.projectsTableConstraint.constant

                    self.view.layoutIfNeeded()
                }
                
            } else {
                self.isProjectsTableOpenIcon.image = #imageLiteral(resourceName: "down")
                UIView.animate(withDuration: 0.1) {
                    self.projectsTableConstraint.constant = 0
                    self.scrollView.contentSize.height = self.baseScrollViewHeight
                    self.view.layoutIfNeeded()
                }
            }

        }
    }

    
    
    
    @IBAction func maskButtonClick(_ sender: Any) {
        slider.close()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
