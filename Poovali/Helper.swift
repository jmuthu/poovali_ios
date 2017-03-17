//
//  Helper.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import UIKit

class Helper {
    static func setOverDueText(labelView:UILabel, due:Int){
        var format:String
        if due > 0 {
            labelView.textColor = UIColor.orange;
            format = NSLocalizedString("sow_over_due", comment:"")
        } else {
            format = NSLocalizedString("sow_next", comment:"")
        }
        labelView.text = String.localizedStringWithFormat(format, abs(due))
    }
    
    static func setImage(uIImageView:UIImageView, plant:Plant) {
        if plant.imageResourceId != nil {
            uIImageView.image = UIImage(named:plant.imageResourceId!)
        } else if plant.uiImage != nil {
            uIImageView.image = plant.uiImage
        } else {
            uIImageView.image = UIImage(named:"plant")
        }
    }
}
