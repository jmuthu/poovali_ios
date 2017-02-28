//
//  BatchEventFactory.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import Foundation

class BatchEventFactory {
    static func createEvent(type : BatchActivityEvent.ActivityType, createdDate: Date, description:String, batchId:UInt32) -> BatchActivityEvent {
        return BatchActivityEvent(id: EventRepository.nextEventId(), type:type, createdDate:createdDate, description:description, batchId:batchId)
    }
}
