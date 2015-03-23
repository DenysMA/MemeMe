//
//  PersistencyManager.swift
//  MemeMe
//
//  Created by Denys Medina Aguilar on 19/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import Foundation

class PersistencyManager {
    
    //Returns an object previously saved for a specified object name
    class func loadObject(objectName: String) -> AnyObject? {
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(objectName) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data)
        }
        return nil
    }
    
    //Saves in user defaults an object with a specified name
    class func saveObject(object : AnyObject, objectName: String) {
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(object)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: objectName)
        
    }
    
}