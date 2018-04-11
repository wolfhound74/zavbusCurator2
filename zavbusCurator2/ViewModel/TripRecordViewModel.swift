import Foundation
import CoreData

class TripRecordViewModel {
    var tripRecord: TripRecord!

    var appDelegate: AppDelegate

    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }
}
