//
//  TripProgram+CoreDataClass.swift
//  zavbusCurator2
//
//  Created by владимир on 15.02.2018.
//  Copyright © 2018 Vladimir Maslov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TripProgram)
public class TripProgram: NSManagedObject {
    func getIndexByCurrentStatus() -> Int {
        return statusesIndex.filter {
            $0.value == status
        }.first?.key as! Int
    }
}
