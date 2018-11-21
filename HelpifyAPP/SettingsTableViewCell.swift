//
//  SettingsTableViewCell.swift
//  HelpifyAPP
//
//  Created by Carlos Rivero on 11/8/18.
//  Copyright © 2018 Carlos Rivero. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "Hola como estas"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
