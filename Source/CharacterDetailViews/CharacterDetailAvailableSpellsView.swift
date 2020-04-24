//
//  CharacterDetailAvailableSpellsView.swift
//  Roll Companion (Swift)
//
//  Created by Jared Heddinger on 3/27/20.
//  Copyright © 2020 Jared Heddinger. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CharacterDetailAvailableSpellsView : UIViewController {
    var character : Character1!
    var container: NSPersistentContainer!
    var availableSpellsToCast = [[Spell?]](repeating: [], count: 10)
    var preparedSpells = [[Spell?]](repeating: [], count: 10)
    
    lazy var addSpells : UIBarButtonItem = {
        return UIBarButtonItem(title: "Edit Spells", style: .done, target: self, action: #selector(self.presentAddSpells))
    }()
    
//    var allSpells : [Spell] = []
    @IBOutlet weak var selectionItem: UISegmentedControl!
    
    @IBAction func selectionChange(_ sender: Any) {
        sortData()
        self.availableSpellsTable.reloadData()
//        self.availableSpellsTable.insert
//        self.availableSpellsTable.insertRows(at: Ind, with: .left)
    }
    

    @IBAction func resetSpellSlots(_ sender: Any) {
        let managedContext = container.viewContext
        let alert = UIAlertController(title: "Reset Spell Slots?", message: "This action will reset all the character's spell slots.", preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) {
            [unowned self] action in
            self.character?.toSpellSlots?.resetAll()
            if managedContext.hasChanges {
                do {
                    try managedContext.save()
                }
                catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
            for n in 1...9 {
                if (self.availableSpellsTable.numberOfRows(inSection: n) == 0) {
                    self.availableSpellsTable.reloadSections(IndexSet.init(arrayLiteral: n), with: .left)
                }
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alert.addAction(resetAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
    let maxSpellSlotsForLevel : [[Int16]] = [
        [2,0,0,0,0,0,0,0,0],
        [3,0,0,0,0,0,0,0,0],
        [4,2,0,0,0,0,0,0,0],
        [4,3,0,0,0,0,0,0,0],
        [4,3,2,0,0,0,0,0,0],
        [4,3,3,0,0,0,0,0,0],
        [4,3,3,1,0,0,0,0,0],
        [4,3,3,2,0,0,0,0,0],
        [4,3,3,3,1,0,0,0,0],
        [4,3,3,3,2,0,0,0,0],
        [4,3,3,3,2,1,0,0,0],
        [4,3,3,3,2,1,0,0,0],
        [4,3,3,3,2,1,1,0,0],
        [4,3,3,3,2,1,1,0,0],
        [4,3,3,3,2,1,1,1,0],
        [4,3,3,3,2,1,1,1,0],
        [4,3,3,3,2,1,1,1,1],
        [4,3,3,3,3,1,1,1,1],
        [4,3,3,3,2,2,1,1,1],
        [4,3,3,3,3,2,2,1,1],
    ]
    
    @IBOutlet weak var availableSpellsTable: UITableView!
    
    func spellSlotsRemainingForLevel(charLevel: Int, spellLevel: Int) -> Int {
        let maxAvailableSpellSlots = maxSpellSlotsForLevel[charLevel - 1][spellLevel - 1]
        let usedSpellSlots = (character.toSpellSlots?.getSlots(slot: spellLevel))!
        return Int(maxAvailableSpellSlots) - Int(usedSpellSlots)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        availableSpellsTable.delegate = self
        availableSpellsTable.dataSource = self
        availableSpellsTable.register(UITableViewCell.self,forCellReuseIdentifier: "Cell")
        availableSpellsTable.reloadData()
        
        availableSpellsTable.register(SpellSectionHeader.self,
                           forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        //TODO
        selectionItem.removeSegment(at: 2, animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItems?.insert(addSpells, at: 0)
        sortData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItems?.remove(at: 0)
    }
    
    @objc func presentAddSpells() {
        let editSpellVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editSpellsView") as! CharacterDetailSpellsView
        editSpellVC.character = character
        editSpellVC.container = container

        let managedContext = container.viewContext
        let fetchRequest = NSFetchRequest<Spell>(entityName: "Spell")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let maxSpellLevel = maxSpellSlotsForLevel[Int(character.level)].firstIndex(where: {$0 == 0})!
        fetchRequest.predicate = NSPredicate(format: "level <= %ld", maxSpellLevel)

        
        do {
            editSpellVC.spells = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        present(editSpellVC, animated: true, completion: {
            self.sortData()
            self.availableSpellsTable.reloadData()
        })
    }

}

extension CharacterDetailAvailableSpellsView: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectionItem.selectedSegmentIndex == 0 {
            return availableSpellsToCast.count
        }
        else {
            return preparedSpells.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Using Swift's optional lookup we first check if there is a valid section of table.
        // Then we check that for the section there is data that goes with.
        if (selectionItem.selectedSegmentIndex == 0) {
            if section == 0 {
                return availableSpellsToCast[section].count
            }
            else if spellSlotsRemainingForLevel(charLevel: Int(character.level), spellLevel: section) > 0 {
                return availableSpellsToCast[section].count
            }
            else {
                return 0
            }
        }
        else {
            return preparedSpells[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if selectionItem.selectedSegmentIndex == 0 {
            let spell = availableSpellsToCast[indexPath.section][indexPath.row]
            cell.textLabel?.text = spell!.name
        }
        else {
            let spell = preparedSpells[indexPath.section][indexPath.row]
            cell.textLabel?.text = spell!.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 25
        }
        else if maxSpellSlotsForLevel[Int(character.level)][section - 1] == 0 {
            return 0
        }
        return 25
    }
    
    func tableView(_ tableView: UITableView,viewForHeaderInSection section: Int) -> UIView? {
        let view = availableSpellsTable.dequeueReusableHeaderFooterView(withIdentifier:
            "sectionHeader") as! SpellSectionHeader
        switch section {
            case 0:
                view.levelLabel.text = "Cantrip"
            default:
                view.levelLabel.text = "Level " + String(section)
        }
        if (selectionItem.selectedSegmentIndex == 0) {
            if section == 0 {
                view.remainingSlotsLabel.text = "Unlimited slots remaining"
            }
            else {
                view.remainingSlotsLabel.text = String(spellSlotsRemainingForLevel(charLevel: Int(character.level), spellLevel: section)) + " slots remaining"
            }
        }
        else {
            view.remainingSlotsLabel.text = ""
        }
        return view
    }
//    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "castSpellDetail") as! SpellDetailCastView
        customAlert.spell = availableSpellsToCast[indexPath.section][indexPath.row]
        customAlert.level = indexPath.section
        customAlert.character = character

        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = customAlert
        self.present(customAlert, animated: true, completion: {
            self.availableSpellsTable.reloadData()
            let managedContext = self.container.viewContext
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
        })
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Remove Spell", message: "Are you sure you want to remove this spell?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive) {
                [unowned self] action in
                //                    self.characterDataSource.characters.remove(at: indexPath.row)
                let managedContext = self.container.viewContext
                let mainClass = self.character.toClasses?.firstObject as! Class1
                
                if (self.selectionItem.selectedSegmentIndex == 0) {
                    mainClass.removeFromToSpellTest(self.availableSpellsToCast[indexPath.section][indexPath.row]!)
                    self.availableSpellsToCast[indexPath.section].remove(at: indexPath.row)
                }
                else {
                    mainClass.removeFromToSpellTest(self.preparedSpells[indexPath.section][indexPath.row]!)
                    self.preparedSpells[indexPath.section].remove(at: indexPath.row)
                }
                tableView.deleteRows(at: [indexPath], with: .fade)

                if managedContext.hasChanges {
                    do {
                        try managedContext.save()
                    }
                    catch {
                        fatalError()
                    }
                }
                tableView.reloadData()
                return
            }
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    
    func sortData() {
        let mainClass = (character.toClasses?[0] as? Class1)!
        let characterMaxSpellSlot : Int = maxSpellSlotsForLevel[Int(character.level)].firstIndex(where: {$0 == 0})!
        guard let mainClassKnownSpells = mainClass.toSpellTest?.allObjects as? [Spell] else { return }
        for n in 0...characterMaxSpellSlot {
            availableSpellsToCast[n] = mainClassKnownSpells.filter(
                {
                (
                    ($0.level == n) ||
                    ($0.upcast && $0.level <= n )
                )
                }).sorted(by:
                    {
                        $0.name! < $1.name!
                    }
            )
            preparedSpells[n] = mainClassKnownSpells.filter(
                {
                (
                    ($0.level == n)
                )
                }).sorted(by:
                    {
                        $0.name! < $1.name!
                    }
            )
        }
    }
    
}

class SpellSectionHeader : UITableViewHeaderFooterView {
    var levelLabel = UILabel()
    var remainingSlotsLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingSlotsLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        remainingSlotsLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        contentView.addSubview(levelLabel)
        contentView.addSubview(remainingSlotsLabel)
        
        // Center the image vertically and place it near the leading
        // edge of the view. Constrain its width and height to 50 points.
        NSLayoutConstraint.activate([
            levelLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            levelLabel.heightAnchor.constraint(equalToConstant: 30),
            
            levelLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Center the label vertically, and use it to fill the remaining
            // space in the header view.
            remainingSlotsLabel.heightAnchor.constraint(equalToConstant: 30),
            remainingSlotsLabel.trailingAnchor.constraint(equalTo:
                contentView.layoutMarginsGuide.trailingAnchor),
            remainingSlotsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
}
