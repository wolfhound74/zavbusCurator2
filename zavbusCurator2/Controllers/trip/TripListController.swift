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
        let alertController = UIAlertController(title: "Загрузить данные с сервера?", message: "Все текущие данные на этом устройстве перезапишутся", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Login"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Password"
        }

        let confirmAction = UIAlertAction(title: "Загрузить", style: .default) { (_) in

            //getting the input values from user
            let login = alertController.textFields?[0].text
            let password = alertController.textFields?[1].text

            getDataFromServer(login: login!, password: password!)
            self.loadFromCore()
            self.tableView.reloadData()

        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (_) in
        }

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
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
