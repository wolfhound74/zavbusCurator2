import UIKit
import CoreData

class RecordListController: UITableViewController {

    var records = [TripRecord]()
    var trip: Trip?

    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationItem.title = trip?.dates
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trip!.records!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripRecordCell", for: indexPath)

        cell.textLabel?.text = self.records[indexPath.row].getFullName()
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tripRecord" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let record = records[indexPath.row]
                let controller = segue.destination as! RecordInfoController

                controller.tripRecord = record
            }
        }
    }
}
