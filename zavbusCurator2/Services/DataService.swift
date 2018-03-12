import UIKit
import CoreData

func getDataFromServer(login: String, password: String) {
    if (login == nil || login == "" || password == nil || password == "") {
        return
    }

    let url = URL(string: getUrl() + "/curatorData?username=\(login)&password=\(password)")
//    let url = URL(string: "http://127.0.0.1:8090/api/curatorData?login=\(login)&password=\(password)")
//    let url = URL(string: "http://192.168.1.88:8090/api/curatorData?login=\(login)&password=\(password)")
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
//                busTrips.removeAll()
            }

            for var trip in loadTrips {
                let tripEntity = NSEntityDescription.entity(forEntityName: "Trip", in: managedContext)!
                let tripObject = Trip(entity: tripEntity, insertInto: managedContext)

                tripObject.id = trip.object(forKey: "id") as! Int64
                tripObject.dates = trip.object(forKey: "dates") as? String
                tripObject.title = trip.object(forKey: "title") as? String

                tripObject.memberNumber = trip.object(forKey: "memberNumber") as! Int32
                tripObject.kitNumber = trip.object(forKey: "kitNumber") as! Int32

                // пока хардкод и такая логика
                tripObject.addToPrograms(getTripProgram(status: 4, basicPrice: 1800, stuffPrice: 400, mealPrice: 200, insurancePrice: 50, managedContext: managedContext))
                tripObject.addToPrograms(getTripProgram(status: 5, basicPrice: 1500, stuffPrice: 0, mealPrice: 200, insurancePrice: 50, managedContext: managedContext))
                tripObject.addToPrograms(getTripProgram(status: 6, basicPrice: 850, stuffPrice: 400, mealPrice: 200, insurancePrice: 50, managedContext: managedContext))
                tripObject.addToPrograms(getTripProgram(status: 7, basicPrice: 1500, stuffPrice: 400, mealPrice: 200, insurancePrice: 50, managedContext: managedContext))

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

                    tripRecordObj.orderedKit = record.object(forKey: "orderedKit") as? String
                    tripRecordObj.prepaidBonuses = record.object(forKey: "prepaidBonuses") as! Int32
                    tripRecordObj.paidSumInBus = record.object(forKey: "paidSumInBus") as! Int32
                    tripRecordObj.actualBonuses = record.object(forKey: "actualBonuses") as! Int32
                    tripRecordObj.prepaidSum = record.object(forKey: "prepaidSum") as! Int32

                    tripRecordObj.sumChange = 0
//                    tripRecordObj.mainRiderId = record.object(forKey: "mainRiderId")! as! Int64
                    tripRecordObj.riderId = record.object(forKey: "riderId") as! Int64
                    tripRecordObj.needStuff = record.object(forKey: "needStuff") as! Bool
                    tripRecordObj.needMeal = record.object(forKey: "needMeal") as! Bool

                    tripObject.addToRecords(tripRecordObj)
                }

                try managedContext.save()
            }
        } catch {
        }
    } catch {
    }
}

private func getUrl() -> String {
//    return "http://127.0.0.1:8090/api"
//    return "http://192.168.1.88:8090/api"
    return "http://cp.zavbus.team/api"
}

func sendDataToServer(trip: Trip, login: String, password: String) {
    let url = URL(string:  getUrl() + "/updateTripRecords?username=\(login)&password=\(password)")

    //create the session object
    let session = URLSession.shared

    var request = URLRequest(url: url!)
    request.httpMethod = "POST"

    var recordsArray = [[String: Any]]()

    for record in trip.records! {
        let rec = record as! TripRecord
        if (rec.confirmed) {
            let dict = [
                "recordId": rec.id,
                "paidSumInBus": rec.paidSumInBus,
                "needMeal": rec.needMeal,
                "needStuff": rec.needStuff,
                "needInsurance": rec.needInsurance,
                "status": rec.status
            ] as [String : Any]
            recordsArray.append(dict)
        }
    }

    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: recordsArray, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body

    } catch let error {
        print(error.localizedDescription)
    }

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    //create dataTask using the session object to send data to the server
    let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

        guard error == nil else {
            return
        }

        guard let data = data else {
            return
        }

        do {
            //create json object from data
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                print(json)
            }

        } catch let error {
            print(error.localizedDescription)
        }
    })
    task.resume()

}

// пока хардкод и такая логика
private func getTripProgram(status: Int32, basicPrice: Int32, stuffPrice: Int32, mealPrice: Int32, insurancePrice: Int32,
                            managedContext: NSManagedObjectContext) -> TripProgram {
    let tpEntity1 = NSEntityDescription.entity(forEntityName: "TripProgram", in: managedContext)!
    let obj1 = TripProgram(entity: tpEntity1, insertInto: managedContext)

    obj1.status = status
    obj1.basicPrice = basicPrice
    obj1.stuffPrice = stuffPrice
    obj1.mealPrice = mealPrice
    obj1.mealPrice = mealPrice
    obj1.insurancePrice = insurancePrice

    return obj1
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
