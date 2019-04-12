//
//  PickerCell.swift
//  Tuseva
//
//  Created by Praveen Khare on 05/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class PickerCell: UITableViewCell {

    @IBAction func btnCheckedClk(_ sender: Any) {
    }
    @IBOutlet var btnChecked: UIButton!
    @IBOutlet var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
