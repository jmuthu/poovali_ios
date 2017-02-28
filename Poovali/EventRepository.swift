//
//  EventRepository.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import Foundation
class EventRepository : FileRepository{
    static let ENTITY_NAME = "Event";
    static var eventMap = [UInt32:Event]();
    static var maxEventId:UInt32 = 0;
    
    static func store(event:Event) {
        eventMap[event.id] = event
        writeToFile()
    }
    
    static func writeToFile () {
        write(entityName: ENTITY_NAME, data:eventMap)
    }
    
    static func find(eventId:UInt32) -> Event! {
        return eventMap[eventId]
    }
    
    static func findAll() -> [Event] {
        return Array(eventMap.values);
    }
    
    static func delete(event:Event) {
        eventMap[event.id] = nil
        writeToFile()
    }
    
    static func initialize() {
        let map = read(entityName: ENTITY_NAME) as! [UInt32:Event]?
        if map != nil {
            eventMap = map!
            for event in eventMap.values {
                let plantBatch = PlantBatchRepository.find(batchId: event.batchId)
                plantBatch!.addOrUpdateEvent(event: event)
                
                if event.id > maxEventId {
                    maxEventId = event.id;
                }
            }
        }
    }
    
    static func nextEventId() -> UInt32 {
        maxEventId += 1
        return maxEventId
    }
}
