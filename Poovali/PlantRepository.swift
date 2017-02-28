//
//  PlantRepository.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import Foundation
import UIKit

class PlantRepository : FileRepository {
    static let ENTITY_NAME = "Plant"
    static var plantMap = [UInt32:Plant]()
    static var plantList = [Plant]()
    static var maxPlantId:UInt32 = 10000 // 1 -10000 reserved for default plants
    
    static func nextPlantId() -> UInt32 {
        maxPlantId += 1
        return maxPlantId
    }
    
    static func find(plantId: UInt32) -> Plant? {
        return plantMap[plantId]
    }
    
    static func findByName(name:String) -> Plant? {
        for plant in plantList {
            if (plant.name == name) {
                return plant
            }
        }
        return nil
    }
    
    static func findAll() -> [Plant] {
        return plantList
    }
    
    private static func writeToFile() {
        write(entityName: ENTITY_NAME, data:plantMap)
    }
    
    private static func sortPlantList() {
        plantList.sort(by:{
            $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending
        })
    }
    
    static func store(plant:Plant) {
        addPlant(plant)
        writeToFile()
    }
    
    static func delete(plant:Plant) {
        plantMap[plant.id] = nil
        if let index = plantList.index(of: plant) {
            plantList.remove(at: index)
        }
        writeToFile()
    }
    
    
    static func initialize() {
        let map = read(entityName: ENTITY_NAME) as! [UInt32:Plant]?
        if map != nil {
            plantMap = map!
            plantList = Array(plantMap.values)
            for plant in plantList {
                if plant.id > maxPlantId {
                    maxPlantId = plant.id;
                }
            }
        } else {
            initializeDefaultItems();
        }
        sortPlantList()
    }
    
    static func addPlant(_ plant:Plant) {
        plantMap[plant.id] = plant
        if !plantList.contains(plant) {
            plantList.append(plant)
        }
        sortPlantList()
    }
    
    static func createPlantFromType(type:Plant.DefaultPlant, seedling:Int,
                                    flowering:Int, fruiting:Int, ripening:Int) -> Plant{
        let name = String(describing:type)
        return Plant(id:type.rawValue,
                     name:NSLocalizedString(name, comment:""),
                     imageResourceId: name.lowercased(),
                     seedling:seedling, flowering:flowering, fruiting:fruiting, ripening:ripening)
    }
    
    static func initializeDefaultItems() {
        addPlant(createPlantFromType(
            type:Plant.DefaultPlant.Brinjal,
            seedling:10, flowering:30, fruiting:30, ripening:80))
        
        addPlant(createPlantFromType(
            type: Plant.DefaultPlant.Chilli,
            seedling:10, flowering:30, fruiting:30, ripening:80))
        
        addPlant(createPlantFromType(
            type:Plant.DefaultPlant.LadysFinger,
            seedling:10, flowering:30, fruiting:30, ripening:30))
        
        addPlant(createPlantFromType(
            type:Plant.DefaultPlant.Radish,
            seedling:15, flowering:20, fruiting:10, ripening:10))
        
        addPlant(createPlantFromType(
            type: Plant.DefaultPlant.Tomato,
            seedling:10, flowering:30, fruiting:30, ripening:80))
        
        writeToFile()
    }
}
