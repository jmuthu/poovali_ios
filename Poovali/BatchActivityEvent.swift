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
        return String(describing: type).lowercased();
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
        
        static let allValues = 	[DEWEED, FERTILIZER, HARVEST, MICRO_NUTRIENTS, MULCH, PESTICIDE, PRUNE, REPLANT, WATER]
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with:coder)
        coder.encode(type.rawValue, forKey:"type")
    }
    
    required convenience init(coder decoder: NSCoder) {
        let id = decoder.decodeObject(forKey: "id") as! UInt32
        let description = decoder.decodeObject(forKey: "description") as! String
        let batchId = decoder.decodeObject(forKey:"batchId") as! UInt32
        let createdDate = decoder.decodeObject(forKey:"createdDate") as! Date
        let type = ActivityType(rawValue: decoder.decodeObject(forKey: "type") as! UInt8)
        self.init(id:id, type:type!, createdDate:createdDate, description:description, batchId:batchId)
    }
}
