//
//  ViewController.swift
//  PrettyIcons
//
//  Created by User on 7/22/16.
//  Copyright © 2016 Elijah Buters. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var iconSets = [IconSet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        iconSets = IconSet.iconSets()
        navigationItem.rightBarButtonItem = editButtonItem
        automaticallyAdjustsScrollViewInsets = false
        tableView.allowsSelectionDuringEditing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return iconSets.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let adjustment = isEditing ? 1 : 0
        let iconSet = iconSets[section]
        return iconSet.icons.count + adjustment
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        let iconSet = iconSets[indexPath.section]
        
        if indexPath.row >= iconSet.icons.count && isEditing {
            
            cell.textLabel?.text = "Add icon"
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
        } else {
            
        let icon = iconSet.icons[indexPath.row]
        cell.textLabel?.text = icon.title
        cell.detailTextLabel?.text = icon.subtitle
        if let iconImage = icon.image {
            cell.imageView?.image = iconImage
        }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let iconSet = iconSets[section]
        return iconSet.name
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let set = iconSets[indexPath.section]
            set.icons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            let newIcon = Icon(withTitle: "New Icon", subtitle: "", imageName: nil)
            let set = iconSets[indexPath.section]
            set.icons.append(newIcon)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        let set = iconSets[indexPath.section]
        if indexPath.row >= set.icons.count {
            return .insert
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let set = iconSets[indexPath.section]
        if isEditing && indexPath.row < set.icons.count {
            return nil
        }
        return indexPath
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            
            tableView.beginUpdates()
            for (index, set) in iconSets.enumerated() {
                let indexPath = IndexPath(row: set.icons.count, section: index)
                tableView.insertRows(at:[indexPath], with: .automatic)
            }
            tableView.endUpdates()
            
            tableView.setEditing(true, animated: true)
        } else {
            tableView.beginUpdates()
            for (index, set) in iconSets.enumerated() {
                let indexPath = IndexPath(row: set.icons.count, section: index)
                tableView.deleteRows(at:[indexPath], with: .automatic)
            }
            tableView.endUpdates()
 
            tableView.setEditing(false, animated: true)
        }
    }
}

