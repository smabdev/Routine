//
//  Tasks.swift
//  Routine
//
//  Created by Alex on 30.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import EVReflection



class Stored {
    
    
    class Task: EVObject {
        var ownerCreationDate: Date
        var creationDate: Date
        var title: String
        var comment: String
        var priority: Int
        var actuality: Bool
        var notification: Bool
        var notificationDate: Date
        
        required init () {
            self.ownerCreationDate = Date()
            self.creationDate = Date()
            self.title = ""
            self.comment = ""
            self.priority = 0
            self.actuality = false
            self.notification = false
            self.notificationDate = Date()
        }
        
        init (ownerCreationDate: Date, creationDate: Date, title: String, comment: String, priority: Int, actuality: Bool,  notification: Bool, notificationDate: Date) {
            self.ownerCreationDate = ownerCreationDate
            self.creationDate = creationDate
            self.title = title
            self.comment = comment
            self.priority = priority
            self.actuality = actuality
            self.notification = notification
            self.notificationDate = notificationDate
        }
    }
    
    
    class Project: EVObject {
        var creationDate: Date
        var title: String {
            didSet {
                stored.sendNotifications ()
            }
        }
        var tasks: [Task] {
            didSet {
                stored.sendNotifications()
            }
        }
        
      
        required init() {
            self.creationDate = Date()
            self.title = ""
            self.tasks = []
        }
        
        init(createDate: Date, title: String) {
            self.creationDate = createDate
            self.title = title
            self.tasks = []
        }
      
        init(createDate: Date, title: String, tasks: [Task]) {
            self.creationDate = createDate
            self.title = title
            self.tasks = tasks
        }
    }
    
    
    enum TasksSource {
        case today
        case tomorrow
        case all
        case project
    }
    
    enum TaskStyle {
        case new
        case edit
    }
    
    struct TasksIndexes {
        var project = 0
        var task = 0
    }
    
    
// TASKS struct begin
    
    struct Tasks {
        var today: [Task] {
            var todayTasksArray = Array(repeating: Task(), count: 0)
            for project in stored.projects {
                for task in project.tasks {
                    if NSCalendar.current.isDateInToday(task.notificationDate) {
                        todayTasksArray.append(task)
                    }
                }
            }
            return sortedByPriority(todayTasksArray)
        }
        
        var tomorrow: [Task] {
            var tomorrowTasksArray = Array(repeating: Task(), count: 0)
            for project in stored.projects {
                for task in project.tasks {
                    if NSCalendar.current.isDateInTomorrow(task.notificationDate) {
                        tomorrowTasksArray.append(task)
                    }
                }
            }
            return sortedByPriority(tomorrowTasksArray)
        }
        
        
        var all: [Task] {
            var allTasksArray = Array(repeating: Task(), count: 0)
            for project in stored.projects {
                allTasksArray.append(contentsOf: project.tasks)
            }
            return sortedByPriority(allTasksArray)
        }
        
        // возвращает актуальные задачи сортированные по времени, с включенной задачей оповещения
        var actual: [Task] {
            var actualTasksArray = Array(repeating: Task(), count: 0)
            for project in stored.projects {
                for task in project.tasks {
                    if task.actuality {
                        actualTasksArray.append(task)
                    }
                }
            }
            return sortedByDate(actualTasksArray)
        }
        

        var currentSourceTitle: String {
            switch stored.taskSource {
            case .project:
                if stored.projects.count != 0 {
                    return stored.projects[stored.currentProjectIndex].title
                } else {
                    return ""
                }
            case .all:
                return "All tasks"
            case .today:
                return "Today tasks"
            case .tomorrow:
                return "Tomorrow tasks"
            }
        }
        
        var forCurrentSource: [Task] {
            if stored.projects.count == 0 {
                return []
            }
            
            switch stored.taskSource {
            case .project:
                return stored.projects[stored.currentProjectIndex].tasks
            case .today:
                return stored.tasks.today
            case .tomorrow:
                return stored.tasks.tomorrow
            case .all:
                return stored.tasks.all
            }
        }
        
        
        
        func remove (withDate: Date) {
            var i1 = 0
            while i1 != stored.projects.count {
                var i2 = 0
                while i2 != stored.projects[i1].tasks.count {
                    if stored.projects[i1].tasks[i2].creationDate == withDate {
                        stored.projects[i1].tasks.remove(at: i2)
                        return
                    }
                    i2 += 1
                }
                i1 += 1
            }
        }
        
        // возвращает сортированные по времени предстоящие задачи, отмеченные для оповещения
        private func sortedByDate(_ unsorted: [Task]) -> [Task] {
            var sorted = unsorted.sorted {
                (element1, element2) -> Bool in
                return element1.notificationDate < element2.notificationDate
            }
            
            var i = 0
            while i != sorted.count {
                if sorted[i].notificationDate < Date() || sorted[i].notification == false {
                    sorted.remove(at: i)
                    continue
                }
                i += 1
            }
            return sorted
        }
        
        
        private func sortedByPriority (_ unsorted: [Task]) -> [Task] {
            var notActualityTasks: [Task] = []
            var actualityTasks: [Task] = []
            
            for task in unsorted {
                if task.actuality {
                    actualityTasks.append(task)
                } else {
                    notActualityTasks.append(task)
                }
            }
            
            actualityTasks = actualityTasks.sorted {
                (element1, element2) -> Bool in
                return element1.priority > element2.priority
            }
            
            return actualityTasks + notActualityTasks
        }
        
        
    }
    
// TASKS struct end
    
    
    
    func containsProject(withTitle: String) -> Bool {
        for project in projects {
            if withTitle == project.title {
                return true
            }
        }
        return false
    }
    
    func findProjectIndex (forTask task: Stored.Task) -> Int {
        for index in 0 ..< stored.projects.count {
            if task.ownerCreationDate == stored.projects[index].creationDate {
                return index
            }
          }
        return 0
    }
    
    func findTaskIndex (forTask task: Stored.Task) -> Int {
        let projectIndex = findProjectIndex(forTask: task)
        
        for index in 0 ..< stored.projects[projectIndex].tasks.count {
            if task.creationDate == stored.projects[projectIndex].tasks[index].creationDate {
                return index
            }
        }
        return 0
    }
    
    
    

    // отправка оповещений о необходимости перестройки экранов
    func sendNotifications () {
        var notification = Notification.init(name: Notification.Name("refreshProjectsViewController"))
        NotificationCenter.default.post(notification)
        notification = Notification.init(name: Notification.Name("refreshTasksViewController"))
        NotificationCenter.default.post(notification)
    }
    
    
    // для создания новых/редактирования проектов и задач
    var taskViewControllerStyle: TaskStyle = .new
    var projectViewControllerStyle: TaskStyle = .new
    
    
    // выбор одного проекта, либо в таблице TasksViewController показываются все задачи
    var currentProjectIndex: Int = 0
    var currentTaskIndex = 0
    
    var taskSource: TasksSource = .project {
        didSet {
            sendNotifications ()
        }
    }
    
    var tasks = Tasks()
    
    var projects: [Project] = [] {
        // при добавлении/удалении проекта
        didSet {
            if projects.count == 1 {
                taskSource = .project
                currentProjectIndex = 0
            }
            sendNotifications()
        }
    }
    
    
    static let shared = Stored()
    private init () { }
    
}

    let stored = Stored.shared

