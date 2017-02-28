//
//  PoovaliTests.swift
//  PoovaliTests
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import XCTest
@testable import Poovali

class PoovaliTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        PlantRepository.initialize()
        PlantBatchRepository.initialize()
        EventRepository.initialize()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        let plantList = PlantRepository.findAll()
        print("Count of batch = " + PlantBatchRepository.findAll().count.description)
        for plant in plantList {
           let pb = PlantBatch(id:PlantBatchRepository.nextPlantBatchId(), name: plant.name, plantId:plant.id, createdDate:Date(), description:"New Plant")
            plant.addOrUpdatePlantBatch(plantBatch: pb)
            PlantBatchRepository.store(plantBatch: pb)
        }
        print("Count of batch = " + PlantBatchRepository.findAll().count.description)
        var createdDC = DateComponents()
        createdDC.year = 2017
        createdDC.month = 1
        createdDC.day = 1
        
        let createdDate = Calendar.current.date(from:createdDC)
        let sowingDate = plantList[0].getNextSowingDate(createdDate: createdDate!)
        let sowingDC = Calendar.current.dateComponents([.year,.month,.day], from: sowingDate)
        let df = DateFormatter()
        df.dateStyle = .short
        print(df.string(from:sowingDate))
        XCTAssert(sowingDC.year == 2017 && sowingDC.month == 3 && sowingDC.day == 22)
        let pendingDays = plantList[0].pendingSowDays()
        print("Pending Days"+pendingDays!.description)
        
        let d = Date()
        let batch = plantList[0].findBatch(inputDate: d)
        
        XCTAssert(batch != nil , "Batch")
        XCTAssert(!PlantBatchRepository.isEmpty())
        XCTAssert(plantList[0].getCropDuration() == 150)
        XCTAssert(plantList[3].getCropDuration() == 55, "Radish crop")
    }
}
