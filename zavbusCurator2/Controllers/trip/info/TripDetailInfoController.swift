import UIKit

class TripDetailInfoController: UITableViewController {

    var trip: Trip?

    @IBOutlet weak var rediresCountLabel: UILabel!
    @IBOutlet weak var beginnersCountLabel: UILabel!
    @IBOutlet weak var busOnlyLabel: UILabel!
    @IBOutlet weak var resultSumLabel: UILabel!

    @IBOutlet weak var mealsCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        let ridersNumber = self.countMembers(status: 4)
        let beginnersNumber = self.countMembers(status: 5)
        let busOnlyNumber = self.countMembers(status: 6)

        let mealsNumber = self.countMeals()

        rediresCountLabel.text = "\(ridersNumber)"
        beginnersCountLabel.text = "\(beginnersNumber)"
        mealsCountLabel.text = "\(mealsNumber)"
        busOnlyLabel.text = "\(busOnlyNumber)"

        let paidRecs = trip?.records?.filter {
            ($0 as! TripRecord).confirmed == true
        } as! [TripRecord]

        var paidSum: Int32 = 0

        for var rec in paidRecs {
            paidSum += rec.sumForPay
        }

        resultSumLabel.text = "\(paidSum)"
    }

    func countMembers(status: Int) -> Int {
        return (trip?.records?.filter {
            let tr = $0 as! TripRecord
            return tr.status == status && tr.confirmed
        }.count)!
    }

    func countMeals() -> Int{
        return (trip?.records?.filter {
            let tr = $0 as! TripRecord
            return tr.needMeal && tr.confirmed
        }.count)!
    }
}
