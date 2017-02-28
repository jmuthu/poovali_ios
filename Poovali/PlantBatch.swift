//
//  PlantBatch.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import Foundation

class PlantBatch: NSObject, NSCoding {
    var id:UInt32
    var plant:Plant! {
        didSet {
            plantId = plant.id
        }
    }
    var plantId:UInt32
    var name:String
    var createdDate:Date {
        didSet {
            latestEventCreatedDate = createdDate
        }
    }
    var latestEventCreatedDate:Date
    var eventList = [Event]()
    var desc:String
    
    var typeName: String {
        return plant.name
    }
    
    var imageResourceId:String {
        return plant.imageResourceId
    }
    
    init(id:UInt32, name:String, plantId:UInt32, createdDate:Date,
         description:String) {
        self.id = id
        self.plantId = plantId
        self.name = name
        self.createdDate = createdDate
        self.latestEventCreatedDate = createdDate
        self.desc = description
    }
    
    func addOrUpdateEvent(event:Event) {
        if !eventList.contains(event) {
            eventList.append(event)
            event.batchId = id
        }
        if event.createdDate > latestEventCreatedDate {
            latestEventCreatedDate = event.createdDate
        }
        eventList.sort{
            $0.createdDate > $1.createdDate
        }
    }
    
    func deleteEvent(event:Event) {
        if let index = eventList.index(of: event) {
            eventList.remove(at: index)
        }
    }
    
    func findEvent(name:String, inputDate:Date) ->Event? {
        return eventList.first(where: {
            $0.getName() == name && $0.createdDate == inputDate
        })
    }

    func getProgress() -> Int {
        return getDurationInDays() * 100 / plant.getCropDuration()
    }
    
    func getStage() -> Plant.GrowthStage {
        let dayCount = getDurationInDays()
        let growthStageMap = plant.growthStageMap
        if dayCount <= growthStageMap[Plant.GrowthStage.Seedling]! {
            return Plant.GrowthStage.Seedling
        } else if dayCount <= (growthStageMap[Plant.GrowthStage.Seedling]! +
            growthStageMap[Plant.GrowthStage.Flowering]!) {
            return Plant.GrowthStage.Flowering
        } else if dayCount <= (growthStageMap[Plant.GrowthStage.Seedling]! +
            growthStageMap[Plant.GrowthStage.Flowering]! +
            growthStageMap[Plant.GrowthStage.Fruiting]!) {
            return Plant.GrowthStage.Fruiting
        } else if dayCount <= (growthStageMap[Plant.GrowthStage.Seedling]! +
            growthStageMap[Plant.GrowthStage.Flowering]! +
            growthStageMap[Plant.GrowthStage.Fruiting]! +
            growthStageMap[Plant.GrowthStage.Ripening]!) {
            return Plant.GrowthStage.Ripening
        }
        return Plant.GrowthStage.Dormant
    }
    
    func getDurationInDays() -> Int {
        return Date.daysBetween(fromDate: createdDate, toDate: Date())
    }
    
    func toString() -> String {
        return name
    }
    
    func sameIdentityAs(other : PlantBatch?) -> Bool {
        return other != nil && self.id == other!.id
    }
    
    static func == (lhs: PlantBatch, rhs: PlantBatch) -> Bool {
        return lhs.id == rhs.id
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
        coder.encode(desc, forKey:"desc")
        coder.encode(plantId, forKey:"plantId")
        coder.encode(createdDate, forKey:"createdDate")
    }
    
    required convenience init(coder decoder: NSCoder) {
        let id = decoder.decodeObject(forKey: "id") as! UInt32
        let name = decoder.decodeObject(forKey: "name") as! String
        let desc = decoder.decodeObject(forKey: "desc") as! String
        let plantId = decoder.decodeObject(forKey:"plantId") as! UInt32
        let createdDate = decoder.decodeObject(forKey:"createdDate") as! Date
        self.init(id:id, name:name, plantId:plantId, createdDate:createdDate, description:desc)
    }
    
    /*
     static class BatchDescendingComparator implements Comparator<PlantBatch> {
     @Override
     public int compare(PlantBatch b1, PlantBatch b2) {
     return b2.getCreatedDate().compareTo(b1.getCreatedDate());
     }
     }
     
     static class BatchModifiedDescendingComparator implements Comparator<PlantBatch> {
     @Override
     public int compare(PlantBatch b1, PlantBatch b2) {
     return b2.getLatestEventCreatedDate().compareTo(b1.getLatestEventCreatedDate());
     }
     }
     
     static class BatchNameComparator implements Comparator<PlantBatch> {
     @Override
     public int compare(PlantBatch b1, PlantBatch b2) {
     return b1.getName().compareTo(b2.getName());
     }
     }
     */
}