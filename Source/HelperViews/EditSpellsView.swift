//
//  CharacterDetailClassAbilityView.swift
//  Roll Companion (Swift)
//
//  Created by Jared Heddinger on 3/22/20.
//  Copyright © 2020 Jared Heddinger. All rights reserved.
//

import Foundation

import UIKit
import CoreData

class CharacterDetailSpellsView: UIViewController {
    var character : Character1?
    var container: NSPersistentContainer!
    var spells: [Spell] = []
    var charSpells: [String] = []
    
    @IBOutlet weak var searchSpell: UISearchBar!
    @IBOutlet weak var spellsTable: UITableView!
    
    @IBAction func saveAddSpells(_ sender: Any) {
        
        let destinationMainClass = character!.toClasses?.firstObject as! Class1
        let managedContext = container.viewContext
        for n in 0...spells.count {
            let cell = self.spellsTable.cellForRow(at: IndexPath(row: n, section: 0))
            if cell?.accessoryType == UITableViewCell.AccessoryType.checkmark {
                destinationMainClass.addToToSpellTest(spells[n])
            }
        }
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            }
            catch {
                fatalError()
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
//    @IBOutlet weak var spellNameLabel: UILabel!
    
    @IBAction func spellDetailButton(_ sender: Any) {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "viewSpellDetail") as! SpellDetailView

        customAlert.spell = spells[0]
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = customAlert
        self.present(customAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Load CharacterDetailSpellsView. Character = " + character.debugDescription)
        spellsTable.register(UITableViewCell.self,forCellReuseIdentifier: "addSpellsCell")
        spellsTable.delegate = self
        spellsTable.dataSource = self
        self.title = "Add Spells"

        print(charSpells)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let mainClass = character?.toClasses?[0] as! Class1
//        var charSpells : [String] = []
        for spellIn in mainClass.toSpellTest! {
            charSpells.append((spellIn as! Spell).name!)
        }
    }
    
    @objc func returnToSpells() {
        print("t")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if (segue.identifier == "returnWithAddedSpells") {
            
        }
    }
    
    func save(name: String) {
        let managedContext = container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Spell", in: managedContext)!
        let spell = NSManagedObject(entity: entity, insertInto: managedContext) as! Spell

        spell.name = name
        
        do {
            try managedContext.save()
            spells.append(spell)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}

extension CharacterDetailSpellsView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return spells.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addSpellsCell", for: indexPath)
        let spell = spells[indexPath.row]
        cell.textLabel!.text = spell.name
//        spellNameLabel.text = spell.name

        if (charSpells.contains(spell.name!)) {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (spellsTable.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            spellsTable.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            spellsTable.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
}
