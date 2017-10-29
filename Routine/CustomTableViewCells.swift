//
//  CustomTableViewCells.swift
//  Routine
//
//  Created by Alex on 01.10.17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import Foundation


class ProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var tasksCountLabel: UILabel!

}

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
}
