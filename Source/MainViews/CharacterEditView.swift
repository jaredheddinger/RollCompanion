//
//  CharacterEditView.swift
//  Roll Companion (Swift)
//
//  Created by Jared Heddinger on 4/10/20.
//  Copyright © 2020 Jared Heddinger. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CharacterEditiew: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var character: Character1?
    
    var container: NSPersistentContainer!
    let races : [[Any]] = [
        ["Dragonborn", 2,0,0,0,0,1],
        ["Hill Dwarf", 0,0,2,0,1,0],
        ["Mountain Dwarf", 2,0,2,0,0,0],
        ["High Elf", 0,2,0,1,0,0],
        ["Wood Elf", 0,2,0,0,1,0],
        ["Deep Gnome", 0,1,0,2,0,0],
        ["Rock Gnome", 0,0,1,2,0,0],
        ["Half-Elf", 0,0,0,0,0,2],
        ["Lightfoot Halfling", 0,2,0,0,0,1],
        ["Stout Halfling", 0,2,1,0,0,0],
        ["Half-Orc", 2,0,1,0,0,0],
        ["Human", 1,1,1,1,1,1],
        ["Tiefling", 0,0,0,1,0,2]
    ]
    
    let classes : [[Any]] = [
        ["Barbarian",    0,   1,0,1,0,0,0,    0, 12],
        ["Bard",    1,   0,1,0,0,0,1,    5, 8],
        ["Cleric",    1,   0,0,0,0,1,1,    4, 8],
        ["Druid",    1,   0,0,0,1,1,0,    4, 8],
        
        ["Fighter",    0,   1,0,1,0,0,0,    "0,1", 10],
        ["Monk",    0,   1,1,0,0,0,0,    "1,4", 8],
        ["Paladin",    1,   0,0,0,1,0,1,    "0,5", 10],
        ["Ranger",    1,   1,1,0,0,0,0,   "1,4", 10],
        
        ["Rogue",    0,   0,1,0,1,0,0,    1, 8],
        ["Sorcerer",    1,   0,0,1,0,0,1,    5, 6],
        ["Warlock",    1,   0,0,0,0,1,1,    5, 8],
        ["Wizard",    1,   0,0,0,1,1,0,    3, 6],
    ]
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var racePickerField: UIPickerView!
    @IBOutlet weak var classPickerField: UIPickerView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelStepper: UIStepper!
    @IBAction func levelStepperChanged(_ sender: UIStepper) {
        levelLabel.text = Int(sender.value).description
    }
    
    @IBOutlet weak var strLabel: UILabel!
    @IBOutlet weak var strValue: UIStepper!
    @IBAction func strStepper(_ sender: UIStepper) {
        strLabel.text = Int(sender.value).description
    }
    
    @IBOutlet weak var dexLabel: UILabel!
    @IBOutlet weak var dexValue: UIStepper!
    @IBAction func dexStepper(_ sender: UIStepper) {
        dexLabel.text = Int(sender.value).description
    }
    
    @IBOutlet weak var conLabel: UILabel!
    @IBOutlet weak var conValue: UIStepper!
    @IBAction func conStepper(_ sender: UIStepper) {
        conLabel.text = Int(sender.value).description
    }
    
    @IBOutlet weak var intLabel: UILabel!
    @IBOutlet weak var intValue: UIStepper!
    @IBAction func intStepper(_ sender: UIStepper) {
        intLabel.text = Int(sender.value).description
    }
    
    @IBOutlet weak var wisLabel: UILabel!
    @IBOutlet weak var wisValue: UIStepper!
    @IBAction func wisStepper(_ sender: UIStepper) {
        wisLabel.text = Int(sender.value).description
    }
    
    @IBOutlet weak var chaLabel: UILabel!
    @IBOutlet weak var chaValue: UIStepper!
    @IBAction func chaStepper(_ sender: UIStepper) {
        chaLabel.text = Int(sender.value).description
    }
    
    @IBAction func saveButton(_ sender: Any) {
    }
    
    var racePickerData: [String] = [String]()
    var classPickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        racePickerField.delegate = self
        racePickerField.dataSource = self
        classPickerField.delegate = self
        classPickerField.dataSource = self
        
        nameTextField.text = character?.name
