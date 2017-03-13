//
//  ActivityTableViewCell.swift
//  Poovali
//

//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
