//
//  FileRepository.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import Foundation
import os.log

class FileRepository {
    static let FILE_PREFIX = "poovali_"
    
    
    public static func getPath(_ entityName:String) -> String {
        let filePath = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!.appendingPathComponent(FILE_PREFIX + entityName.lowercased()).path
        return filePath;
    }
    
    public static func write(entityName:String, data:Any) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(data, toFile: getPath(entityName))
        if isSuccessfulSave {
            os_log("%@ successfully saved.", log: OSLog.default, type: .debug, entityName)
        } else {
            os_log("Failed to save %@", log: OSLog.default, type: .error, entityName)
        }
    }
    
    public static func read(entityName:String) -> Any? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: getPath(entityName))
    }
}
