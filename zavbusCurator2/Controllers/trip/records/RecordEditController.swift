import UIKit

class RecordEditController: UITableViewController, UITextFieldDelegate {

    var tripRecord: TripRecord?
    var tripProgram: TripProgram?

    @IBOutlet weak var orderedKitlabel: UILabel!
    @IBOutlet weak var orderedKitNameCell: UITableViewCell!
    @IBOutlet weak var comment: UILabel!

//селекторы смены состония записи
    @IBOutlet weak var statusSegment: UISegmentedControl!
    @IBOutlet weak var needStuffSwitch: UISwitch!
    @IBOutlet weak var needMealSwitch: UISwitch!
    @IBOutlet weak var needInsuranceSwitch: UISwitch!

    @IBOutlet weak var resultSumInput: UITextField!
    @IBOutlet weak var usedBonuses: UILabel!
    @IBOutlet weak var paidBonusesCell: UIView!

    @IBAction func changeProgramAction(_ sender: UISegmentedControl) {
        changeTripRecordState()
    }

    @IBAction func changeOptionsAction(_ sender: UISwitch) {
        changeTripRecordState()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        resultSumInput.delegate = self
        resultSumInput.keyboardType = UIKeyboardType.numberPad

        initTripRecordState()
        tableView.reloadData()
    }

    @IBAction func resultSumChangeAction(_ sender: UITextField) {
        var sumForPay: Int32 = 0
        if (sender.text != "") {
            sumForPay = Int32.init(sender.text!)!
        }

        tripRecord?.sumForPay = sumForPay
        tripRecord?.save()
    }

    func updateResultSum() {
        if !(tripRecord?.isJustTripMember())! {
            return
        }
        var sumForPay: Int32 = 0

        if (!(tripRecord?.confirmed)!) {

            sumForPay += (tripProgram?.basicPrice)!

            if (needStuffSwitch.isOn) {
                sumForPay += (tripProgram?.stuffPrice)!
            }
            if (needMealSwitch.isOn) {
                sumForPay += (tripProgram?.mealPrice)!
            }
            if (needInsuranceSwitch.isOn) {
                sumForPay += (tripProgram?.insurancePrice)!
            }
            sumForPay -= (tripRecord?.payedBonuses)!
            sumForPay -= (tripRecord?.paidSum)!

            tripRecord?.sumForPay = sumForPay
            tripRecord?.save()
        } else {
            sumForPay = (tripRecord?.sumForPay)!
        }

        resultSumInput.text = "\(sumForPay)"
    }

    private func initTripRecordState() {

        orderedKitNameCell.textLabel?.text = tripRecord?.orderedKit

        needStuffSwitch.isOn = (tripRecord?.needStuff)!
        needMealSwitch.isOn = (tripRecord?.needMeal)!
        needInsuranceSwitch.isOn = false

        usedBonuses.text = "\((tripRecord?.payedBonuses)!)"

        tripProgram = tripRecord?.getTripProgram()

        if tripProgram != nil && tripRecord!.isJustTripMember() {
            statusSegment.selectedSegmentIndex = (tripProgram?.getIndexByCurrentStatus())!
            updateResultSum()
        }
    }

    private func changeTripRecordState() {
        if (tripRecord?.isJustTripMember())! {
            tripRecord?.status = statusesIndex[statusSegment.selectedSegmentIndex]!
            tripProgram = tripRecord?.getTripProgram()
        }

        tripRecord?.needStuff = needStuffSwitch.isOn
        tripRecord?.needMeal = needMealSwitch.isOn
        tripRecord?.needInsurance = needInsuranceSwitch.isOn
        tripRecord?.save()

        updateResultSum()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resultSumInput.resignFirstResponder()
        return (true)
    }
}
