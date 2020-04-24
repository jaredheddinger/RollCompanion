//
//  SpellSlot+CoreDataProperties.swift
//  Roll Companion (Swift)
//
//  Created by Jared Heddinger on 3/29/20.
//  Copyright © 2020 Jared Heddinger. All rights reserved.
//
//

import Foundation
import CoreData


extension SpellSlot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpellSlot> {
        return NSFetchRequest<SpellSlot>(entityName: "SpellSlot")
    }

    @NSManaged public var used7: Int16
    @NSManaged public var used6: Int16
    @NSManaged public var used5: Int16
    @NSManaged public var used4: Int16
    @NSManaged public var used3: Int16
    @NSManaged public var used2: Int16
    @NSManaged public var used1: Int16
    @NSManaged public var used8: Int16
    @NSManaged public var used9: Int16
    @NSManaged public var toCharacter: Character1?

}

extension SpellSlot {
    public func getSlots(slot: Int) -> Int {
        switch slot {
        case 1:
            return Int(used1)
        case 2:
            return Int(used2)
        case 3:
            return Int(used3)
        case 4:
            return Int(used4)
        case 5:
            return Int(used5)
        case 6:
            return Int(used6)
        case 7:
            return Int(used7)
        case 8:
            return Int(used8)
        case 9:
            return Int(used9)
        default:
            return 0
        }
    }
    
    public func decrementSlots(slot: Int) {
        switch slot {
        case 1:
            used1 += 1
        case 2:
            used2 += 1
        case 3:
            used3 += 1
        case 4:
            used4 += 1
        case 5:
            used5 += 1
        case 6:
            used6 += 1
        case 7:
            used7 += 1
        case 8:
            used8 += 1
        case 9:
            used9 += 1
        default:
            return
        }
    }
    
    public func resetAll() {
        self.used1 = 0
        self.used2 = 0
        self.used3 = 0
        self.used4 = 0
        self.used5 = 0
        self.used6 = 0
        self.used7 = 0
        self.used8 = 0
        self.used9 = 0
    }
    
    
}
