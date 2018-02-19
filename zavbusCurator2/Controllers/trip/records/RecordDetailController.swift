import UIKit

class RecordDetailController: UIViewController, UITextFieldDelegate {

    var tripRecord: TripRecord?
    var tripProgram: TripProgram?

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var comment: UILabel!

    @IBOutlet var mainContentView: UIView!
    //селекторы смены состония записи
    @IBOutlet weak var statusSegment: UISegmentedControl!
    @IBOutlet weak var needStuffSwitch: UISwitch!
    @IBOutlet weak var needMealSwitch: UISwitch!
    @IBOutlet weak var needInsuranceSwitch: UISwitch!

    @IBOutlet weak var resultSumInput: UITextField!
    @IBOutlet weak var usedBonuses: UILabel!

    @IBAction func changeProgramAction(_ sender: UISegmentedControl) {
        changeTripRecordState()
    }

    @IBAction func changeOptionsAction(_ sender: UISwitch) {
        changeTripRecordState()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.resultSumInput.delegate = self
        self.resultSumInput.keyboardType = UIKeyboardType.numberPad

        initTripRecordState()
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
//        orderedKitNameCell.textLabel?.text = tripRecord?.orderedKit

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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resultSumInput.resignFirstResponder()
        return (true)
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        scrollView.setContentOffset(CGPoint(x: 0, y: 220), animated: true)
        return true
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        return true
    }
}
