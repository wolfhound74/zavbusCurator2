//
//  Trip+CoreDataProperties.swift
//  zavbusCurator2
//
//  Created by Vladimir Maslov on 14.02.2018.
//  Copyright © 2018 Vladimir Maslov. All rights reserved.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var dates: String?
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var records: NSSet?

}

// MARK: Generated accessors for records
extension Trip {

    @objc(addRecordsObject:)
    @NSManaged public func addToRecords(_ value: TripRecord)

    @objc(removeRecordsObject:)
    @NSManaged public func removeFromRecords(_ value: TripRecord)

    @objc(addRecords:)
    @NSManaged public func addToRecords(_ values: NSSet)

    @objc(removeRecords:)
    @NSManaged public func removeFromRecords(_ values: NSSet)

}
