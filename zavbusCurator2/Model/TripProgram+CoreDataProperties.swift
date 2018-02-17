//
//  TripProgram+CoreDataProperties.swift
//  zavbusCurator2
//
//  Created by владимир on 18.02.2018.
//  Copyright © 2018 Vladimir Maslov. All rights reserved.
//
//

import Foundation
import CoreData


extension TripProgram {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TripProgram> {
        return NSFetchRequest<TripProgram>(entityName: "TripProgram")
    }

    @NSManaged public var basicPrice: Int32
    @NSManaged public var mealPrice: Int32
    @NSManaged public var status: Int32
    @NSManaged public var stuffPrice: Int32
    @NSManaged public var insurancePrice: Int32
    @NSManaged public var trip: Trip?

}