//        strValue.value = Double(Int(character?.str))
//        dexValue.value = Double(Int(character?.dex))
        
        for race in races {
            racePickerData.append(race[0] as? String ?? "")
        }
        racePickerField.selectRow(racePickerData.firstIndex(of: (character?.toRace!.name)!)!, inComponent: 0, animated: true)

        for charClass in classes {
            classPickerData.append(charClass[0] as? String ?? "")
        }
        classPickerField.selectRow(classPickerData.firstIndex(of: (character?.toClasses?[0] as! Class1).name!)!, inComponent: 0, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    @IBAction func addClassButton(_ sender: Any) {
        let insertIndex = IndexPath.init(row: self.tableView(self.tableView, numberOfRowsInSection: 2) - 2, section: 2)
        self.tableView.dequeueReusableCell(withIdentifier: "classCell", for: insertIndex)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return racePickerData.count
        }
        else if (pickerView.tag == 2) {
            return classPickerData.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return racePickerData[row]
        }
        else if (pickerView.tag == 2) {
            return classPickerData[row]
        }
        return ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if (segue.identifier == "SaveCharacter") {
            let managedContext = container.viewContext
            
//            let characterEntity = NSEntityDescription.entity(forEntityName: "Character1", in: managedContext)!
//            let raceEntity = NSEntityDescription.entity(forEntityName: "Race1", in: managedContext)!
//            let classEntity = NSEntityDescription.entity(forEntityName: "Class1", in: managedContext)!
//            let spellSlotEntity = NSEntityDescription.entity(forEntityName: "SpellSlot", in: managedContext)!
//
//            let race = NSManagedObject(entity: raceEntity, insertInto: managedContext) as? Race1
//            let charClass = NSManagedObject(entity: classEntity, insertInto: managedContext) as? Class1
//            let spellSlot = NSManagedObject(entity: spellSlotEntity, insertInto: managedContext) as? SpellSlot
            
//            race?.name = racePickerData[racePickerField.selectedRow(inComponent: 0)]
//            race?.str = races[racePickerField.selectedRow(inComponent: 0)][1] as? Int16 ?? 0
//            race?.dex = races[racePickerField.selectedRow(inComponent: 0)][2] as? Int16 ?? 0
//            race?.con = races[racePickerField.selectedRow(inComponent: 0)][3] as? Int16 ?? 0
//            race?.int = races[racePickerField.selectedRow(inComponent: 0)][4] as? Int16 ?? 0
//            race?.wis = races[racePickerField.selectedRow(inComponent: 0)][5] as? Int16 ?? 0
//            race?.con = races[racePickerField.selectedRow(inComponent: 0)][6] as? Int16 ?? 0
//
//            charClass?.name = classPickerData[classPickerField.selectedRow(inComponent: 0)]
//            charClass?.str = classes[classPickerField.selectedRow(inComponent: 0)][2] as? Int16 ?? 0 == 1
//            charClass?.dex = classes[classPickerField.selectedRow(inComponent: 0)][3] as? Int16 ?? 0 == 1
//            charClass?.con = classes[classPickerField.selectedRow(inComponent: 0)][4] as? Int16 ?? 0 == 1
//            charClass?.int = classes[classPickerField.selectedRow(inComponent: 0)][5] as? Int16 ?? 0 == 1
//            charClass?.wis = classes[classPickerField.selectedRow(inComponent: 0)][6] as? Int16 ?? 0 == 1
//            charClass?.cha = classes[classPickerField.selectedRow(inComponent: 0)][7] as? Int16 ?? 0 == 1
//            charClass?.level = Int16(levelStepper.value)
//            charClass?.spellcaster = (classes[classPickerField.selectedRow(inComponent: 0)][1] as! Int) == 1
//
//            character?.str = Int16(strValue.value)
//            character?.dex = Int16(dexValue.value)
//            character?.con = Int16(conValue.value)
//            character?.int = Int16(intValue.value)
//            character?.wis = Int16(wisValue.value)
//            character?.cha = Int16(chaValue.value)
//
            character?.name = nameTextField.text ?? ""
//            character?.maxHP =
            
//            character?.toRace = race
//            character?.toSpellSlots = spellSlot
//            charClass?.toCharacter = character
            
            
            if managedContext.hasChanges {
                managedContext.performAndWait {
                    do {
                        try managedContext.save()
                    }
                    catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
            }
            
            print("Adding character: " + character!.name)
        }
    }
}
