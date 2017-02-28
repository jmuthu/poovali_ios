//
//  FileRepository.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import Foundation

class FileRepository {
    static let FILE_PREFIX = "poovali_"
    
    
    public static func getPath(_ entityName:String) -> String {
        let filePath = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)[0].appendingPathComponent(FILE_PREFIX + entityName.lowercased()).path
        return filePath;
    }
    
    public static func write(entityName:String, data:Any) {
        NSKeyedArchiver.archiveRootObject(data, toFile: getPath(entityName))
    }
    
    public static func read(entityName:String) -> Any? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: getPath(entityName))
    }
}
