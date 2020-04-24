//
//  Character.swift
//  Roll Companion (Swift)
//
//  Created by Jared Heddinger on 2/15/20.
//  Copyright © 2020 Jared Heddinger. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CharacterDataSource : NSObject {
    var characters : [Character]
    var container : NSPersistentContainer!
    
    static func gen() -> [Character] {
        let glu = Character(name: "Glunkus")
        glu.setAbilities(ability: Ability.str, value: 8)
        glu.setAbilities(ability: Ability.dex, value: 14)
        glu.setAbilities(ability: Ability.con, value: 14)
        glu.setAbilities(ability: Ability.int, value: 14)
        glu.setAbilities(ability: Ability.wis, value: 12)
        glu.setAbilities(ability: Ability.cha, value: 15)
        glu.setSkillProficiency(skillName: "Acrobatics", proficient: true)
        glu.setSkillProficiency(skillName: "Arcana", proficient: true)
        glu.setSkillProficiency(skillName: "Insight", proficient: true)
        glu.setSkillProficiency(skillName: "Investigation", proficient: true)
        glu.setSkillProficiency(skillName: "Perception", proficient: true)
        glu.setSkillProficiency(skillName: "Performance", proficient: true)
        glu.setSkillProficiency(skillName: "Sleight of Hand", proficient: true)
        glu.setSkillProficiency(skillName: "Stealth", proficient: true)
        glu.classes[0] = Class("Bard", level: 6)
        
        return [
            glu,
            Character(name: "Orion")
        ]
    }
    
    override init() {
        characters = CharacterDataSource.gen()
    }
    
    func numberOfCharacters() -> Int {
        return characters.count
    }
    
    func character(at indexPath: IndexPath) -> Character {
        return characters[indexPath.row]
    }
    
    func append(character: Character, to tableView: UITableView) {
        characters.append(character)
        tableView.insertRows(at: [IndexPath(row: characters.count-1, section: 0)], with: .automatic)
    }
}
