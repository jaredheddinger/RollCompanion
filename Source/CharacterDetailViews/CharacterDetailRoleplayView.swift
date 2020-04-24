//
//  CharacterDetailRoleplayView.swift
//  Roll Companion (Swift)
//
//  Created by Jared Heddinger on 3/22/20.
//  Copyright © 2020 Jared Heddinger. All rights reserved.
//

import Foundation

import UIKit
import CoreData

class CharacterDetailRoleplayView: UIViewController {
    var character : Character1?
    var container: NSPersistentContainer!

    @IBOutlet weak var skillTable: CharacterDetailRoleplaySkillTable!
    @IBOutlet weak var itemTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Load CharacterDetailTabView. Character = " + character.debugDescription)
        skillTable.delegate = skillTable
        skillTable.dataSource = skillTable
        skillTable.character = character
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
//        itemTable.character = character
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "returnToCharacterList") {
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
}

class SkillCell : UITableViewCell {
    
    @IBOutlet weak var leftSkillLabel: UILabel!
    @IBOutlet weak var leftSkillValue: UILabel!
    
    @IBOutlet weak var rightSkillLabel: UILabel!
    @IBOutlet weak var rightSkillValue: UILabel!
    
}


class CharacterDetailRoleplaySkillTable : UITableView, UITableViewDelegate, UITableViewDataSource {
    var character : Character1?
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height + 20)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Skills"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as! SkillCell
        switch indexPath.row {
        case 0:
            cell.leftSkillLabel.text = "Acrobatics"
            cell.leftSkillValue.text = ((character?.getDexterityModifier())! > 0 ? "+" : "") +  (character?.getDexterityModifier().description)!
            cell.rightSkillLabel.text = "Medicine"
            cell.rightSkillValue.text =
                ((character?.getWisdomModifier())! > 0 ? "+" : "") + (character?.getWisdomModifier().description)!
        case 1:
            cell.leftSkillValue.text = "Animal Handling"
            cell.leftSkillValue.text =                 ((character?.getWisdomModifier())! > 0 ? "+" : "") + (character?.getWisdomModifier().description)!
            cell.rightSkillLabel.text = "Nature"
            cell.rightSkillValue.text =                 ((character?.getIntelligenceModifier())! > 0 ? "+" : "") + (character?.getIntelligenceModifier().description)!
        case 2:
            cell.leftSkillLabel.text = "Arcana"
            cell.leftSkillValue.text = ((character?.getIntelligenceModifier())! > 0 ? "+" : "") + (character?.getIntelligenceModifier().description)!
            cell.rightSkillLabel.text = "Perception"
            cell.rightSkillValue.text =                 ((character?.getWisdomModifier())! > 0 ? "+" : "") + (character?.getWisdomModifier().description)!
        case 3:
            cell.leftSkillValue.text = "Athletics"
            cell.leftSkillValue.text = ((character?.getStrengthModifier())! > 0 ? "+" : "") + (character?.getStrengthModifier().description)!
            cell.rightSkillLabel.text = "Performance"
            cell.rightSkillValue.text = ((character?.getCharismaModifier())! > 0 ? "+" : "") + (character?.getCharismaModifier().description)!
        case 4:
            cell.leftSkillLabel.text = "Deception"
            cell.leftSkillValue.text =                 ((character?.getWisdomModifier())! > 0 ? "+" : "") + (character?.getWisdomModifier().description)!
            cell.rightSkillLabel.text = "Persuasion"
            cell.rightSkillValue.text = ((character?.getCharismaModifier())! > 0 ? "+" : "") + (character?.getCharismaModifier().description)!
        case 5:
            cell.leftSkillValue.text = "History"
            cell.leftSkillValue.text = ((character?.getIntelligenceModifier())! > 0 ? "+" : "") + (character?.getIntelligenceModifier().description)!
            cell.rightSkillLabel.text = "Religion"
            cell.rightSkillValue.text = ((character?.getIntelligenceModifier())! > 0 ? "+" : "") + (character?.getIntelligenceModifier().description)!
        case 6:
            cell.leftSkillLabel.text = "Insight"
            cell.leftSkillValue.text =                 ((character?.getWisdomModifier())! > 0 ? "+" : "") + (character?.getWisdomModifier().description)!
            cell.rightSkillLabel.text = "Sleight of Hand"
            cell.rightSkillValue.text = ((character?.getDexterityModifier())! > 0 ? "+" : "") +  (character?.getDexterityModifier().description)!
        case 7:
            cell.leftSkillValue.text = "Intimidation"
            cell.leftSkillValue.text = ((character?.getCharismaModifier())! > 0 ? "+" : "") + (character?.getCharismaModifier().description)!
            cell.rightSkillLabel.text = "Stealth"
            cell.rightSkillValue.text = ((character?.getDexterityModifier())! > 0 ? "+" : "") +  (character?.getDexterityModifier().description)!
        case 8:
            cell.leftSkillValue.text = "Investigation"
            cell.leftSkillValue.text = ((character?.getIntelligenceModifier())! > 0 ? "+" : "") + (character?.getIntelligenceModifier().description)!
            cell.rightSkillLabel.text = "Survival"
            cell.rightSkillValue.text =                 ((character?.getWisdomModifier())! > 0 ? "+" : "") + (character?.getWisdomModifier().description)!
        default:
            cell.leftSkillLabel.text = ""
            
        }
        
        return cell
    }
    
    
}

extension CharacterDetailRoleplayView : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Items"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return (character?.toItems?.count)! + 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            if (indexPath.row < (tableView.numberOfRows(inSection: indexPath.section) - 1)) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
                let item = character?.toItems?[indexPath.row] as! Item
                
                cell.textLabel?.text = item.name
                return cell
            }
            else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "Add New Item"
                cell.textLabel?.textColor = self.view.tintColor
                return cell
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row < (tableView.numberOfRows(inSection: indexPath.section) - 1)) {
            let alert = UIAlertController(title: (character?.toItems?[indexPath.row] as! Item).name, message: (character?.toItems?[indexPath.row] as! Item).text, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Close", style: .default)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
        else {
            
            let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            let name = alert.textFields?[0]
            name?.placeholder = "Name of Item"
            
            alert.addTextField(configurationHandler: nil)
            let text = alert.textFields?[1]
            text?.placeholder = "Description for Item"
            
            let cancelAction = UIAlertAction(title: "Close", style: .cancel)
            
            let saveAction = UIAlertAction(title: "Save", style: .destructive, handler: { (handler) in
                let managedContext = self.container.viewContext
                let item = Item(context: managedContext)
                item.name = name?.text
                item.text = text?.text
                item.toCharacter = self.character
                do {
                    try managedContext.save()
                }
                catch {
                    fatalError("\(error)")
                }
                tableView.insertRows(at: [indexPath], with: .left)
                return
            })
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete", message: "Delete this weapon?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
                [unowned self] action in
                let managedContext = self.container.viewContext
            managedContext.delete(self.character?.toItems?[indexPath.row] as! Item)
                self.character?.removeFromToItems(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                do {
                    try managedContext.save()
                }
                catch {
                    fatalError("\(error)")
                }
                //
                return
            }
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
}
