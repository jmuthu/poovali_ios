//
//  Event.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import Foundation
class Event:Equatable {
   
    var id:UInt32
    var createdDate:Date
    var description:String
    var batchId: UInt32
    
    init(id:UInt32, createdDate:Date, description:String, batchId:UInt32) {
        self.id = id
        self.createdDate = createdDate
        self.description = description
        self.batchId = batchId
    }

    func toString() -> String {
        return getName()
    }
    
    func getName() -> String {
        return ""
    }
    
    func getImageResourceId() -> String {
        return ""
    }
    
    func getTypeName() -> String {
        return getName()
    }
    
    func sameIdentityAs(other:Event!) -> Bool{
        return other != nil && self.id == other.id;
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id;
    }
}
