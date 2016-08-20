//
//  RatingTableViewController.swift
//  PrettyIcons
//
//  Created by User on 8/20/16.
//  Copyright © 2016 Elijah Buters. All rights reserved.
//

import UIKit

class RatingTableViewController: UITableViewController {
    
    var icon: Icon?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh() {
        
        for index in 0 ... RatingType.totalRatings.rawValue {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = icon?.rating.rawValue == index ? . checkmark : .none
            }
        }
    }

    // MARK: - Table view data source
}
