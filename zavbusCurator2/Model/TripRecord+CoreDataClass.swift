//
//  TripRecord+CoreDataClass.swift
//  zavbusCurator2
//
//  Created by владимир on 15.02.2018.
//  Copyright © 2018 Vladimir Maslov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TripRecord)
public class TripRecord: NSManagedObject {
    func save() {
        do {
            try managedObjectContext?.save()
        } catch {
        }
    }
}
