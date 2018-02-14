import UIKit

class TripDetailInfoController: UITableViewController {

    var trip: Trip?

    @IBOutlet weak var rediresCountLabel: UILabel!
    @IBOutlet weak var beginnersCountLabel: UILabel!
    @IBOutlet weak var resultSumLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let ridersCount = trip?.records?.filter {
            ($0 as! TripRecord).status == 4
        }.count

        let beginnersCount = trip?.records?.filter {
            ($0 as! TripRecord).status == 5
        }.count

        rediresCountLabel.text = "\(ridersCount!)"
        beginnersCountLabel.text = "\(beginnersCount!)"

        let paidRecs = trip?.records?.filter {
            ($0 as! TripRecord).paidSum > 0
        }

    }
}
