//
//  Ingredient+CoreDataProperties.swift
//  
//
//  Created by Andrew M Levy on 4/28/19.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var recipeId: NSNumber?
    @NSManaged public var objectId: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var servingsT: Double
    @NSManaged public var beansT: Double
    @NSManaged public var berriesT: Double
    @NSManaged public var otherFruitsT: Double
    @NSManaged public var cruciferousVegetablesT: Double
    @NSManaged public var greensT: Double
    @NSManaged public var otherVegetablesT: Double
    @NSManaged public var flaxseedsT: Double
    @NSManaged public var nutsT: Double
    @NSManaged public var turmericT: Double
    @NSManaged public var wholeGrainsT: Double
    @NSManaged public var otherSeedsT: Double
    @NSManaged public var calsT: Double
    @NSManaged public var fatT: Double
    @NSManaged public var carbsT: Double
    @NSManaged public var proteinT: Double
    @NSManaged public var ssAmtWtT: Double
    @NSManaged public var ssUnitWtT: String?
    @NSManaged public var ssAmtVolT: Double
    @NSManaged public var ssUnitVolT: String?
    @NSManaged public var recipe: Recipe?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var variety: String?

}
