import UIKit

class TripListController: UITableViewController {
    weak var tripViewModel: TripViewModel! {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false;

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.tripViewModel = TripViewModel(appDelegate: appDelegate)
        }
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
            self.tripViewModel.loadFromCore()
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
        return tripViewModel.numberOfTrips()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)

        let trip = tripViewModel.busTrips[indexPath.row]
        cell.textLabel?.text = trip.title
        cell.detailTextLabel?.text = trip.dates! + " | Участники: \(trip.memberNumber)"

        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tripViewModel.loadFromCore()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tripRecords" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let trip = tripViewModel.busTrips[(tableView.indexPathForSelectedRow?.row)!]
                let controller = segue.destination as! TripTabBarController
//                controller.records = (trip.records?.allObjects as! [TripRecord]).sorted { $0.lastName! < $1.lastName! }
                controller.trip = trip
            }
        }
    }
}
