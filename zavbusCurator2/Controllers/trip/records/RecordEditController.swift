import UIKit

class RecordEditController: UITableViewController {

    var tripRecord: TripRecord?

    @IBOutlet weak var comment: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        comment.text = tripRecord?.commentFromVk

    }


}
