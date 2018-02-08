//
//  TripRecord+CoreDataClass.swift
//  zavbusCurator2
//
//  Created by Vladimir Maslov on 08.02.2018.
//  Copyright © 2018 Vladimir Maslov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TripRecord)
public class TripRecord: NSManagedObject {

    func getFullName() -> String {
        return self.lastName! + " " + self.firstName!
    }

}
