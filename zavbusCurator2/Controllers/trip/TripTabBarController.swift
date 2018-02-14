import UIKit

class TripTabBarController: UITabBarController {
    var records = [TripRecord]()
    var trip: Trip?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = trip?.dates
        self.navigationController?.navigationBar.isTranslucent = false;

        for var vc in viewControllers! {
            if vc is RecordListController {
                let vc = vc as! RecordListController
                vc.records = self.records
                vc.trip = self.trip
            }
            if vc is TripInfoContainer {
                let vc = vc as! TripInfoContainer
                vc.trip = self.trip
            }
        }
    }
}
