//
//  Ingredient+CoreDataClass.swift
//  
//
//  Created by Andrew M Levy on 4/28/19.
//
//

import Foundation
import CoreData

@objc(Ingredient)
public class Ingredient: NSManagedObject {
    
    class func findOrCreateFromJSON(_ ingredientJSON: [String: AnyObject], context: NSManagedObjectContext) -> Ingredient? {
        
        var ingredient: Ingredient?
        let fetchRequest: NSFetchRequest<Ingredient> = NSFetchRequest(entityName: "Ingredient")
        let objectId = ingredientJSON["id"] as! NSNumber
        fetchRequest.predicate = NSPredicate(format: "objectId = %@", objectId)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        do {
            
            let ingredientFetch = try context.fetch(fetchRequest)
            
            if ingredientFetch.count == 0 {
                
                //print("ingredientJSON new: \(ingredientJSON)")
                
                // create a new ingredient
                let newIngredient = NSEntityDescription.insertNewObject(forEntityName: "Ingredient", into: context) as! Ingredient
                
                if let objectId = ingredientJSON["id"] as? NSNumber {
                    newIngredient.objectId = objectId
                }
                
                if let recipeId = ingredientJSON["recipeId"] as? NSNumber {
                    newIngredient.recipeId = recipeId
                }
                
                if let name = ingredientJSON["name"] as? String {
                    newIngredient.name = name
                }
                
                if let servingsT = ingredientJSON["servings_t"] as? NSString {
                    newIngredient.servingsT = servingsT.doubleValue
                }
                
                if let ssAmtWtT = ingredientJSON["ss_amt_wt_t"] as? NSString {
                    newIngredient.ssAmtWtT = ssAmtWtT.doubleValue
                }
                
                if let ssUnitWtT = ingredientJSON["ss_unit_wt_t"] as? String {
                    newIngredient.ssUnitWtT = ssUnitWtT
                }
                
                if let ssAmtVolT = ingredientJSON["ss_amt_vol_t"] as? NSString {
                    newIngredient.ssAmtVolT = ssAmtVolT.doubleValue
                }
                
                if let ssUnitVolT = ingredientJSON["ss_unit_vol_t"] as? String {
                    newIngredient.ssUnitVolT = ssUnitVolT
                }
                
                if let beansT = ingredientJSON["beans_t"] as? NSString {
                    newIngredient.beansT = beansT.doubleValue
                }
                
                if let berriesT = ingredientJSON["berries_t"] as? NSString {
                    newIngredient.berriesT = berriesT.doubleValue
                }
                
                if let otherFruitsT = ingredientJSON["other_fruits_t"] as? NSString {
                    newIngredient.otherFruitsT = otherFruitsT.doubleValue
                }
                
                if let cruciferousVegetablesT = ingredientJSON["cruciferous_vegetables_t"] as? NSString {
                    newIngredient.cruciferousVegetablesT = cruciferousVegetablesT.doubleValue
                }
                
                if let greensT = ingredientJSON["greens_t"] as? NSString {
                    newIngredient.greensT = greensT.doubleValue
                }
                
                if let otherVegetablesT = ingredientJSON["other_vegetables_t"] as? NSString {
                    newIngredient.otherVegetablesT = otherVegetablesT.doubleValue
                }
                
                if let flaxseedsT = ingredientJSON["flaxseeds_t"] as? NSString {
                    newIngredient.flaxseedsT = flaxseedsT.doubleValue
                }
                
                if let nutsT = ingredientJSON["nuts_t"] as? NSString {
                    newIngredient.nutsT = nutsT.doubleValue
                }
                
                if let turmericT = ingredientJSON["turmeric_t"] as? NSString {
                    newIngredient.turmericT = turmericT.doubleValue
                }
                
                if let wholeGrainsT = ingredientJSON["whole_grains_t"] as? NSString {
                    newIngredient.wholeGrainsT = wholeGrainsT.doubleValue
                }
                
                if let otherSeedsT = ingredientJSON["other_seeds_t"] as? NSString {
                    newIngredient.otherSeedsT = otherSeedsT.doubleValue
                }
                
                if let calsT = ingredientJSON["cals_t"] as? NSString {
                    newIngredient.calsT = calsT.doubleValue
                }
                
                if let fatT = ingredientJSON["fat_t"] as? NSString {
                    newIngredient.fatT = fatT.doubleValue
                }
                
                if let carbsT = ingredientJSON["carbs_t"] as? NSString {
                    newIngredient.carbsT = carbsT.doubleValue
                }
                
                if let proteinT = ingredientJSON["protein_t"] as? NSString {
                    newIngredient.proteinT = proteinT.doubleValue
                }
                
                if let variety = ingredientJSON["variety"] as? String {
                    newIngredient.variety = variety
                }
                
                if let updatedAt = ingredientJSON["updated_at"] as? String {
                    newIngredient.updatedAt = dateFormatter.date(from: updatedAt)
                }
                
                ingredient = newIngredient
                
            } else if ingredientFetch.count == 1 {
                
                //print("ingredientJSON existing: \(ingredientJSON)")
                
                // update existing ingredient
                ingredient = ingredientFetch.first!
                
                if let name = ingredientJSON["name"] as? String {
                    ingredient!.name = name
                }
                
                if let recipeId = ingredientJSON["recipeId"] as? NSNumber {
                    ingredient!.recipeId = recipeId
                }
                
                if let servingsT = ingredientJSON["servings_t"] as? NSString {
                    ingredient!.servingsT = servingsT.doubleValue
                }
                
                if let ssAmtWtT = ingredientJSON["ss_amt_wt_t"] as? NSString {
                    ingredient!.ssAmtWtT = ssAmtWtT.doubleValue
                }
                
                if let ssUnitWtT = ingredientJSON["ss_unit_wt_t"] as? String {
                    ingredient!.ssUnitWtT = ssUnitWtT
                }
                
                if let ssAmtVolT = ingredientJSON["ss_amt_vol_t"] as? NSString {
                    ingredient!.ssAmtVolT = ssAmtVolT.doubleValue
                }
                
                if let ssUnitVolT = ingredientJSON["ss_unit_vol_t"] as? String {
                    ingredient!.ssUnitVolT = ssUnitVolT
                }
                
                if let beansT = ingredientJSON["beans_t"] as? NSString {
                    ingredient!.beansT = beansT.doubleValue
                }
                
                if let berriesT = ingredientJSON["berries_t"] as? NSString {
                    ingredient!.berriesT = berriesT.doubleValue
                }
                
                if let otherFruitsT = ingredientJSON["other_fruits_t"] as? NSString {
                    ingredient!.otherFruitsT = otherFruitsT.doubleValue
                }
                
                if let cruciferousVegetablesT = ingredientJSON["cruciferous_vegetables_t"] as? NSString {
                    ingredient!.cruciferousVegetablesT = cruciferousVegetablesT.doubleValue
                }
                
                if let greensT = ingredientJSON["greens_t"] as? NSString {
                    ingredient!.greensT = greensT.doubleValue
                }
                
                if let otherVegetablesT = ingredientJSON["other_vegetables_t"] as? NSString {
                    ingredient!.otherVegetablesT = otherVegetablesT.doubleValue
                }
                
                if let flaxseedsT = ingredientJSON["flaxseeds_t"] as? NSString {
                    ingredient!.flaxseedsT = flaxseedsT.doubleValue
                }
                
                if let nutsT = ingredientJSON["nuts_t"] as? NSString {
                    ingredient!.nutsT = nutsT.doubleValue
                }
                
                if let turmericT = ingredientJSON["turmeric_t"] as? NSString {
                    ingredient!.turmericT = turmericT.doubleValue
                }
                
                if let wholeGrainsT = ingredientJSON["whole_grains_t"] as? NSString {
                    ingredient!.wholeGrainsT = wholeGrainsT.doubleValue
                }
                
                if let otherSeedsT = ingredientJSON["other_seeds_t"] as? NSString {
                    ingredient!.otherSeedsT = otherSeedsT.doubleValue
                }
                
                if let calsT = ingredientJSON["cals_t"] as? NSString {
                    ingredient!.calsT = calsT.doubleValue
                }
                
                if let fatT = ingredientJSON["fat_t"] as? NSString {
                    ingredient!.fatT = fatT.doubleValue
                }
                
                if let carbsT = ingredientJSON["carbs_t"] as? NSString {
                    ingredient!.carbsT = carbsT.doubleValue
                }
                
                if let proteinT = ingredientJSON["protein_t"] as? NSString {
                    ingredient!.proteinT = proteinT.doubleValue
                }
                
                if let variety = ingredientJSON["variety"] as? String {
                    ingredient!.variety = variety
                }
                
                if let updatedAt = ingredientJSON["updated_at"] as? String {
                    ingredient!.updatedAt = dateFormatter.date(from: updatedAt)
                }
                
            } else {
                
                // dupilcate ingredients - should never happen
                print("There are duplicate ingredients")
            }
            
        } catch {
            
            fatalError("Failed to fetch ingredients: \(error)")
        }
        
        appDelegate.saveContext()
        
        return ingredient
    }
}
