import Foundation
import CoreData

class TripViewModel {
    var busTrips = [Trip]()

    var appDelegate: AppDelegate

    var tripRecordViewModel: TripRecordViewModel!

    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }

    func numberOfTrips() -> Int {
        return busTrips.count
    }

    func loadFromCore() {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")

        do {
            self.busTrips = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
