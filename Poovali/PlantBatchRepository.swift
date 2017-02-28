//
//  PlantBatchRepository.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import Foundation


class PlantBatchRepository : FileRepository {
    static let ENTITY_NAME = "PlantBatch"
    static var plantBatchMap = [UInt32:PlantBatch]()
    static var plantBatchList = [PlantBatch]()
    static var maxPlantBatchId:UInt32 = 0
    
    private static func writeToFile() {
        write(entityName: ENTITY_NAME, data: plantBatchMap)
    }
    
    private static func sortPlantBatchList() {
        plantBatchList.sort(by:{
            $0.createdDate.compare($1.createdDate) == ComparisonResult.orderedDescending
        })
    }
    
    static func store(plantBatch:PlantBatch) {
        plantBatchMap[plantBatch.id] = plantBatch
        if (!plantBatchList.contains(plantBatch)) {
            plantBatchList.append(plantBatch)
        }
        sortPlantBatchList()
        writeToFile()
    }
    
    static func delete(plantBatch:PlantBatch) {
        plantBatchMap[plantBatch.id] = nil
        if let index = plantBatchList.index(of: plantBatch) {
            plantBatchList.remove(at: index)
        }
        writeToFile()
    }
    
    static func find(batchId:UInt32) -> PlantBatch? {
        return plantBatchMap[batchId]
    }
    
    static func findAll() -> [PlantBatch] {
        return findAll(sortByModifiedDate:false)
    }
    
    static func findAll(sortByModifiedDate:Bool) -> [PlantBatch] {
        //if (!sortByModifiedDate) {
        //Collections.sort(plantBatchList, batchNameComparator);
        //}
        return plantBatchList
    }
    
    static func isEmpty() -> Bool {
        return plantBatchMap.isEmpty
    }
    
    static func initialize() {
        let map = read(entityName: ENTITY_NAME) as! [UInt32:PlantBatch]?
        if map != nil {
            plantBatchMap = map!
            plantBatchList = Array(plantBatchMap.values)
            sortPlantBatchList()
            
            for plantBatch in plantBatchList {
                let plant = PlantRepository.find(plantId: plantBatch.plantId)
                plant?.addOrUpdatePlantBatch(plantBatch: plantBatch)
                
                if plantBatch.id > maxPlantBatchId {
                    maxPlantBatchId = plantBatch.id;
                }
            }
        }
    }
    
    static func nextPlantBatchId() -> UInt32 {
        maxPlantBatchId += 1
        return maxPlantBatchId
    }
}
