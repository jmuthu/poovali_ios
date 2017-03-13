//
//  Event.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import Foundation
class Event:NSObject, NSCoding {
   
    var id:UInt32
    var createdDate:Date
    var desc:String
    var batchId: UInt32
    
    init(id:UInt32, createdDate:Date, description:String, batchId:UInt32) {
        self.id = id
        self.createdDate = createdDate
        self.desc = description
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
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(batchId, forKey: "batchId")
        coder.encode(desc, forKey:"description")
        coder.encode(createdDate, forKey:"createdDate")
    }
    
    required convenience init(coder decoder: NSCoder) {
        let id = decoder.decodeObject(forKey: "id") as! UInt32
        let description = decoder.decodeObject(forKey: "description") as! String
        let batchId = decoder.decodeObject(forKey:"batchId") as! UInt32
        let createdDate = decoder.decodeObject(forKey:"createdDate") as! Date
        self.init(id:id, createdDate:createdDate, description:description, batchId:batchId)
    }
}
