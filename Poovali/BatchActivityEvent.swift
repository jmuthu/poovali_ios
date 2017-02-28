//
//  BatchActivityEvent.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import Foundation
class BatchActivityEvent :Event {
    var type:ActivityType
    
    init(id: UInt32, type: ActivityType, createdDate: Date, description:String, batchId:UInt32 ) {
        self.type = type
        super.init(id:id, createdDate:createdDate, description:description, batchId:batchId)
    }
    
    override func getName() -> String {
        return NSLocalizedString(String(describing: type), comment: "")
    }
    
    override func getImageResourceId() -> String {
        return getName();
    }
 
    enum ActivityType:UInt8 {
        case DEWEED = 0
        case FERTILIZER = 1
        case HARVEST = 2
        case MICRO_NUTRIENTS = 3
        case MULCH = 4
        case PESTICIDE = 5
        case PRUNE = 6
        case REPLANT = 7
        case WATER = 8
    }
}
