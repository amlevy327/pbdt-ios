//
//  User+CoreDataClass.swift
//  
//
//  Created by Andrew M Levy on 4/26/19.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    class func findOrCreateFromJSON(_ userJSON: [String: AnyObject], context: NSManagedObjectContext) -> User? {
        
        var user: User?
        let fetchRequest: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
        let objectId = userJSON["id"] as! NSNumber
        fetchRequest.predicate = NSPredicate(format: "objectId = %@", objectId)
        
        do {
            
            let userFetch = try context.fetch(fetchRequest)
            
            if userFetch.count == 0 {
                
                //print("userJSON new: \(userJSON)")
                
                // create a new user
                let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
                
                if let objectId = userJSON["id"] as? NSNumber {
                    newUser.objectId = objectId
                }
                
                if let name = userJSON["name"] as? String {
                    newUser.name = name
                }
                
                if let email = userJSON["email"] as? String {
                    newUser.email = email
                }
                
                if let authenticationToken = userJSON["authentication_token"] as? String {
                    newUser.authenticationToken = authenticationToken
                }
                
                if let beansG = userJSON["beans_g"] as? NSString {
                    newUser.beansG = beansG.doubleValue
                }
                
                if let berriesG = userJSON["berries_g"] as? NSString {
                    newUser.berriesG = berriesG.doubleValue
                }
                
                if let otherFruitsG = userJSON["other_fruits_g"] as? NSString {
                    newUser.otherFruitsG = otherFruitsG.doubleValue
                }
                
                if let cruciferousVegetablesG = userJSON["cruciferous_vegetables_g"] as? NSString {
                    newUser.cruciferousVegetablesG = cruciferousVegetablesG.doubleValue
                }
                
                if let greensG = userJSON["greens_g"] as? NSString {
                    newUser.greensG = greensG.doubleValue
                }
                
                if let otherVegetablesG = userJSON["other_vegetables_g"] as? NSString {
                    newUser.otherVegetablesG = otherVegetablesG.doubleValue
                }
                
                if let flaxseedsG = userJSON["flaxseeds_g"] as? NSString {
                    newUser.flaxseedsG = flaxseedsG.doubleValue
                }
                
                if let nutsG = userJSON["nuts_g"] as? NSString {
                    newUser.nutsG = nutsG.doubleValue
                }
                
                if let turmericG = userJSON["turmeric_g"] as? NSString {
                    newUser.turmericG = turmericG.doubleValue
                }
                
                if let wholeGrainsG = userJSON["whole_grains_g"] as? NSString {
                    newUser.wholeGrainsG = wholeGrainsG.doubleValue
                }
                
                if let otherSeedsG = userJSON["other_seeds_g"] as? NSString {
                    newUser.otherSeedsG = otherSeedsG.doubleValue
                }
                
                if let calsG = userJSON["cals_g"] as? NSString {
                    newUser.calsG = calsG.doubleValue
                }
                
                if let fatG = userJSON["fat_g"] as? NSString {
                    newUser.fatG = fatG.doubleValue
                }
                
                if let carbsG = userJSON["carbs_g"] as? NSString {
                    newUser.carbsG = carbsG.doubleValue
                }
                
                if let proteinG = userJSON["protein_g"] as? NSString {
                    newUser.proteinG = proteinG.doubleValue
                }
                
                user = newUser
                
            } else if userFetch.count == 1 {
                
                //print("userJSON existing: \(userJSON)")
                
                // update existing user
                user = userFetch.first!
                
                if let name = userJSON["name"] as? String {
                    user!.name = name
                }
                
                if let email = userJSON["email"] as? String {
                    user!.email = email
                }
                
                if let authenticationToken = userJSON["authentication_token"] as? String {
                    user!.authenticationToken = authenticationToken
                }
                
                if let beansG = userJSON["beans_g"] as? NSString {
                    user!.beansG = beansG.doubleValue
                }
                
                if let berriesG = userJSON["berries_g"] as? NSString {
                    user!.berriesG = berriesG.doubleValue
                }
                
                if let otherFruitsG = userJSON["other_fruits_g"] as? NSString {
                    user!.otherFruitsG = otherFruitsG.doubleValue
                }
                
                if let cruciferousVegetablesG = userJSON["cruciferous_vegetables_g"] as? NSString {
                    user!.cruciferousVegetablesG = cruciferousVegetablesG.doubleValue
                }
                
                if let greensG = userJSON["greens_g"] as? NSString {
                    user!.greensG = greensG.doubleValue
                }
                
                if let otherVegetablesG = userJSON["other_vegetables_g"] as? NSString {
                    user!.otherVegetablesG = otherVegetablesG.doubleValue
                }
                
                if let flaxseedsG = userJSON["flaxseeds_g"] as? NSString {
                    user!.flaxseedsG = flaxseedsG.doubleValue
                }
                
                if let nutsG = userJSON["nuts_g"] as? NSString {
                    user!.nutsG = nutsG.doubleValue
                }
                
                if let turmericG = userJSON["turmeric_g"] as? NSString {
                    user!.turmericG = turmericG.doubleValue
                }
                
                if let wholeGrainsG = userJSON["whole_grains_g"] as? NSString {
                    user!.wholeGrainsG = wholeGrainsG.doubleValue
                }
                
                if let otherSeedsG = userJSON["other_seeds_g"] as? NSString {
                    user!.otherSeedsG = otherSeedsG.doubleValue
                }
                
                if let calsG = userJSON["cals_g"] as? NSString {
                    user!.calsG = calsG.doubleValue
                }
                
                if let fatG = userJSON["fat_g"] as? NSString {
                    user!.fatG = fatG.doubleValue
                }
                
                if let carbsG = userJSON["carbs_g"] as? NSString {
                    user!.carbsG = carbsG.doubleValue
                }
                
                if let proteinG = userJSON["protein_g"] as? NSString {
                    user!.proteinG = proteinG.doubleValue
                }
                
            } else {
                
                // dupilcate user - should never happen
                print("There are duplicate users")
                user = userFetch.first
            }
            
        } catch {
            
            fatalError("Failed to fetch: \(error)")
        }
        
        appDelegate.saveContext()
        
        return user
    }
}
