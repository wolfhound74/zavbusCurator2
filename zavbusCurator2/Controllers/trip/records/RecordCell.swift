//
//  RecordCellTableViewCell.swift
//  zavbusCurator2
//
//  Created by владимир on 15.02.2018.
//  Copyright © 2018 Vladimir Maslov. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var paidView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
