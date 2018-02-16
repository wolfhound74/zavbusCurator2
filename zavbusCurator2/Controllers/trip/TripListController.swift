import UIKit
import CoreData

class TripListController: UITableViewController {

    var busTrips = [Trip]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func reloadDataButton(_ sender: Any) {
        //todo сделать модульный диалог
        getDataFromServer()
        loadFromCore()
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busTrips.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)

        let trip = busTrips[indexPath.row]
        cell.textLabel?.text = trip.title
        cell.detailTextLabel?.text = trip.dates! + " | Участники: \(trip.memberNumber)"

        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadFromCore()
    }

    func loadFromCore() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")

        do {
            busTrips = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tripRecords" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let trip = busTrips[(tableView.indexPathForSelectedRow?.row)!]
                let controller = segue.destination as! TripTabBarController
//                controller.records = (trip.records?.allObjects as! [TripRecord]).sorted { $0.lastName! < $1.lastName! }
                controller.trip = trip
            }
        }
    }
}
