//
//  Character1+CoreDataProperties.swift
//  Roll Companion (Swift)
//
//  Created by Jared Heddinger on 4/5/20.
//  Copyright © 2020 Jared Heddinger. All rights reserved.
//
//

import Foundation
import CoreData


extension Character1 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Character1> {
        return NSFetchRequest<Character1>(entityName: "Character1")
    }

    @NSManaged public var cha: Int16
    @NSManaged public var con: Int16
    @NSManaged public var dex: Int16
    @NSManaged public var int: Int16
    public var level: Int16 {
        get {
            return self.toClasses?.reduce(0, {$0 + ($1 as! Class1).level}) ?? 1
        }
    }
    @NSManaged public var name: String
    @NSManaged public var str: Int16
    @NSManaged public var wis: Int16
    @NSManaged public var toClasses: NSOrderedSet?
    @NSManaged public var toRace: Race1?
    @NSManaged public var toSpellSlots: SpellSlot?
    @NSManaged public var toWeapons: NSOrderedSet?
    @NSManaged public var toItems: NSOrderedSet?
    @NSManaged public var maxHP: Int32
    @NSManaged public var currentHP: Int32
}

// MARK: Generated accessors for toClasses
extension Character1 {

    @objc(insertObject:inToClassesAtIndex:)
    @NSManaged public func insertIntoToClasses(_ value: Class1, at idx: Int)

    @objc(removeObjectFromToClassesAtIndex:)
    @NSManaged public func removeFromToClasses(at idx: Int)

    @objc(insertToClasses:atIndexes:)
    @NSManaged public func insertIntoToClasses(_ values: [Class1], at indexes: NSIndexSet)

    @objc(removeToClassesAtIndexes:)
    @NSManaged public func removeFromToClasses(at indexes: NSIndexSet)

    @objc(replaceObjectInToClassesAtIndex:withObject:)
    @NSManaged public func replaceToClasses(at idx: Int, with value: Class1)

    @objc(replaceToClassesAtIndexes:withToClasses:)
    @NSManaged public func replaceToClasses(at indexes: NSIndexSet, with values: [Class1])

    @objc(addToClassesObject:)
    @NSManaged public func addToToClasses(_ value: Class1)

    @objc(removeToClassesObject:)
    @NSManaged public func removeFromToClasses(_ value: Class1)

    @objc(addToClasses:)
    @NSManaged public func addToToClasses(_ values: NSOrderedSet)

    @objc(removeToClasses:)
    @NSManaged public func removeFromToClasses(_ values: NSOrderedSet)

}

// MARK: Generated accessors for toWeapons
extension Character1 {

    @objc(insertObject:inToWeaponsAtIndex:)
    @NSManaged public func insertIntoToWeapons(_ value: Weapon, at idx: Int)

    @objc(removeObjectFromToWeaponsAtIndex:)
    @NSManaged public func removeFromToWeapons(at idx: Int)

    @objc(insertToWeapons:atIndexes:)
    @NSManaged public func insertIntoToWeapons(_ values: [Weapon], at indexes: NSIndexSet)

    @objc(removeToWeaponsAtIndexes:)
    @NSManaged public func removeFromToWeapons(at indexes: NSIndexSet)

    @objc(replaceObjectInToWeaponsAtIndex:withObject:)
    @NSManaged public func replaceToWeapons(at idx: Int, with value: Weapon)

    @objc(replaceToWeaponsAtIndexes:withToWeapons:)
    @NSManaged public func replaceToWeapons(at indexes: NSIndexSet, with values: [Weapon])

    @objc(addToWeaponsObject:)
    @NSManaged public func addToToWeapons(_ value: Weapon)

    @objc(removeToWeaponsObject:)
    @NSManaged public func removeFromToWeapons(_ value: Weapon)

    @objc(addToWeapons:)
    @NSManaged public func addToToWeapons(_ values: NSOrderedSet)

    @objc(removeToWeapons:)
    @NSManaged public func removeFromToWeapons(_ values: NSOrderedSet)

}

extension Character1 {
    
    @objc(insertObject:inToItemsAtIndex:)
    @NSManaged public func insertIntoToItems(_ value: Item, at idx: Int)
    
    @objc(removeObjectFromToItemsAtIndex:)
    @NSManaged public func removeFromToItems(at idx: Int)
    
    @objc(insertToItems:atIndexes:)
    @NSManaged public func insertIntoToItems(_ values: [Item], at indexes: NSIndexSet)
    
    @objc(removeToItemsAtIndexes:)
    @NSManaged public func removeFromToItems(at indexes: NSIndexSet)
    
    @objc(replaceObjectInToItemsAtIndex:withObject:)
    @NSManaged public func replaceToItems(at idx: Int, with value: Item)
    
    @objc(replaceToItemsAtIndexes:withToItems:)
    @NSManaged public func replaceToItems(at indexes: NSIndexSet, with values: [Item])
    
    @objc(addToItemsObject:)
    @NSManaged public func addToToItems(_ value: Item)
    
    @objc(removeToItemsObject:)
    @NSManaged public func removeFromToItems(_ value: Item)
    
    @objc(addToItems:)
    @NSManaged public func addToToItems(_ values: NSOrderedSet)
    
    @objc(removeToItems:)
    @NSManaged public func removeFromToItems(_ values: NSOrderedSet)
    
}
