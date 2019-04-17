//
//  Food+CoreDataClass.swift
//  
//
//  Created by Andrew M Levy on 4/3/19.
//
//

import Foundation
import CoreData

@objc(Food)
public class Food: NSManagedObject {
    
    class func findOrCreateFromJSON(_ foodJSON: [String: AnyObject], context: NSManagedObjectContext) -> Food? {
        
        var food: Food?
        let fetchRequest: NSFetchRequest<Food> = NSFetchRequest(entityName: "Food")
        let objectId = foodJSON["id"] as! NSNumber
        fetchRequest.predicate = NSPredicate(format: "objectId = %@", objectId)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        do {
            
            let foodFetch = try context.fetch(fetchRequest)
            
            if foodFetch.count == 0 {
                
                print("foodJSON new: \(foodJSON)")
                
                // create a new food
                let newFood = NSEntityDescription.insertNewObject(forEntityName: "Food", into: context) as! Food
                
                if let objectId = foodJSON["id"] as? NSNumber {
                    newFood.objectId = objectId
                }
                
                if let name = foodJSON["name"] as? String {
                    newFood.name = name
                }
                
                if let logDate = foodJSON["log_date"] as? String {
                    newFood.logDate = logDate
                }
                
                if let servingsT = foodJSON["servings_t"] as? NSString {
                    newFood.servingsT = servingsT.doubleValue
                }
                
                if let ssAmtWtT = foodJSON["ss_amt_wt_t"] as? NSString {
                    newFood.ssAmtWtT = ssAmtWtT.doubleValue
                }
                
                if let ssUnitWtT = foodJSON["ss_unit_wt_t"] as? String {
                    newFood.ssUnitWtT = ssUnitWtT
                }
                
                if let ssAmtVolT = foodJSON["ss_amt_vol_t"] as? NSString {
                    newFood.ssAmtVolT = ssAmtVolT.doubleValue
                }
                
                if let ssUnitVolT = foodJSON["ss_unit_vol_t"] as? String {
                    newFood.ssUnitVolT = ssUnitVolT
                }
                
                if let beansT = foodJSON["beans_t"] as? NSString {
                    newFood.beansT = beansT.doubleValue
                }
                
                if let berriesT = foodJSON["berries_t"] as? NSString {
                    newFood.berriesT = berriesT.doubleValue
                }
                
                if let otherFruitsT = foodJSON["other_fruits_t"] as? NSString {
                    newFood.otherFruitsT = otherFruitsT.doubleValue
                }
                
                if let cruciferousVegetablesT = foodJSON["cruciferous_vegetables_t"] as? NSString {
                    newFood.cruciferousVegetablesT = cruciferousVegetablesT.doubleValue
                }
                
                if let greensT = foodJSON["greens_t"] as? NSString {
                    newFood.greensT = greensT.doubleValue
                }
                
                if let otherVegetablesT = foodJSON["other_vegetables_t"] as? NSString {
                    newFood.otherVegetablesT = otherVegetablesT.doubleValue
                }
                
                if let flaxseedsT = foodJSON["flaxseeds_t"] as? NSString {
                    newFood.flaxseedsT = flaxseedsT.doubleValue
                }
                
                if let nutsT = foodJSON["nuts_t"] as? NSString {
                    newFood.nutsT = nutsT.doubleValue
                }
                
                if let turmericT = foodJSON["turmeric_t"] as? NSString {
                    newFood.turmericT = turmericT.doubleValue
                }
                
                if let wholeGrainsT = foodJSON["whole_grains_t"] as? NSString {
                    newFood.wholeGrainsT = wholeGrainsT.doubleValue
                }
                
                if let otherSeedsT = foodJSON["other_seeds_t"] as? NSString {
                    newFood.otherSeedsT = otherSeedsT.doubleValue
                }
                
                if let calsT = foodJSON["cals_t"] as? NSString {
                    newFood.calsT = calsT.doubleValue
                }
                
                if let fatT = foodJSON["fat_t"] as? NSString {
                    newFood.fatT = fatT.doubleValue
                }
                
                if let carbsT = foodJSON["carbs_t"] as? NSString {
                    newFood.carbsT = carbsT.doubleValue
                }
                
                if let proteinT = foodJSON["protein_t"] as? NSString {
                    newFood.proteinT = proteinT.doubleValue
                }
                
                if let variety = foodJSON["variety"] as? String {
                    newFood.variety = variety
                }
                
                if let createdAt = foodJSON["created_at"] as? String {
                    newFood.createdAt = dateFormatter.date(from: createdAt)
                }
                
                if let updatedAt = foodJSON["updated_at"] as? String {
                    newFood.updatedAt = dateFormatter.date(from: updatedAt)
                }
                
                food = newFood
                
            } else if foodFetch.count == 1 {
                
                print("foodJSON existing: \(foodJSON)")
                
                // update existing food
                food = foodFetch.first!
                
                if let name = foodJSON["name"] as? String {
                    food!.name = name
                }
                
                if let logDate = foodJSON["log_date"] as? String {
                    food!.logDate = logDate
                }
                
                if let servingsT = foodJSON["servings_t"] as? NSString {
                    food!.servingsT = servingsT.doubleValue
                }
                
                if let ssAmtWtT = foodJSON["ss_amt_wt_t"] as? NSString {
                    food!.ssAmtWtT = ssAmtWtT.doubleValue
                }
                
                if let ssUnitWtT = foodJSON["ss_unit_wt_t"] as? String {
                    food!.ssUnitWtT = ssUnitWtT
                }
                
                if let ssAmtVolT = foodJSON["ss_amt_vol_t"] as? NSString {
                    food!.ssAmtVolT = ssAmtVolT.doubleValue
                }
                
                if let ssUnitVolT = foodJSON["ss_unit_vol_t"] as? String {
                    food!.ssUnitVolT = ssUnitVolT
                }
                
                if let beansT = foodJSON["beans_t"] as? NSString {
                    food!.beansT = beansT.doubleValue
                }
                
                if let berriesT = foodJSON["berries_t"] as? NSString {
                    food!.berriesT = berriesT.doubleValue
                }
                
                if let otherFruitsT = foodJSON["other_fruits_t"] as? NSString {
                    food!.otherFruitsT = otherFruitsT.doubleValue
                }
                
                if let cruciferousVegetablesT = foodJSON["cruciferous_vegetables_t"] as? NSString {
                    food!.cruciferousVegetablesT = cruciferousVegetablesT.doubleValue
                }
                
                if let greensT = foodJSON["greens_t"] as? NSString {
                    food!.greensT = greensT.doubleValue
                }
                
                if let otherVegetablesT = foodJSON["other_vegetables_t"] as? NSString {
                    food!.otherVegetablesT = otherVegetablesT.doubleValue
                }
                
                if let flaxseedsT = foodJSON["flaxseeds_t"] as? NSString {
                    food!.flaxseedsT = flaxseedsT.doubleValue
                }
                
                if let nutsT = foodJSON["nuts_t"] as? NSString {
                    food!.nutsT = nutsT.doubleValue
                }
                
                if let turmericT = foodJSON["turmeric_t"] as? NSString {
                    food!.turmericT = turmericT.doubleValue
                }
                
                if let wholeGrainsT = foodJSON["whole_grains_t"] as? NSString {
                    food!.wholeGrainsT = wholeGrainsT.doubleValue
                }
                
                if let otherSeedsT = foodJSON["other_seeds_t"] as? NSString {
                    food!.otherSeedsT = otherSeedsT.doubleValue
                }
                
                if let calsT = foodJSON["cals_t"] as? NSString {
                    food!.calsT = calsT.doubleValue
                }
                
                if let fatT = foodJSON["fat_t"] as? NSString {
                    food!.fatT = fatT.doubleValue
                }
                
                if let carbsT = foodJSON["carbs_t"] as? NSString {
                    food!.carbsT = carbsT.doubleValue
                }
                
                if let proteinT = foodJSON["protein_t"] as? NSString {
                    food!.proteinT = proteinT.doubleValue
                }
                
                if let variety = foodJSON["variety"] as? String {
                    food!.variety = variety
                }
                
                if let createdAt = foodJSON["created_at"] as? String {
                    food!.createdAt = dateFormatter.date(from: createdAt)
                }
                
                if let updatedAt = foodJSON["updated_at"] as? String {
                    food!.updatedAt = dateFormatter.date(from: updatedAt)
                }
                
            } else {
                
                // dupilcate foods - should never happen
                print("There are duplicate foods")
            }
            
        } catch {
            
            fatalError("Failed to fetch: \(error)")
        }
        
        appDelegate.saveContext()
        
        return food
    }
}
