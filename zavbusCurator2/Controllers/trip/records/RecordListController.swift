import UIKit
import CoreData

class RecordListController: UITableViewController, UISearchBarDelegate {

    var records = [TripRecord]()
    var trip: Trip?

    @IBOutlet weak var searchBar: UISearchBar!

    var isSearching = false
    var filteredRecords = [TripRecord]()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
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

        if isSearching {
            return filteredRecords.count
        }

        return trip!.records!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripRecordCell", for: indexPath) as! RecordCell

        let recordItem = (!isSearching ? self.records[indexPath.row] : self.filteredRecords[indexPath.row]) as TripRecord

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

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var text:String = searchBar.text!

        if text == nil || text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredRecords = records.filter {
                ($0.lastName?.contains(text))! || ($0.firstName?.contains(text))!
            }

            tableView.reloadData()
        }
    }
}
