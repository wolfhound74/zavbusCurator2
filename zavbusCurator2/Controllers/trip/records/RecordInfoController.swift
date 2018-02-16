import UIKit

class RecordInfoController: UIViewController {

    var tripRecord: TripRecord?

    @IBOutlet weak var confirmButton: UIButton!

    @IBAction func confrimRecordAction(_ sender: UIButton) {
        tripRecord?.confirmed = !(tripRecord?.confirmed)!
        tripRecord?.save()
        changeButtonState()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = (tripRecord?.lastName)! + " " + (tripRecord?.firstName)!

        changeButtonState()
    }

    func changeButtonState() {
        if (tripRecord?.confirmed)! {
            confirmButton.setTitle("Отменить", for: .normal)
            confirmButton.backgroundColor = UIColor.red
        } else {
            confirmButton.setTitle("Подтвердить", for: .normal)
            confirmButton.backgroundColor = UIColor.blue
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editRecord" {
            let controller = segue.destination as? RecordEditController
            controller?.tripRecord = tripRecord
        }
    }
}

