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

    func isJustTripMember() -> Bool {
        return [4, 5, 6].contains(status)
    }

    func getTripProgram() -> TripProgram {
        return trip?.programs?.filter {
            ($0 as! TripProgram).status == status
        }.first as! TripProgram
    }

}
