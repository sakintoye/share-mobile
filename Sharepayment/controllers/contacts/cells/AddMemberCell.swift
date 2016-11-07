//
//  AddMemberCell.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 11/2/16.
//  Copyright © 2016 Ola. All rights reserved.
//

import UIKit

class AddMemberCell: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
