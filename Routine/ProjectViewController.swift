//
//  NewProjectViewController.swift
//  Routine
//
//  Created by Alex on 30.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//


import UIKit

class ProjectViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var barTitle: UILabel!
    @IBOutlet weak var newProjectTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var rightBarButton: UIButton!
    @IBOutlet weak var leftBarButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch stored.projectViewControllerStyle {
        case .new:
            barTitle.text = "New Project Name"
        case .edit:
            barTitle.text = stored.projects[stored.currentProjectIndex].title
        }
        
        newProjectTextField.delegate = self
        rightBarButton.isEnabled = false
        errorLabel.text = ""
        
        if stored.projects.count == 0 {
            leftBarButton.isHidden = true
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        newProjectTextField.becomeFirstResponder()
    }
    
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    
    //  возврат обратно без добавления нового проекта
    @IBAction func leftBarButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func rightBarButtonClick(_ sender: Any) {
        switch stored.projectViewControllerStyle {
        case .new:
            let newProject = Stored.Project.init(createDate: Date(), title: newProjectTextField.text!)
            stored.projects.append(newProject)
        case .edit:
            stored.projects[stored.currentProjectIndex].title = newProjectTextField.text!
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func projectTextFieldValueChanged(_ sender: Any) {
        var text = ""
        var color = UIColor()
        
        if newProjectTextField.text?.isValidForTitle != true {
            text = "invalid"
            color = UIColor.red
        } else {
            if stored.containsProject(withTitle: newProjectTextField.text!) {
                text = "exists"
                color = UIColor.red
            } else {
                text = "valid"
                color = UIColor.blue
            }
        }
        DispatchQueue.main.async {
            self.errorLabel.text = text
            self.errorLabel.textColor = color
            if color == UIColor.red {
                self.rightBarButton.isEnabled = false
                self.newProjectTextField.enablesReturnKeyAutomatically = false
            } else {
                self.rightBarButton.isEnabled = true
                self.newProjectTextField.enablesReturnKeyAutomatically = true
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
