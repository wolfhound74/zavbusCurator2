import UIKit

class TripRecordInfoViewController: UITableViewController {

    var tripRecord: TripRecord?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = tripRecord?.getFullName()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editRecord" {
            if let indexPath = tableView.indexPathForSelectedRow {
//                let record = records[indexPath.row]
                let controller = segue.destination as! EditRecordController
//
                controller.tripRecord = self.tripRecord
            }
        }
    }

}

