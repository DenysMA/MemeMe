//
//  MemeAPI.swift
//  MemeMe
//
//  Created by Denys Medina Aguilar on 19/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import Foundation

class MemeAPI {
    
    internal var memes: Array<Meme>
    
    // Struct variable used to implement a singleton instance
    private struct MemeAPISingleton {
        static var sharedInstance: MemeAPI!
    }
    
    init() {
        //Validates if there is a meme's array saved previously, otherwise it creates a new one
        if let memes = PersistencyManager.loadObject("memes") as? Array<Meme> {
            self.memes = memes
        }
        else {
            memes = Array()
        }
    }
    
    //Method to get an instance of this class
    class func sharedInstance() -> MemeAPI {
        
        if let instance = MemeAPISingleton.sharedInstance {
            return instance
        }
        else {
            MemeAPISingleton.sharedInstance = MemeAPI()
            return MemeAPISingleton.sharedInstance
        }
        
    }
    
    //Method to save meme's array
    func saveMemes() {
        PersistencyManager.saveObject(memes, objectName: "memes")
    }
    
}