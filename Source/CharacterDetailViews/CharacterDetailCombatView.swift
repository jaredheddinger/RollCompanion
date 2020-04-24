//
//  CharacterDetailCombatTabView.swift
//  Roll Companion (Swift)
//
//  Created by Jared Heddinger on 3/22/20.
//  Copyright © 2020 Jared Heddinger. All rights reserved.
//

import Foundation

import UIKit
import CoreData

class CharacterDetailCombatView: UIViewController {
    @IBOutlet weak var armorClassLabel: UILabel!
    @IBOutlet weak var initiativeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var proficiencyLabel: UILabel!
    
    
    @IBOutlet weak var strLabel: UILabel!
    @IBOutlet weak var strModLabel: UILabel!
    @IBOutlet weak var dexLabel: UILabel!
    @IBOutlet weak var dexModLabel: UILabel!
    @IBOutlet weak var conLabel: UILabel!
    @IBOutlet weak var conModLabel: UILabel!
    @IBOutlet weak var intLabel: UILabel!
    @IBOutlet weak var intModLabel: UILabel!
    @IBOutlet weak var wisLabel: UILabel!
    @IBOutlet weak var wisModLabel: UILabel!
    @IBOutlet weak var chaLabel: UILabel!
    @IBOutlet weak var chaModLabel: UILabel!
    
    @IBOutlet weak var currentHitPointsLabel: UILabel!
    @IBOutlet weak var maxHitPointsLabel: UILabel!
    @IBOutlet weak var weaponsTableView: UITableView!
    
//    @IBOutlet weak var weaponsTable: UITableView!
    
    @IBAction func damageButton(_ sender: UIBarButtonItem) {
        let customAlert = UIAlertController(title: "Take Damage", message: "How much damage did you take?", preferredStyle: .alert)
        customAlert.addTextField(configurationHandler: nil)
        let input = customAlert.textFields?[0]
        input?.placeholder = "Damage"
        input?.keyboardType = .numberPad
        let presentingView = self
        
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .destructive, handler: { (handler) in
            self.character?.currentHP -= Int32(input?.text ?? "0") ?? 0
            do {
                try self.container.viewContext.save()
            }
            catch {
                fatalError()
            }
            presentingView.viewWillAppear(true)
        })
        
        customAlert.addAction(closeAction)
        customAlert.addAction(saveAction)
        
        present(customAlert, animated: true, completion: nil)
    }
    
    @IBAction func healButton(_ sender: UIBarButtonItem) {
        let customAlert = UIAlertController(title: "Heal Damage", message: "How much did you heal?", preferredStyle: .alert)
        customAlert.addTextField(configurationHandler: nil)
        let input = customAlert.textFields?[0]
        input?.placeholder = "Heal"
        input?.keyboardType = .numberPad
        let presentingView = self
        
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .destructive, handler: { (handler) in
            self.character?.currentHP += Int32(input?.text ?? "0") ?? 0
            do {
                try self.container.viewContext.save()
            }
            catch {
                fatalError()
            }
            presentingView.viewWillAppear(true)
        })
        
        customAlert.addAction(closeAction)
        customAlert.addAction(saveAction)
        
        present(customAlert, animated: true, completion: nil)
    }
    
    @IBAction func resetButton(_ sender: UIBarButtonItem) {
        let customAlert = UIAlertController(title: "Reset Damage", message: "Are you sure you want to reset any damage taken?", preferredStyle: .alert)
        let presentingView = self
        
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .destructive, handler: { (handler) in
            self.character?.currentHP = self.character!.maxHP
            do {
                try self.container.viewContext.save()
            }
            catch {
                fatalError()
            }
            presentingView.viewWillAppear(true)
        })
        
        customAlert.addAction(closeAction)
        customAlert.addAction(saveAction)
        
        present(customAlert, animated: true, completion: nil)
    }
    
    
    var character: Character1?
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Load CharacterDetailTabView. Character = " + character.debugDescription)
        weaponsTableView.register(UITableViewCell.self,forCellReuseIdentifier: "weaponCell")
        weaponsTableView.delegate = self
        weaponsTableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (character != nil) {
            currentHitPointsLabel.text = character?.currentHP.description
            maxHitPointsLabel.text = character?.maxHP.description
            
            proficiencyLabel.text = ((character?.getProficiency())! > 0 ? "+" : "") +  (character?.getProficiency().description)!
            
            strLabel.text = character?.str.description
            dexLabel.text = character?.dex.description
            conLabel.text = character?.con.description
            intLabel.text = character?.int.description
            wisLabel.text = character?.wis.description
            chaLabel.text = character?.cha.description
            
            strModLabel.text = ((character?.getStrengthModifier())! > 0 ? "+" : "") + (character?.getStrengthModifier().description)!
            dexModLabel.text = ((character?.getDexterityModifier())! > 0 ? "+" : "") + (character?.getDexterityModifier().description)!
            conModLabel.text = ((character?.getConstitutionModifier())! > 0 ? "+" : "") + (character?.getConstitutionModifier().description)!
            intModLabel.text = ((character?.getIntelligenceModifier())! > 0 ? "+" : "") + (character?.getIntelligenceModifier().description)!
            wisModLabel.text = ((character?.getWisdomModifier())! > 0 ? "+" : "") + (character?.getWisdomModifier().description)!
            chaModLabel.text = ((character?.getCharismaModifier())! > 0 ? "+" : "") + (character?.getCharismaModifier().description)!
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if (segue.identifier == "returnToCharacterList") {
            
        }
    }
}

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}

extension CharacterDetailCombatView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return (character?.toWeapons?.count)! + 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            if (indexPath.row < (tableView.numberOfRows(inSection: indexPath.section) - 1)) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WeaponCell", for: indexPath)
                let weapon = character?.toWeapons?[indexPath.row] as! Weapon
                
                cell.textLabel?.text = weapon.name
                cell.detailTextLabel?.text = weapon.damage
                return cell
            }
            else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "Add New Weapon"
                cell.textLabel?.textColor = self.view.tintColor
                return cell
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row < (tableView.numberOfRows(inSection: indexPath.section) - 1)) {
            let alert = UIAlertController(title: (character?.toWeapons?[indexPath.row] as! Weapon).name, message: (character?.toWeapons?[indexPath.row] as! Weapon).text, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Close", style: .default)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
        else {
            
            let alert = UIAlertController(title: "Add Weapon:", message: nil, preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            let name = alert.textFields?[0]
            name?.placeholder = "Name of Weapon"
            
            alert.addTextField(configurationHandler: nil)
            let damage = alert.textFields?[1]
            damage?.placeholder = "Damage"
            
            alert.addTextField(configurationHandler: nil)
            let text = alert.textFields?[2]
            text?.placeholder = "Description for Weapon"
            
            let cancelAction = UIAlertAction(title: "Close", style: .cancel)
            
            let saveAction = UIAlertAction(title: "Save", style: .destructive, handler: { (handler) in
                let managedContext = self.container.viewContext
                let weapon = Weapon(context: managedContext)
                weapon.name = name?.text
                weapon.damage = damage?.text ?? "0"
                weapon.text = text?.text
//                weapon.proficiency = (proficient?.text == "Y" ? true : false)
                weapon.toCharacter = self.character
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
            return 
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Weapons"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete", message: "Delete this weapon?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
                [unowned self] action in
                let managedContext = self.container.viewContext
                managedContext.delete(self.character?.toWeapons?[indexPath.row] as! Weapon)
                self.character?.removeFromToWeapons(at: indexPath.row)
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
