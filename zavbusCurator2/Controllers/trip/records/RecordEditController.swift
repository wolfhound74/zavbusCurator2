import UIKit

class RecordEditController: UITableViewController {

    var tripRecord: TripRecord?
    var tripProgram: TripProgram?

    @IBOutlet weak var orderedKitlabel: UILabel!
    @IBOutlet weak var orderedKitNameCell: UITableViewCell!
    @IBOutlet weak var comment: UILabel!

    @IBOutlet weak var statusSegment: UISegmentedControl!
    @IBOutlet weak var needStuffSwitch: UISwitch!
    @IBOutlet weak var needMealSwitch: UISwitch!
    @IBOutlet weak var needInsuranceSwitch: UISwitch!

    @IBOutlet weak var resultSum: UILabel!
    @IBOutlet weak var usedBonuses: UILabel!
    @IBOutlet weak var paidBonusesCell: UIView!

    @IBAction func changeProgramAction(_ sender: UISegmentedControl) {
        let i = sender.selectedSegmentIndex

        changeProgram(status: statusesIndex[i] as! Int32)
        updateResultSum()
    }

    @IBAction func changeOptionsAction(_ sender: UISwitch) {
        tripRecord?.needStuff = needStuffSwitch.isOn
        tripRecord?.needMeal = needMealSwitch.isOn
        updateResultSum()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        orderedKitNameCell.textLabel?.text = tripRecord?.orderedKit

        needStuffSwitch.isOn = (tripRecord?.needStuff)!
        needMealSwitch.isOn = (tripRecord?.needMeal)!
        needInsuranceSwitch.isOn = false

        statusSegment.selectedSegmentIndex = statusesIndex.filter {
            $0.value == tripRecord!.status
        }.first?.key as! Int

        if (tripRecord?.payedBonuses == 0) {
//            tableView.willRemoveSubview(paidBonusesCell)
            paidBonusesCell.removeFromSuperview()
        } else {
            usedBonuses.text = "\((tripRecord?.payedBonuses)!)"
        }

        changeProgram(status: (tripRecord?.status)!)
        updateResultSum()

        tableView.reloadData()
    }

    func changeProgram(status: Int32) {
        self.tripProgram = tripRecord?.trip?.programs?.filter {
            ($0 as! TripProgram).status == status
        }.first as! TripProgram

        tripRecord?.status = status

        updateResultSum()
    }

    func updateResultSum() {
        var sumForPay: Int32 = 0

        sumForPay += (tripProgram?.basicPrice)!

        if (needStuffSwitch.isOn) {
            sumForPay += (tripProgram?.stuffPrice)!
        }
        if (needMealSwitch.isOn) {
            sumForPay += (tripProgram?.mealPrice)!
        }
        sumForPay -= (tripRecord?.payedBonuses)!
        sumForPay -= (tripRecord?.paidSum)!

        tripRecord?.sumForPay = sumForPay
        tripRecord?.save()

        resultSum.text = "\(sumForPay)"
    }


}
