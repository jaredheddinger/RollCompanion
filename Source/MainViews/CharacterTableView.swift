//
//  CharacterListView.swift
//  Roll Companion (Swift)
//
//  Created by Jared Heddinger on 2/15/20.
//  Copyright © 2020 Jared Heddinger. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CharacterTableView : UITableViewController {
    var container: NSPersistentContainer!
    var characters : [Character1] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
        print(container.persistentStoreDescriptions)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let managedContext = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Character1")
        do {
            try characters = managedContext.fetch(fetchRequest) as! [Character1]
        }
        catch {
            fatalError()
        }
        //summonGlunkus()
        self.tableView.reloadData()
    }
}

extension CharacterTableView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        return characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CharacterCell",
            for: indexPath) as! CharacterCell
        cell.character = characters[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        self.performSegue(withIdentifier: "showDetail", sender: character)
        print("Sending character = " + character.name)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
                [unowned self] action in
                    let managedContext = self.container.viewContext
                    managedContext.delete(self.characters[indexPath.row])
                    self.characters.remove(at: indexPath.row)
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
        } else if editingStyle == .insert {
        }
    }
}

extension CharacterTableView {
    @IBAction func cancelToCharacterViewController(_ segue: UIStoryboardSegue) {
        print("TEST")
    }
    
    @IBAction func saveCharacter(_ segue: UIStoryboardSegue) {
        print("TEST2")
    }
    
}

extension CharacterTableView {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "showDetail") {
            print("Prepare statement. " + segue.destination.debugDescription + sender.debugDescription )
            
            let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
            let levelUp = UIBarButtonItem(title: "Level Up", style: .plain, target: nil, action: nil)
            
            let mainVC = segue.destination as! UITabBarController
            mainVC.title = (sender as? Character1)?.name
            mainVC.navigationItem.rightBarButtonItems = [levelUp, edit]
            
            let combatVC = mainVC.viewControllers?[0] as! CharacterDetailCombatView
            combatVC.character = sender as? Character1
            combatVC.container = container
            
            let rpVC = mainVC.viewControllers?[1] as! CharacterDetailRoleplayView
            rpVC.character = sender as? Character1
            rpVC.container = container
            
            if ((sender as? Character1)?.toClasses?.contains(where: {($0 as? Class1)?.spellcaster == true}))! {
                let playerSpellsVC = mainVC.viewControllers?[2] as! CharacterDetailAvailableSpellsView
                playerSpellsVC.character = sender as? Character1
                playerSpellsVC.container = container
            }
            else {
                mainVC.viewControllers?.remove(at: 2)
            }
            
        }
        else if (segue.identifier == "buildCharacter") {
            let buildNav = segue.destination as! UINavigationController
            let buildVC = buildNav.viewControllers[0] as! CharacterBuildView
            buildVC.container = container
            
        }
    }
    
//    func summonGlunkus() {
//        let managedContext = container.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Character1")
//        fetchRequest.predicate = NSPredicate(format: "name == %@", "Glunkus")
//        var glunk : Character1
//        do {
//            glunk = try managedContext.fetch(fetchRequest)[0] as! Character1
//        }
//        catch {
//            fatalError()
//        }
//
//        let weaponEntity = NSEntityDescription.entity(forEntityName: "Weapon", in: managedContext)!
//        let weapon = NSManagedObject(entity: weaponEntity, insertInto: managedContext) as? Weapon
//        weapon?.name = "Spear's Staff of Swording"
//        weapon?.damage = 8
//        weapon?.modifier = 0
//        weapon?.proficiency = false
//        glunk.addToToWeapons(weapon!)
//
//        do {
//            try managedContext.save()
//        }
//        catch {
//            fatalError()
//        }
//
//    }

}

