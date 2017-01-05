//
//  TransferCell.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 10/28/16.
//  Copyright © 2016 Ola. All rights reserved.
//

import UIKit

class TransfersCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var reason: UILabel!
    @IBOutlet weak var dateSent: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
