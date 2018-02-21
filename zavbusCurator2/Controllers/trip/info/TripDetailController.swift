import UIKit

class TripDetailController: UIViewController {

    var trip: Trip?

    @IBOutlet weak var allMembersNumberLabel: UILabel!
    @IBOutlet weak var ridersNumberLabel: UILabel!
    @IBOutlet weak var beginnersNumberLabel: UILabel!
    @IBOutlet weak var busOnlyNumberLabel: UILabel!
    @IBOutlet weak var curatorsNumberLabel: UILabel!
    @IBOutlet weak var photographerNumberLabel: UILabel!
    @IBOutlet weak var instructorNumberLabel: UILabel!
    @IBOutlet weak var absenceNumberLabel: UILabel!
    @IBOutlet weak var resultSumLabel: UILabel!


    @IBOutlet weak var mealsCountLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        allMembersNumberLabel.text = "\(countAllMembers())"
        ridersNumberLabel.text = "\(countMembers(withStatus: 4))"
        beginnersNumberLabel.text = "\(countMembers(withStatus: 5))"
        busOnlyNumberLabel.text = "\(countMembers(withStatus: 6))"
        curatorsNumberLabel.text = "\(countMembers(withStatuses: [1, 2]))"
        photographerNumberLabel.text = "\(countMembers(withStatus: 3))"
        instructorNumberLabel.text = "\(countMembers(withStatus: 8))"
        absenceNumberLabel.text = "\(countAbsenceMembers())"

        mealsCountLabel.text = "\(countMeals())"

        resultSumLabel.text = "\(countPaidSums())"
    }

    func countMembers(withStatus status: Int) -> Int {
        return doFilter {
            let tr = $0 as! TripRecord
            return tr.status == status && tr.confirmed
        }
    }

    func countMembers(withStatuses statuses: [Int]) -> Int {
        return doFilter {
            let tr = $0 as! TripRecord
            return statuses.contains(Int(tr.status)) && tr.confirmed
        }
    }

    func countAllMembers() -> Int {
        return doFilter {
            ($0 as! TripRecord).confirmed
        }
    }

    func countMeals() -> Int {
        return doFilter {
            let tr = $0 as! TripRecord
            return tr.needMeal && tr.confirmed
        }
    }

    func countAbsenceMembers() -> Int {
        return doFilter {
            !($0 as! TripRecord).confirmed
        }
    }

    func doFilter(closure: (Any) -> Bool) -> Int {
        return (trip?.records?.filter(closure).count)!
    }

    func countPaidSums() -> Int32 {
        let paidRecs = trip?.records?.filter {
            ($0 as! TripRecord).confirmed == true
        } as! [TripRecord]

        var paidSums: Int32 = 0

        for var rec in paidRecs {
            paidSums += rec.sumForPay
        }
        return paidSums
    }

}
