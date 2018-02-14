import UIKit

class TripInfoContainer: UIViewController {

    var trip: Trip?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailInfo" {
            let controller = segue.destination as? TripDetailInfoController
            controller?.trip = trip
        }
    }
}
