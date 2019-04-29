//
//  Recipe+CoreDataProperties.swift
//  
//
//  Created by Andrew M Levy on 4/28/19.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var name: String?
    @NSManaged public var servings: Double
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
    @NSManaged public var objectId: NSNumber?
    @NSManaged public var ingredient: NSSet?
    @NSManaged public var updatedAt: Date?

}

// MARK: Generated accessors for ingredient
extension Recipe {

    @objc(addIngredientObject:)
    @NSManaged public func addToIngredient(_ value: Ingredient)

    @objc(removeIngredientObject:)
    @NSManaged public func removeFromIngredient(_ value: Ingredient)

    @objc(addIngredient:)
    @NSManaged public func addToIngredient(_ values: NSSet)

    @objc(removeIngredient:)
    @NSManaged public func removeFromIngredient(_ values: NSSet)

}
