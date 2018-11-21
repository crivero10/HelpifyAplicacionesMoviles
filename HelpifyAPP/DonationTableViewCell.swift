//
//  DonationTableViewCell.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/15/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit

class DonationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var institutionName: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
