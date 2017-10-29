//
//  Archiver.swift
//  Routine
//
//  Created by Alex on 02.10.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import EVReflection

class Archiver {

    static private let NSDEFAULT_KEY = "stored_projects"
    
    
    static func saveProjectsToDefaults() {
        if stored.projects.count == 0 {
            return
        }
        let jsonString = stored.projects.toJsonString()
        UserDefaults.standard.setValue(jsonString, forKey: NSDEFAULT_KEY)
        UserDefaults.standard.synchronize()
    }

    
    
    
    static func loadProjectsFromDefaults() {

        if let loadedJson = UserDefaults.standard.string(forKey: NSDEFAULT_KEY) {
            let newProjects: [Stored.Project] = Stored.Project.arrayFromJson(loadedJson)
            stored.projects = newProjects
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                stored.sendNotifications()
            })
        }
    }


}
