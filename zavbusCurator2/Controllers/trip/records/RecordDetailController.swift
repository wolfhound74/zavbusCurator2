import UIKit

class RecordDetailController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    var tripRecord: TripRecord?
    var tripProgram: TripProgram?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var comment: UILabel!

    @IBOutlet var mainContentView: UIView!
    //селекторы смены состония записи
    @IBOutlet weak var statusSegment: UISegmentedControl!
    @IBOutlet weak var needStuffSwitch: UISwitch!
    @IBOutlet weak var needMealSwitch: UISwitch!
    @IBOutlet weak var needInsuranceSwitch: UISwitch!

    @IBOutlet weak var resultSumInput: UITextField!
    @IBOutlet weak var sumChangeInput: UITextField!
    @IBOutlet weak var usedBonuses: UILabel!

    @IBOutlet weak var hiddenBlock: UIView!

    //кнопка подтверждения
    @IBOutlet weak var confirmButton: UIButton!

    @IBAction func confirmRecordAction(_ sender: UIButton) {
        tripRecord?.confirmed = !(tripRecord?.confirmed)!

        if let sm = Int32.init(resultSumInput.text!) {
            tripRecord?.paidSumInBus = sm
        }

        if let sc = Int32.init(sumChangeInput.text!) {
            tripRecord?.sumChange = sc
        }

        tripRecord?.save()
        changeButtonState()
    }


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

        self.sumChangeInput.delegate = self
        self.sumChangeInput.keyboardType = UIKeyboardType.numberPad

        self.scrollView.delegate = self

        self.navigationItem.title = (tripRecord?.lastName)! + " " + (tripRecord?.firstName)!

        initTripRecordState()
        changeButtonState()
//swipe
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backToRecords(swipe:)))
//        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
//        self.view.addGestureRecognizer(rightSwipe)
    }

    @IBAction func resultSumAction(_ sender: UITextField) {
        if let sm = Int32.init(sender.text!) {
            tripRecord?.sumForPay = sm
            tripRecord?.save()
        }
    }

    @IBAction func sumChangeAction(_ sender: UITextField) {
        let text = sender.text != nil && sender.text != "" ? sender.text : "0"

        if let sm = Int32.init(text!) {
            tripRecord?.sumChange = sm
            tripRecord?.save()
        }
    }

    func updateResultSum() {
        if !(tripRecord?.isJustTripMember())! {
            resultSumInput.text = "0"
            sumChangeInput.text = ""
            return
        }
        var sumForPay: Int32 = 0

        //если неподтвержден. то высчитываем сумма заново
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
            sumForPay -= (tripRecord?.prepaidBonuses)!
            sumForPay -= (tripRecord?.paidSumInBus)!

            tripRecord?.sumForPay = sumForPay
            tripRecord?.save()
        } else {
            sumForPay = (tripRecord?.sumForPay)!
        }

        resultSumInput.text = "\(sumForPay)"
        sumChangeInput.text = tripRecord!.sumChange > 0 ? "\(tripRecord!.sumChange)" : ""
    }

    private func initTripRecordState() {
//        orderedKitNameCell.textLabel?.text = tripRecord?.orderedKit

        needStuffSwitch.isOn = (tripRecord?.needStuff)!
        needMealSwitch.isOn = (tripRecord?.needMeal)!
        needInsuranceSwitch.isOn = false

        usedBonuses.text = "\((tripRecord?.prepaidBonuses)!)"

        if (tripRecord?.isJustTripMember())! {
            tripProgram = tripRecord?.getTripProgram()
        }

        if tripProgram != nil && tripRecord!.isJustTripMember() {
            statusSegment.selectedSegmentIndex = (tripProgram?.getIndexByCurrentStatus())!
        }
        updateResultSum()
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
        sumChangeInput.resignFirstResponder()
        return (true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.contentView.endEditing(true)
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        scrollView.setContentOffset(CGPoint(x: 0, y: 220), animated: true)
        return true
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        return true
    }

    func changeButtonState() {
        if (tripRecord?.confirmed)! {
            confirmButton.setTitle("Отменить", for: .normal)
            confirmButton.backgroundColor = UIColor.red
            hiddenBlock.isHidden = false
        } else {
            confirmButton.setTitle("Подтвердить", for: .normal)
            confirmButton.backgroundColor = UIColor.blue
            hiddenBlock.isHidden = true
        }
    }

//swipe
//    @objc func backToRecords(swipe: UISwipeGestureRecognizer) {
//       performSegue(withIdentifier: "backToRecords", sender: self)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "backToRecords" {
//            let controller = segue.destination as! RecordListController
//
//            controller.trip = tripRecord!.trip
//        }
//    }
}