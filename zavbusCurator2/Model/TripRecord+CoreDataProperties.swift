//
//  TripRecord+CoreDataProperties.swift
//  zavbusCurator2
//
//  Created by Vladimir Maslov on 19.02.2018.
//  Copyright © 2018 Vladimir Maslov. All rights reserved.
//
//

import Foundation
import CoreData


extension TripRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TripRecord> {
        return NSFetchRequest<TripRecord>(entityName: "TripRecord")
    }

    @NSManaged public var actualBonuses: Int32
    @NSManaged public var commentFromVk: String?
    @NSManaged public var confirmed: Bool
    @NSManaged public var firstName: String?
    @NSManaged public var id: Int64
    @NSManaged public var lastName: String?
    @NSManaged public var mainRiderId: Int64
    @NSManaged public var needInsurance: Bool
    @NSManaged public var needMeal: Bool
    @NSManaged public var needStuff: Bool
    @NSManaged public var orderedKit: String?
    @NSManaged public var paidSumInBus: Int32
    @NSManaged public var prepaidSum: Int32
    @NSManaged public var prepaidBonuses: Int32
    @NSManaged public var riderId: Int64
    @NSManaged public var state: Int32
    @NSManaged public var status: Int32
    @NSManaged public var sumForPay: Int32
    @NSManaged public var sumChange: Int32
    @NSManaged public var trip: Trip?

}
