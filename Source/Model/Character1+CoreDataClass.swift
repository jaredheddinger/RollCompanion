//
//  Character1+CoreDataClass.swift
//  Roll Companion (Swift)
//
//  Created by Jared Heddinger on 4/5/20.
//  Copyright © 2020 Jared Heddinger. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Character1)
public class Character1: NSManagedObject {
    
    func getStrengthModifier() -> Int {
        return Int((Double(str - 10) / Double(2)).rounded(.down))
    }
    
    func getDexterityModifier() -> Int {
        return Int((Double(dex - 10) / Double(2)).rounded(.down))
    }
    
    func getConstitutionModifier() -> Int {
        return Int((Double(con - 10) / Double(2)).rounded(.down))
    }
    
    func getIntelligenceModifier() -> Int {
        return Int((Double(int - 10) / Double(2)).rounded(.down))
    }
    
    func getWisdomModifier() -> Int {
        return Int((Double(wis - 10) / Double(2)).rounded(.down))
    }
    
    func getCharismaModifier() -> Int {
        return Int((Double(cha - 10) / Double(2)).rounded(.down))
    }
    
    func getProficiency() -> Int {
        return Int(((level - 1) / 4 ) + 2)
    }
}
