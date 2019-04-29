//
//  Recipe+CoreDataClass.swift
//  
//
//  Created by Andrew M Levy on 4/28/19.
//
//

import Foundation
import CoreData

@objc(Recipe)
public class Recipe: NSManagedObject {
    
    class func findOrCreateFromJSON(_ recipeJSON: [String: AnyObject], context: NSManagedObjectContext) -> Recipe? {
        
        var recipe: Recipe?
        let fetchRequest: NSFetchRequest<Recipe> = NSFetchRequest(entityName: "Recipe")
        let objectId = recipeJSON["id"] as! NSNumber
        fetchRequest.predicate = NSPredicate(format: "objectId = %@", objectId)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        do {
            
            let recipeFetch = try context.fetch(fetchRequest)
            
            if recipeFetch.count == 0 {
                
                // create a new recipe
                let newRecipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: context) as! Recipe
                
                if let objectId = recipeJSON["id"] as? NSNumber {
                    newRecipe.objectId = objectId
                }
                
                if let name = recipeJSON["name"] as? String {
                    newRecipe.name = name
                }
                
                if let servings = recipeJSON["servings"] as? NSString {
                    newRecipe.servings = servings.doubleValue
                }
                
                if let beans = recipeJSON["beans"] as? NSString {
                    newRecipe.beans = beans.doubleValue
                }
                
                if let berries = recipeJSON["berries"] as? NSString {
                    newRecipe.berries = berries.doubleValue
                }
                
                if let otherFruits = recipeJSON["other_fruits"] as? NSString {
                    newRecipe.otherFruits = otherFruits.doubleValue
                }
                
                if let cruciferousVegetables = recipeJSON["cruciferous_vegetables"] as? NSString {
                    newRecipe.cruciferousVegetables = cruciferousVegetables.doubleValue
                }
                
                if let greens = recipeJSON["greens"] as? NSString {
                    newRecipe.greens = greens.doubleValue
                }
                
                if let otherVegetables = recipeJSON["other_vegetables"] as? NSString {
                    newRecipe.otherVegetables = otherVegetables.doubleValue
                }
                
                if let flaxseeds = recipeJSON["flaxseeds"] as? NSString {
                    newRecipe.flaxseeds = flaxseeds.doubleValue
                }
                
                if let nuts = recipeJSON["nuts"] as? NSString {
                    newRecipe.nuts = nuts.doubleValue
                }
                
                if let turmeric = recipeJSON["turmeric"] as? NSString {
                    newRecipe.turmeric = turmeric.doubleValue
                }
                
                if let wholeGrains = recipeJSON["whole_grains"] as? NSString {
                    newRecipe.wholeGrains = wholeGrains.doubleValue
                }
                
                if let otherSeeds = recipeJSON["other_seeds"] as? NSString {
                    newRecipe.otherSeeds = otherSeeds.doubleValue
                }
                
                if let cals = recipeJSON["cals"] as? NSString {
                    newRecipe.cals = cals.doubleValue
                }
                
                if let fat = recipeJSON["fat"] as? NSString {
                    newRecipe.fat = fat.doubleValue
                }
                
                if let carbs = recipeJSON["carbs"] as? NSString {
                    newRecipe.carbs = carbs.doubleValue
                }
                
                if let protein = recipeJSON["protein"] as? NSString {
                    newRecipe.protein = protein.doubleValue
                }
                
                if let updatedAt = recipeJSON["updated_at"] as? String {
                    newRecipe.updatedAt = dateFormatter.date(from: updatedAt)
                }
                
                recipe = newRecipe
                
            } else if recipeFetch.count == 1 {
                
                // update existing recipe
                recipe = recipeFetch.first!
                
                if let name = recipeJSON["name"] as? String {
                    recipe!.name = name
                }
                
                if let servings = recipeJSON["servings"] as? NSString {
                    recipe!.servings = servings.doubleValue
                }
                
                if let beans = recipeJSON["beans"] as? NSString {
                    recipe!.beans = beans.doubleValue
                }
                
                if let berries = recipeJSON["berries"] as? NSString {
                    recipe!.berries = berries.doubleValue
                }
                
                if let otherFruits = recipeJSON["other_fruits"] as? NSString {
                    recipe!.otherFruits = otherFruits.doubleValue
                }
                
                if let cruciferousVegetables = recipeJSON["cruciferous_vegetables"] as? NSString {
                    recipe!.cruciferousVegetables = cruciferousVegetables.doubleValue
                }
                
                if let greens = recipeJSON["greens"] as? NSString {
                    recipe!.greens = greens.doubleValue
                }
                
                if let otherVegetables = recipeJSON["other_vegetables"] as? NSString {
                    recipe!.otherVegetables = otherVegetables.doubleValue
                }
                
                if let flaxseeds = recipeJSON["flaxseeds"] as? NSString {
                    recipe!.flaxseeds = flaxseeds.doubleValue
                }
                
                if let nuts = recipeJSON["nuts"] as? NSString {
                    recipe!.nuts = nuts.doubleValue
                }
                
                if let turmeric = recipeJSON["turmeric"] as? NSString {
                    recipe!.turmeric = turmeric.doubleValue
                }
                
                if let wholeGrains = recipeJSON["whole_grains"] as? NSString {
                    recipe!.wholeGrains = wholeGrains.doubleValue
                }
                
                if let otherSeeds = recipeJSON["other_seeds"] as? NSString {
                    recipe!.otherSeeds = otherSeeds.doubleValue
                }
                
                if let cals = recipeJSON["cals"] as? NSString {
                    recipe!.cals = cals.doubleValue
                }
                
                if let fat = recipeJSON["fat"] as? NSString {
                    recipe!.fat = fat.doubleValue
                }
                
                if let carbs = recipeJSON["carbs"] as? NSString {
                    recipe!.carbs = carbs.doubleValue
                }
                
                if let protein = recipeJSON["protein"] as? NSString {
                    recipe!.protein = protein.doubleValue
                }
                
                if let updatedAt = recipeJSON["updated_at"] as? String {
                    recipe!.updatedAt = dateFormatter.date(from: updatedAt)
                }
                
            } else {
                
                // dupilcate recipes - should never happen
                print("There are duplicate recipes")
            }
            
        } catch {
            
            fatalError("Failed to fetch recipes: \(error)")
        }
        
        appDelegate.saveContext()
        
        return recipe
    }
}
