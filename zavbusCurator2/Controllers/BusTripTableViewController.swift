import UIKit
import CoreData

class BusTripTableViewController: UITableViewController {

    var busTrips = [NSManagedObject]()

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
        cell.textLabel?.text = trip.value(forKeyPath: "title") as? String
        cell.detailTextLabel?.text = trip.value(forKeyPath: "dates") as? String

        return cell
    }

    private func getDataFromServer() {
//        let url = URL(string: "http://zavbus.team/api/curatorData")
        let url = URL(string: "http://localhost:8090/api/curatorData")
        do {
            let data = try Data(contentsOf: url!)
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                let loadTrips = dict.object(forKey: "trips") as! Array<NSDictionary>

                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext

                for var trip in loadTrips {
                    let tripEntity = NSEntityDescription.entity(forEntityName: "Trip", in: managedContext)!
                    let tripObject = NSManagedObject(entity: tripEntity, insertInto: managedContext)

                    tripObject.setValue(trip.object(forKey: "id") as? Int16, forKey: "id")
                    tripObject.setValue(trip.object(forKey: "dates") as? String, forKeyPath: "dates")
                    tripObject.setValue(trip.object(forKey: "title") as? String, forKey: "title")

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

        let managedContext =  appDelegate.persistentContainer.viewContext
        let fetchRequest =  NSFetchRequest<NSManagedObject>(entityName: "Trip")

        do {
            busTrips = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }



    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tripRecords" {
            if let indexPath = tableView.indexPathForSelectedRow {
//                let records = busTrips[indexPath.row].records
//                let controller = segue.destination as! TripRecordTableViewController
//                controller.records = records
//                controller.trip = busTrips[(tableView.indexPathForSelectedRow?.row)!]
//
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }


}
