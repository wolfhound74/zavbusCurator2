import UIKit
import CoreData

class RecordListController: UITableViewController {

    var records = [TripRecord]()
    var trip: Trip?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        loadRecordsFromCore()
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripRecordCell", for: indexPath) as! RecordCell

        let recordItem = self.records[indexPath.row] as TripRecord

        cell.fullNameLabel?.text = recordItem.lastName! + " " + recordItem.firstName!
        cell.detailsLabel?.text = displayStatuses[recordItem.status]

        cell.paidView.isHidden = !recordItem.confirmed

        if (recordItem.needMeal) {
            cell.detailsLabel?.text?.append(" | Обед")
        }
        if (recordItem.confirmed) {
            cell.detailsLabel?.text?.append(" | Оплачено \(recordItem.sumForPay)")
        }

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

    func loadRecordsFromCore() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TripRecord>(entityName: "TripRecord")

        do {
            //todo !!!!!сделать норм выборку по выезду!!!!!! пока хз как
            let allRecords = try managedContext.fetch(fetchRequest)
            records = allRecords.filter {
                ($0 as TripRecord).trip == trip //todo так не делается :)
            }.sorted {
                $0.lastName! < $1.lastName!
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
