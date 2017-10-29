//
//  TaskEditViewController.swift
//  Routine
//
//  Created by Alex on 30.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var barLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    @IBOutlet weak var taskCommentLabel: UILabel!
    @IBOutlet weak var taskCommentTextView: UITextView!
    @IBOutlet weak var taskPrioritySegment: UISegmentedControl!
    
    @IBOutlet weak var actualitySwitch: UISwitch!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    @IBOutlet weak var notificationDateLabel: UILabel!
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    
    @IBOutlet weak var rightBarButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTitleTextField.delegate = self
        taskCommentTextView.delegate = self

        taskCommentTextView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        taskCommentTextView.layer.borderWidth = 1
        taskCommentTextView.layer.cornerRadius = 5
        taskDatePicker.timeZone = TimeZone.current
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        
        switch  stored.taskViewControllerStyle {
        case .new:
            DispatchQueue.main.async {
                self.barLabel.text = "Add new task"
                self.rightBarButton.isEnabled = false
                self.projectTitleLabel.text = stored.projects[stored.currentProjectIndex].title
                self.taskDatePicker.minimumDate = Date()
                self.taskDatePicker.date = Date().addingTimeInterval(60*60)
                self.refreshNotificationDateLabel ()
            }

        case .edit:
            DispatchQueue.main.async {
                self.barLabel.text = "Edit task"
                self.rightBarButton.isEnabled = true
                self.projectTitleLabel.text = stored.projects[stored.currentProjectIndex].title
                self.taskTitleTextField.text = stored.projects[stored.currentProjectIndex].tasks[stored.currentTaskIndex].title
                self.taskCommentTextView.text = stored.projects[stored.currentProjectIndex].tasks[stored.currentTaskIndex].comment
            
                self.taskPrioritySegment.selectedSegmentIndex = stored.projects[stored.currentProjectIndex].tasks[stored.currentTaskIndex].priority
                self.actualitySwitch.isOn = stored.projects[stored.currentProjectIndex].tasks[stored.currentTaskIndex].actuality
                self.notificationSwitch.isOn = stored.projects[stored.currentProjectIndex].tasks[stored.currentTaskIndex].notification
                self.taskDatePicker.date = stored.projects[stored.currentProjectIndex].tasks[stored.currentTaskIndex].notificationDate
                self.refreshNotificationDateLabel ()
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskTitleTextField.endEditing(true)
        return false
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: taskCommentLabel.frame.origin.y - 8), animated: true)
    }
    

    
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.hasSuffix("\n") {
            textView.text = textView.text.replacingOccurrences(of: "\n", with: "")
            taskCommentTextView.endEditing(true)
        }
    }
    
    func dismissKeyboard() {
        taskTitleTextField.endEditing(true)
        taskCommentTextView.endEditing(true)
    }
    

    
    // проверка на допустимость имени задачи
    @IBAction func taskTitleTextFieldValueChanged(_ sender: Any) {
        if (taskTitleTextField.text?.isValidForTitle)! {
            rightBarButton.isEnabled = true
        } else {
            rightBarButton.isEnabled = false
        }
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        self.taskDatePicker.minimumDate = Date()
        refreshNotificationDateLabel ()
    }
    
    
    func refreshNotificationDateLabel () {
        DispatchQueue.main.async {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM yyyy, EEEE, HH:mm"
            dateFormatter.locale = Locale(identifier: "en_US")
            self.notificationDateLabel.text = dateFormatter.string(from: self.taskDatePicker.date)
        }
    }
    
    
    
    @IBAction func notificationSwitchValueChanged(_ sender: Any) {
        DispatchQueue.main.async {
            if self.notificationSwitch.isOn {
                self.notificationDateLabel.layer.opacity = 1
                self.taskDatePicker.layer.opacity = 1
                self.taskDatePicker.isUserInteractionEnabled = true
            } else {
                self.notificationDateLabel.layer.opacity = 0.25
                self.taskDatePicker.layer.opacity = 0.25
                self.taskDatePicker.isUserInteractionEnabled = false
            }
        }
    }
    
    
    @IBAction func leftBarButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func rightBarButtonClick(_ sender: Any) {
        let task = Stored.Task()
        task.ownerCreationDate = stored.projects[stored.currentProjectIndex].creationDate
        task.creationDate = Date()
        task.title = taskTitleTextField.text!
        task.comment = taskCommentTextView.text
        task.priority = taskPrioritySegment.selectedSegmentIndex
        task.actuality = actualitySwitch.isOn
        task.notification = notificationSwitch.isOn
        task.notificationDate = taskDatePicker.date
        
        switch  stored.taskViewControllerStyle {
        case .new:
            stored.projects[stored.currentProjectIndex].tasks.append(task)
            
        case .edit:
            stored.projects[stored.currentProjectIndex].tasks[stored.currentTaskIndex] = task
        }
        
        self.dismiss(animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}





