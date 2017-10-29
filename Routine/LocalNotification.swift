//
//  LocalNotification.swift
//  Routine
//
//  Created by Alex on 02.10.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import Foundation

class LocalNotification {
    
    static func set(forTasks: [Stored.Task]) {
        
        for index in 0 ..< forTasks.count {
            // приложение может иметь не более 64 LocalNotification
            if index == 64 {
                break
            }
            
            let notification = UILocalNotification()
            notification.soundName = "notificationSound.mp3"
            notification.alertBody = forTasks[index].title + "\n" + forTasks[index].comment
            notification.fireDate = forTasks[index].notificationDate
            notification.applicationIconBadgeNumber = index + 1
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    
    static func resetAll() {
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
}
