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
    
    var iconSets: [[Icon?]?]!
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let sectionTitlesCount = UILocalizedIndexedCollation.current().sectionTitles.count
        var allSections = [[Icon?]?](repeating: nil, count: sectionTitlesCount)
        
        let sets = IconSet.iconSets()
        let collation = UILocalizedIndexedCollation.current()
        for iconSet in sets {
            var sectionNumber: Int
            for icon in iconSet.icons {
                sectionNumber = collation.section(for: icon, collationStringSelector: "title")
                if allSections[sectionNumber] == nil {
                    allSections[sectionNumber] = [Icon?]()
                }
                allSections[sectionNumber]!.append(icon)
            }
        }
        
        navigationItem.rightBarButtonItem = editButtonItem
        automaticallyAdjustsScrollViewInsets = false
        tableView.allowsSelectionDuringEditing = true
        tableView.estimatedRowHeight = 67.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoToEdit" {
      
        let editViewController = segue.destination as? EditTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            let set = iconSets[indexPath.section]
            let icon = set.icons[indexPath.row]
            editViewController?.icon = icon
        }
    }
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
        
        let cell: UITableViewCell
        let iconSet = iconSets[indexPath.section]
        
        if indexPath.row >= iconSet.icons.count && isEditing {
            cell = tableView.dequeueReusableCell(withIdentifier: "NewRowCell", for: indexPath)
            cell.textLabel?.text = "Add icon"
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
        } else {
        cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
            if let iconCell = cell as? IconTableViewCell {
                let icon = iconSet.icons[indexPath.row]
                iconCell.titleLabel.text = icon.title
                iconCell.subtitleLabel.text = icon.subtitle
                
                if let iconImage = icon.image {
                    iconCell.iconImageView?.image = iconImage
                } else {
                    iconCell.iconImageView?.image = nil
                }
                
                if icon.rating == .awesome {
                    iconCell.favoriteImageView.image = UIImage(named: "star_sel.png")
                } else {
                    iconCell.favoriteImageView.image = UIImage(named: "star_uns.png")
                }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let set = iconSets[indexPath.section]
        if indexPath.row >= set.icons.count && isEditing {
            self.tableView(tableView, commit: .insert, forRowAt: indexPath) 
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        let iconSet = iconSets[indexPath.section]
        if indexPath.row >= iconSet.icons.count && isEditing {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        let set  = iconSets[proposedDestinationIndexPath.section]
        if proposedDestinationIndexPath.row >= set.icons.count {
            return IndexPath(item: set.icons.count-1, section: proposedDestinationIndexPath.section)
        }
        return proposedDestinationIndexPath
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

