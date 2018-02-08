//
//  TripRecord+CoreDataProperties.swift
//  zavbusCurator2
//
//  Created by Vladimir Maslov on 08.02.2018.
//  Copyright © 2018 Vladimir Maslov. All rights reserved.
//
//

import Foundation
import CoreData


extension TripRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TripRecord> {
        return NSFetchRequest<TripRecord>(entityName: "TripRecord")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var id: Int64
    @NSManaged public var state: Int32
    @NSManaged public var status: Int32
    @NSManaged public var trip: Trip?

}
