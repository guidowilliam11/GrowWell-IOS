//
//  UsersPlantTableViewCell.swift
//  GrowWell
//
//  Created by Guido william on 25/04/23.
//

import UIKit

class UsersPlantTableViewCell: UITableViewCell {
    
    // Outlets for UI elements
    @IBOutlet weak var tfHeight: UITextField!
    @IBOutlet weak var pbWater: UIProgressView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var ivPlant: UIImageView!
    @IBOutlet weak var btnWater: UIButton!
    
    // Closure to handle table view data reloads
    var updateHandler = {

    }
    
    // Method called when the water button is tapped
    @IBAction func buttonTapped(_ sender: Any) {
        updateHandler()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

