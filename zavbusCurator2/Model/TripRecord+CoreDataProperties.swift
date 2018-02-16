//
//  TripRecord+CoreDataProperties.swift
//  zavbusCurator2
//
//  Created by владимир on 15.02.2018.
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
    @NSManaged public var needMeal: Bool
    @NSManaged public var needStuff: Bool
    @NSManaged public var orderedKit: String?
    @NSManaged public var ourDebt: Int32
    @NSManaged public var paidSum: Int32
    @NSManaged public var paidSumBefore: Int32
    @NSManaged public var payedBonuses: Int32
    @NSManaged public var riderId: Int64
    @NSManaged public var state: Int32
    @NSManaged public var status: Int32
    @NSManaged public var sumForPay: Int32
    @NSManaged public var trip: Trip?

}
