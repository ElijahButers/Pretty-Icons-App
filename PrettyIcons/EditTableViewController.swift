//
//  EditTableViewController.swift
//  PrettyIcons
//
//  Created by User on 8/16/16.
//  Copyright © 2016 Elijah Buters. All rights reserved.
//

import UIKit

class EditTableViewController: UITableViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var icon: Icon?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let icon = icon else {
            return
        }
        if let iconImage = icon.image {
            iconImageView.image = iconImage
        }
        titleTextField.text = icon.title
        subtitleTextField.text = icon.subtitle
        ratingLabel.text = String(describing: icon.rating)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        guard let icon = icon else {
            return
        }
        if let iconImage = iconImageView.image {
            icon.image = iconImage
        }
        if let title = titleTextField.text {
            icon.title = title
        }
        if let subtitle = subtitleTextField.text {
            icon.subtitle = subtitle
        }
    }
    
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
