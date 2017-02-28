//
//  Plant.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import Foundation

class Plant: NSObject, NSCoding{
    
    var id:UInt32
    var name:String
    var imageResourceId:String
    //Storing uri as string as it is not serializable
    //var imageUri:String
    var growthStageMap = [GrowthStage:Int]()
    var plantBatchList = [PlantBatch]();
    
    init( id:UInt32,
          name:String,
          imageResourceId:String,
          seedling:Int,
          flowering:Int,
          fruiting:Int,
          ripening:Int) {
        self.id = id
        self.name = name
        self.imageResourceId = imageResourceId
        
        self.growthStageMap[GrowthStage.Seedling] = seedling
        self.growthStageMap[GrowthStage.Flowering] = flowering
        self.growthStageMap[GrowthStage.Fruiting] = fruiting
        self.growthStageMap[GrowthStage.Ripening] = ripening
    }
    
    init (id:UInt32,
          name:String,
          imageResourceId:String,
          growthStageMap:[GrowthStage:Int]) {
        self.id = id
        self.name = name
        self.imageResourceId = imageResourceId
        self.growthStageMap = growthStageMap
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
        coder.encode(imageResourceId, forKey: "imageResourceId")
        let growthStageStrings:[Int:Int] = growthStageMap.mapPairs { (key, value) in (key.rawValue , value) }
        coder.encode(growthStageStrings, forKey: "growthStageMap")
    }
    
    required convenience init(coder decoder: NSCoder) {
        let id = decoder.decodeObject(forKey: "id") as! UInt32
        let name = decoder.decodeObject(forKey: "name") as! String
        let imageResourceId = decoder.decodeObject(forKey: "imageResourceId") as! String
        let growthStageInt = decoder.decodeObject(forKey: "growthStageMap") as! [Int:Int]
        let growthStageMap = growthStageInt.mapPairs{(key, value) in (GrowthStage(rawValue: key)! , value)}
        self.init(id:id, name:name, imageResourceId:imageResourceId, growthStageMap:growthStageMap)
    }
    
    func getCropDuration() -> Int {
        var cropDuration = 0
        for value in growthStageMap.values {
            cropDuration += value
        }
        return cropDuration
    }
    
    func findBatch(inputDate:Date) ->PlantBatch? {
        let date = inputDate.getStartOfDay()
        for plantBatch in plantBatchList {
            if date == plantBatch.createdDate.getStartOfDay() {
                return plantBatch
            }
        }
        return nil
    }
    
    func toString() -> String {
        return name;
    }
    
    func getNextSowingDate(createdDate:Date) -> Date {
        return createdDate.add(days:growthStageMap[GrowthStage.Ripening]!)
    }
    
    func getLatestBatch() -> PlantBatch? {
        return plantBatchList[0]
    }
    
    func pendingSowDays() -> Int!{
        if getLatestBatch() == nil {
            return nil
        }
        return Date.daysBetween(fromDate: getNextSowingDate(createdDate: (getLatestBatch()?.createdDate)!), toDate:Date())
    }
    
    func addOrUpdatePlantBatch( plantBatch:PlantBatch) {
        if !plantBatchList.contains(plantBatch) {
            plantBatchList.insert(plantBatch, at:0)
            plantBatch.plant = self
        }
        
        plantBatchList.sort(by:{
            $0.latestEventCreatedDate.compare($1.latestEventCreatedDate) == ComparisonResult.orderedDescending
        })
        
    }
    
    func deleteBatch(plantBatch : PlantBatch) {
        if let index = plantBatchList.index(of: plantBatch) {
            plantBatchList.remove(at: index)
        }
    }
    
    func sameIdentityAs(other: Plant?) -> Bool {
        return other != nil && id == other!.id
    }
    
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum GrowthStage: Int {
        case Seedling = 0
        case Flowering = 1
        case Fruiting = 2
        case Ripening = 3
        case Dormant = 4
    }
    
    public enum DefaultPlant: UInt32 {
        case Brinjal = 0
        case Chilli = 1
        case LadysFinger = 2
        case Radish = 3
        case Tomato = 4
    }
}


