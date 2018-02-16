//
//  Trip+CoreDataProperties.swift
//  zavbusCurator2
//
//  Created by владимир on 15.02.2018.
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
    @NSManaged public var memberNumber: Int32
    @NSManaged public var kitNumber: Int32
    @NSManaged public var programs: NSSet?
    @NSManaged public var records: NSSet?

}

// MARK: Generated accessors for programs
extension Trip {

    @objc(addProgramsObject:)
    @NSManaged public func addToPrograms(_ value: TripProgram)

    @objc(removeProgramsObject:)
    @NSManaged public func removeFromPrograms(_ value: TripProgram)

    @objc(addPrograms:)
    @NSManaged public func addToPrograms(_ values: NSSet)

    @objc(removePrograms:)
    @NSManaged public func removeFromPrograms(_ values: NSSet)

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
