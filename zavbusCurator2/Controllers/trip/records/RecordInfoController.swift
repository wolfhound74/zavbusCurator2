import UIKit

class RecordInfoController: UIViewController {

    var tripRecord: TripRecord?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = tripRecord?.getFullName()

    }
    @IBAction func doPay(_ sender: Any) {
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

