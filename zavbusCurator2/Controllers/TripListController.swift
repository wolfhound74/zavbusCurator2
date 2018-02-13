import UIKit
import CoreData

class TripListController: UITableViewController {

    var busTrips = [Trip]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func reloadDataButton(_ sender: Any) {
        //todo сделать модульный диалог
        getDataFromServer()
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
        cell.detailTextLabel?.text = trip.dates

        return cell
    }

    private func getDataFromServer() {
//        let url = URL(string: "http://zavbus.team/api/curatorData")
        let url = URL(string: "http://127.0.0.1:8090/api/curatorData")
        do {
            let data = try Data(contentsOf: url!)
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                let loadTrips = dict.object(forKey: "trips") as! Array<NSDictionary>

                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext

                if loadTrips.count > 0 {
                    removeAllFromCoreData()
                    busTrips.removeAll()
                }

                for var trip in loadTrips {
                    let tripEntity = NSEntityDescription.entity(forEntityName: "Trip", in: managedContext)!
                    let tripObject = Trip(entity: tripEntity, insertInto: managedContext)

                    tripObject.id = trip.object(forKey: "id") as! Int64
                    tripObject.dates = trip.object(forKey: "dates") as? String
                    tripObject.title = trip.object(forKey: "title") as? String

                    for var record in trip.object(forKey: "records") as! Array<NSDictionary> {
                        let tripRecordEntity = NSEntityDescription.entity(forEntityName: "TripRecord", in: managedContext)!
                        let tripRecordObj = TripRecord(entity: tripRecordEntity, insertInto: managedContext)

                        tripRecordObj.trip = tripObject

                        tripRecordObj.firstName = record.object(forKey: "firstName") as? String
                        tripRecordObj.lastName = record.object(forKey: "lastName") as? String
                        tripRecordObj.id = record.object(forKey: "id") as! Int64
                        tripRecordObj.state = record.object(forKey: "state") as! Int32
                        tripRecordObj.status = record.object(forKey: "status") as! Int32
                        tripRecordObj.commentFromVk = record.object(forKey: "commentFromVk") as? String

                        tripObject.addToRecords(tripRecordObj)
                    }

                    busTrips.append(tripObject)
                    try managedContext.save()
                }
            } catch {
            }
        } catch {
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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

    func removeAllFromCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let managedContext = appDelegate.persistentContainer.viewContext
        let coord = appDelegate.persistentContainer.persistentStoreCoordinator

        let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)

        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tripRecords" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let trip = busTrips[(tableView.indexPathForSelectedRow?.row)!]
                let controller = segue.destination as! RecordListController
                controller.records = trip.records?.allObjects as! [TripRecord]
                controller.trip = trip
            }
        }
    }
}
