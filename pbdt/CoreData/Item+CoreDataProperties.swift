//
//  Item+CoreDataProperties.swift
//  
//
//  Created by Andrew M Levy on 4/3/19.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var objectId: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var ssAmtWt: Double
    @NSManaged public var ssUnitWt: String?
    @NSManaged public var ssAmtVol: Double
    @NSManaged public var ssUnitVol: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var beans: Double
    @NSManaged public var berries: Double
    @NSManaged public var otherFruits: Double
    @NSManaged public var cruciferousVegetables: Double
    @NSManaged public var greens: Double
    @NSManaged public var otherVegetables: Double
    @NSManaged public var flaxseeds: Double
    @NSManaged public var nuts: Double
    @NSManaged public var turmeric: Double
    @NSManaged public var wholeGrains: Double
    @NSManaged public var otherSeeds: Double
    @NSManaged public var cals: Double
    @NSManaged public var fat: Double
    @NSManaged public var carbs: Double
    @NSManaged public var protein: Double
    @NSManaged public var variety: String?

}
