//
//  PlantBatchTableViewCell.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import UIKit

class PlantBatchTableViewCell :  UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var plantTypeImageView: UIImageView!
    @IBOutlet weak var eventTypeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var batchStatusLabel: UILabel!
    @IBOutlet weak var eventCreateDateLabel: UILabel!
    @IBOutlet weak var circularProgressView: KDCircularProgress!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
