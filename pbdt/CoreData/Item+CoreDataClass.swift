//
//  Item+CoreDataClass.swift
//  
//
//  Created by Andrew M Levy on 4/3/19.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    func findOrCreateFromJSON(_ itemJSON: [String: AnyObject], context: NSManagedObjectContext) -> Item? {
        
        var item: Item?
        let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
        let objectId = itemJSON["id"] as! NSNumber
        fetchRequest.predicate = NSPredicate(format: "objectId = %@", objectId)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        do {
            
            let itemFetch = try context.fetch(fetchRequest)
            
            if itemFetch.count == 0 {
                
                // create a new item
                let newItem = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as! Item
                
                if let objectId = itemJSON["id"] as? NSNumber {
                    newItem.objectId = objectId
                }
                
                if let ssAmtWt = itemJSON["ss_amt_wt"] as? Double {
                    newItem.ssAmtWt = ssAmtWt
                }
                
                if let ssUnitWt = itemJSON["ss_unit_wt"] as? String {
                    newItem.ssUnitWt = ssUnitWt
                }
                
                if let ssAmtVol = itemJSON["ss_amt_vol"] as? Double {
                    newItem.ssAmtVol = ssAmtVol
                }
                
                if let ssUnitVol = itemJSON["ss_unit_vol"] as? String {
                    newItem.ssUnitVol = ssUnitVol
                }
                
                if let beans = itemJSON["beans"] as? Double {
                    newItem.beans = beans
                }
                
                if let berries = itemJSON["berries"] as? Double {
                    newItem.berries = berries
                }
                
                if let otherFruits = itemJSON["other_fruits"] as? Double {
                    newItem.otherFruits = otherFruits
                }
                
                if let cruciferousVegetables = itemJSON["cruciferous_vegetables"] as? Double {
                    newItem.cruciferousVegetables = cruciferousVegetables
                }
                
                if let greens = itemJSON["greens"] as? Double {
                    newItem.greens = greens
                }
                
                if let otherVegetables = itemJSON["other_vegetables"] as? Double {
                    newItem.otherVegetables = otherVegetables
                }
                
                if let flaxseeds = itemJSON["flaxseeds"] as? Double {
                    newItem.flaxseeds = flaxseeds
                }
                
                if let nuts = itemJSON["nuts"] as? Double {
                    newItem.nuts = nuts
                }
                
                if let turmeric = itemJSON["turmeric"] as? Double {
                    newItem.turmeric = turmeric
                }
                
                if let wholeGrains = itemJSON["whole_grains"] as? Double {
                    newItem.wholeGrains = wholeGrains
                }
                
                if let otherSeeds = itemJSON["other_seeds"] as? Double {
                    newItem.otherSeeds = otherSeeds
                }
                
                if let cals = itemJSON["cals"] as? Double {
                    newItem.cals = cals
                }
                
                if let fat = itemJSON["fat"] as? Double {
                    newItem.fat = fat
                }
                
                if let carbs = itemJSON["carbs"] as? Double {
                    newItem.carbs = carbs
                }
                
                if let protein = itemJSON["protein"] as? Double {
                    newItem.protein = protein
                }
                
                if let variety = itemJSON["variety"] as? String {
                    newItem.variety = variety
                }
                
                if let updatedAt = itemJSON["updated_at"] as? String {
                    newItem.updatedAt = dateFormatter.date(from: updatedAt)
                }
                
                item = newItem
                
            } else if itemFetch.count == 1 {
                
                // update existing item
                item = itemFetch.first!
                
                if let ssAmtWt = itemJSON["ss_amt_wt"] as? Double {
                    item!.ssAmtWt = ssAmtWt
                }
                
                if let ssUnitWt = itemJSON["ss_unit_wt"] as? String {
                    item!.ssUnitWt = ssUnitWt
                }
                
                if let ssAmtVol = itemJSON["ss_amt_vol"] as? Double {
                    item!.ssAmtVol = ssAmtVol
                }
                
                if let ssUnitVol = itemJSON["ss_unit_vol"] as? String {
                    item!.ssUnitVol = ssUnitVol
                }
                
                if let beans = itemJSON["beans"] as? Double {
                    item!.beans = beans
                }
                
                if let berries = itemJSON["berries"] as? Double {
                    item!.berries = berries
                }
                
                if let otherFruits = itemJSON["other_fruits"] as? Double {
                    item!.otherFruits = otherFruits
                }
                
                if let cruciferousVegetables = itemJSON["cruciferous_vegetables"] as? Double {
                    item!.cruciferousVegetables = cruciferousVegetables
                }
                
                if let greens = itemJSON["greens"] as? Double {
                    item!.greens = greens
                }
                
                if let otherVegetables = itemJSON["other_vegetables"] as? Double {
                    item!.otherVegetables = otherVegetables
                }
                
                if let flaxseeds = itemJSON["flaxseeds"] as? Double {
                    item!.flaxseeds = flaxseeds
                }
                
                if let nuts = itemJSON["nuts"] as? Double {
                    item!.nuts = nuts
                }
                
                if let turmeric = itemJSON["turmeric"] as? Double {
                    item!.turmeric = turmeric
                }
                
                if let wholeGrains = itemJSON["whole_grains"] as? Double {
                    item!.wholeGrains = wholeGrains
                }
                
                if let otherSeeds = itemJSON["other_seeds"] as? Double {
                    item!.otherSeeds = otherSeeds
                }
                
                if let cals = itemJSON["cals"] as? Double {
                    item!.cals = cals
                }
                
                if let fat = itemJSON["fat"] as? Double {
                    item!.fat = fat
                }
                
                if let carbs = itemJSON["carbs"] as? Double {
                    item!.carbs = carbs
                }
                
                if let protein = itemJSON["protein"] as? Double {
                    item!.protein = protein
                }
                
                if let variety = itemJSON["variety"] as? String {
                    item!.variety = variety
                }
                
                if let updatedAt = itemJSON["updated_at"] as? String {
                    item!.updatedAt = dateFormatter.date(from: updatedAt)
                }
                
            } else {
                
                // dupilcate items - should never happen
                print("There are duplicate items")
            }
            
        } catch {
            
            fatalError("Failed to fetch: \(error)")
        }
        
        return item
    }
}
