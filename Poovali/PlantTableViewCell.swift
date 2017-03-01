//
//  PlantTableViewCell.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import UIKit

class PlantTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var nextBatchDueLabel: UILabel!
    @IBOutlet weak var lastBatchDateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var plantTypeImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
