//
//  BarController.swift
//  zavbusCurator2
//
//  Created by Vladimir Maslov on 13.02.2018.
//  Copyright © 2018 Vladimir Maslov. All rights reserved.
//

import UIKit

class TripTabBarController: UITabBarController {
    var records = [TripRecord]()
    var trip: Trip?

    override func viewDidLoad() {
        super.viewDidLoad()


        for var vc in viewControllers as! [ViewController] {
            if vc.isKindOfClass(TripSettingsController) {

            }
        }
    }
}
