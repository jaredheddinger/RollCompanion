//
//  Character.swift
//  Roll Companion (Swift)
//
//  Created by Jared Heddinger on 2/18/20.
//  Copyright © 2020 Jared Heddinger. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum Ability: Int {
    case str, dex, con, int, wis, cha

    func desc() -> String {
        switch self {
        case .str:
            return "Strength"
        case .dex:
            return "Dexterity"
        case .con:
            return "Constitution"
        case .int:
            return "Intelligence"
        case .wis:
            return "Wisdom"
        case .cha:
            return "Charisma"
        }
    }
}

class Skill {
    var name: String
    var ability: Ability
    var proficient: Bool

    init(_ name: String,_ ability: Ability) {
        self.name = name
        self.ability = ability
        self.proficient = false
    }
}

class Skills {
    var skills = [Skill]()

    init() {
        skills.append(Skill("Acrobatics", Ability.dex))
        skills.append(Skill("Animal Handling", Ability.wis))
        skills.append(Skill("Arcana", Ability.int))
        skills.append(Skill("Athletics", Ability.str))
        skills.append(Skill("Deception", Ability.cha))
        skills.append(Skill("History", Ability.int))
        skills.append(Skill("Insight", Ability.wis))
        skills.append(Skill("Intimidation", Ability.cha))
        skills.append(Skill("Investigation", Ability.int))
        skills.append(Skill("Medicine", Ability.wis))
        skills.append(Skill("Nature", Ability.int))
        skills.append(Skill("Perception", Ability.wis))
        skills.append(Skill("Performance", Ability.cha))
        skills.append(Skill("Persuasion", Ability.cha))
        skills.append(Skill("Religion", Ability.int))
        skills.append(Skill("Sleight of Hand", Ability.dex))
        skills.append(Skill("Stealth", Ability.dex))
        skills.append(Skill("Survival", Ability.wis))
    }
}

class Race {
    var raceName: String?
    var traits = [0,0,0,0,0,0]

    init() {
        self.raceName = ""
    }

    init(raceName: String) {
        self.raceName = raceName
    }
}

class HillDwarf : Race {
    override init() {
        super.init(raceName: "Hill Dwarf")
        super.traits[Ability.wis.rawValue] = 1
    }
}

class MountainDwarf : Race {
    override init() {
        super.init(raceName: "Mountain Dwarf")
        super.traits[Ability.con.rawValue] = 2
    }
}

class Class {
    var className: String?
    var traits = [0,0,0,0,0,0]
    var classLevel: Int
    var knownSpells : [Spell] = []


    init(_ className: String) {
        self.className = className
        self.classLevel = 1
    }

    init(_ className: String, level: Int) {
        self.className = className
        self.classLevel = level
    }
}

class Bard : Class {

    init() {
        super.init("Bard")
    }
}

class Character {
    var name: String
    var race: Race
    var abilities = [0,0,0,0,0,0]
    var classes = [Class]()
    var skills = Skills()

    init(name: String) {
        self.name = name
        self.race = HillDwarf()
        for index in 0..<abilities.count {
            abilities[index] = 10
        }
        self.classes.append(Bard())
    }

    func getAbility(_ ability: Ability) -> Int {
        return self.abilities[ability.rawValue] + self.race.traits[ability.rawValue]
    }

    func getModifier(_ ability: Ability) -> Int {
        return Int((Double(getAbility(ability) - 10) / Double(2)).rounded(.down))
    }

    func getLevel() -> Int {
        return classes.reduce(0) { $0 + $1.classLevel}
    }

    func getProficiency() -> Int {
        return (((getLevel() - 1) / 4 ) + 2)
    }

    func getSavingThrow(_ ability: Ability) -> Int {
        return getModifier(ability) + getProficiency()
    }

    func getName() -> String {
        return name
    }

    func getSkill(skillName: String) -> String {
        if let skill = self.skills.skills.first(where: {$0.name == skillName}) {
            let value = self.getModifier(skill.ability) + (skill.proficient ? self.getProficiency() : 0)
            return (value > 0 ? "+" : "") + String(value)
        }
        else {
            return ""
        }

    }

    func setAbilities(ability: Ability, value: Int) {
        self.abilities[ability.rawValue] = value
    }

    func setSkillProficiency(skillName: String, proficient: Bool) {
        if let skill = self.skills.skills.first(where: {$0.name == skillName}) {
            skill.proficient = proficient
        }
    }

}

