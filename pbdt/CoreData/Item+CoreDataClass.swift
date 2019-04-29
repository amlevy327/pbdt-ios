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
    
    class func findOrCreateFromJSON(_ itemJSON: [String: AnyObject], context: NSManagedObjectContext) -> Item? {
        
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
                
                if let name = itemJSON["name"] as? String {
                    newItem.name = name
                }
                
                if let ssAmtWt = itemJSON["ss_amt_wt"] as? NSString {
                    newItem.ssAmtWt = ssAmtWt.doubleValue
                }
                
                if let ssUnitWt = itemJSON["ss_unit_wt"] as? String {
                    newItem.ssUnitWt = ssUnitWt
                }
                
                if let ssAmtVol = itemJSON["ss_amt_vol"] as? NSString {
                    newItem.ssAmtVol = ssAmtVol.doubleValue
                }
                
                if let ssUnitVol = itemJSON["ss_unit_vol"] as? String {
                    newItem.ssUnitVol = ssUnitVol
                }
                
                if let beans = itemJSON["beans"] as? NSString {
                    newItem.beans = beans.doubleValue
                }
                
                if let berries = itemJSON["berries"] as? NSString {
                    newItem.berries = berries.doubleValue
                }
                
                if let otherFruits = itemJSON["other_fruits"] as? NSString {
                    newItem.otherFruits = otherFruits.doubleValue
                }
                
                if let cruciferousVegetables = itemJSON["cruciferous_vegetables"] as? NSString {
                    newItem.cruciferousVegetables = cruciferousVegetables.doubleValue
                }
                
                if let greens = itemJSON["greens"] as? NSString {
                    newItem.greens = greens.doubleValue
                }
                
                if let otherVegetables = itemJSON["other_vegetables"] as? NSString {
                    newItem.otherVegetables = otherVegetables.doubleValue
                }
                
                if let flaxseeds = itemJSON["flaxseeds"] as? NSString {
                    newItem.flaxseeds = flaxseeds.doubleValue
                }
                
                if let nuts = itemJSON["nuts"] as? NSString {
                    newItem.nuts = nuts.doubleValue
                }
                
                if let turmeric = itemJSON["turmeric"] as? NSString {
                    newItem.turmeric = turmeric.doubleValue
                }
                
                if let wholeGrains = itemJSON["whole_grains"] as? NSString {
                    newItem.wholeGrains = wholeGrains.doubleValue
                }
                
                if let otherSeeds = itemJSON["other_seeds"] as? NSString {
                    newItem.otherSeeds = otherSeeds.doubleValue
                }
                
                if let cals = itemJSON["cals"] as? NSString {
                    newItem.cals = cals.doubleValue
                }
                
                if let fat = itemJSON["fat"] as? NSString {
                    newItem.fat = fat.doubleValue
                }
                
                if let carbs = itemJSON["carbs"] as? NSString {
                    newItem.carbs = carbs.doubleValue
                }
                
                if let protein = itemJSON["protein"] as? NSString {
                    newItem.protein = protein.doubleValue
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
                
                if let name = itemJSON["name"] as? String {
                    item!.name = name
                }
                
                if let ssAmtWt = itemJSON["ss_amt_wt"] as? NSString {
                    item!.ssAmtWt = ssAmtWt.doubleValue
                }
                
                if let ssUnitWt = itemJSON["ss_unit_wt"] as? String {
                    item!.ssUnitWt = ssUnitWt
                }
                
                if let ssAmtVol = itemJSON["ss_amt_vol"] as? NSString {
                    item!.ssAmtVol = ssAmtVol.doubleValue
                }
                
                if let ssUnitVol = itemJSON["ss_unit_vol"] as? String {
                    item!.ssUnitVol = ssUnitVol
                }
                
                if let beans = itemJSON["beans"] as? NSString {
                    item!.beans = beans.doubleValue
                }
                
                if let berries = itemJSON["berries"] as? NSString {
                    item!.berries = berries.doubleValue
                }
                
                if let otherFruits = itemJSON["other_fruits"] as? NSString {
                    item!.otherFruits = otherFruits.doubleValue
                }
                
                if let cruciferousVegetables = itemJSON["cruciferous_vegetables"] as? NSString {
                    item!.cruciferousVegetables = cruciferousVegetables.doubleValue
                }
                
                if let greens = itemJSON["greens"] as? NSString {
                    item!.greens = greens.doubleValue
                }
                
                if let otherVegetables = itemJSON["other_vegetables"] as? NSString {
                    item!.otherVegetables = otherVegetables.doubleValue
                }
                
                if let flaxseeds = itemJSON["flaxseeds"] as? NSString {
                    item!.flaxseeds = flaxseeds.doubleValue
                }
                
                if let nuts = itemJSON["nuts"] as? NSString {
                    item!.nuts = nuts.doubleValue
                }
                
                if let turmeric = itemJSON["turmeric"] as? NSString {
                    item!.turmeric = turmeric.doubleValue
                }
                
                if let wholeGrains = itemJSON["whole_grains"] as? NSString {
                    item!.wholeGrains = wholeGrains.doubleValue
                }
                
                if let otherSeeds = itemJSON["other_seeds"] as? NSString {
                    item!.otherSeeds = otherSeeds.doubleValue
                }
                
                if let cals = itemJSON["cals"] as? NSString {
                    item!.cals = cals.doubleValue
                }
                
                if let fat = itemJSON["fat"] as? NSString {
                    item!.fat = fat.doubleValue
                }
                
                if let carbs = itemJSON["carbs"] as? NSString {
                    item!.carbs = carbs.doubleValue
                }
                
                if let protein = itemJSON["protein"] as? NSString {
                    item!.protein = protein.doubleValue
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
            
            fatalError("Failed to fetch items: \(error)")
        }
        
        appDelegate.saveContext()
        
        return item
    }
}
