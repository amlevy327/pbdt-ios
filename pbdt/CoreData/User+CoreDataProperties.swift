//
//  User+CoreDataProperties.swift
//  
//
//  Created by Andrew M Levy on 4/26/19.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var beansG: Double
    @NSManaged public var berriesG: Double
    @NSManaged public var otherFruitsG: Double
    @NSManaged public var cruciferousVegetablesG: Double
    @NSManaged public var greensG: Double
    @NSManaged public var otherVegetablesG: Double
    @NSManaged public var flaxseedsG: Double
    @NSManaged public var nutsG: Double
    @NSManaged public var turmericG: Double
    @NSManaged public var wholeGrainsG: Double
    @NSManaged public var otherSeedsG: Double
    @NSManaged public var calsG: Double
    @NSManaged public var fatG: Double
    @NSManaged public var carbsG: Double
    @NSManaged public var proteinG: Double
    @NSManaged public var objectId: NSNumber?
    @NSManaged public var authenticationToken: String?
    @NSManaged public var email: String?
    @NSManaged public var name: String?

}
