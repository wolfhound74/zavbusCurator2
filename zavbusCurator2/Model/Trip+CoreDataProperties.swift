//
//  Trip+CoreDataProperties.swift
//  zavbusCurator2
//
//  Created by Vladimir Maslov on 08.02.2018.
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
    @NSManaged public var id: Int32
    @NSManaged public var title: String?

}
