import UIKit

class TripTabBarController: UITabBarController {
//    var records = [TripRecord]()
    var trip: Trip?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = trip?.dates
        self.navigationController?.navigationBar.isTranslucent = false;

        for var vc in viewControllers! {
            if vc is RecordListController {
                let vc = vc as! RecordListController
//                vc.records = self.records
                vc.trip = self.trip
            }
            if vc is TripDetailController {
                let vc = vc as! TripDetailController
                vc.trip = self.trip
            }
        }
    }
}
