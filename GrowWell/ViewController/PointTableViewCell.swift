//
//  PointTableViewCell.swift
//  GrowWell
//
//  Created by Guido william on 27/04/23.
//

import UIKit

class PointTableViewCell: UITableViewCell {

    @IBOutlet weak var lbPoint: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
