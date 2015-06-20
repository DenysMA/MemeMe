//
//  Meme.swift
//  MemeMe
//
//  Created by Denys Medina Aguilar on 17/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import UIKit

//Meme model that conforms nscoding in order to implement archiving
class Meme : NSObject, NSCoding {
    
    var topText: String?
    var bottomText: String?
    var originalImage: UIImage?
    var editedImage: UIImage?
    
    //Custom initializer
    init(topText: String, bottomText: String, originalImage: UIImage, editedImage: UIImage) {
        
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.editedImage = editedImage
    }

    //MARK: NSCoding implementation
    required init(coder aDecoder: NSCoder) {
        
        topText = aDecoder.decodeObjectForKey("topText") as? String
        bottomText = aDecoder.decodeObjectForKey("bottomText") as? String
        originalImage = aDecoder.decodeObjectForKey("originalImage") as? UIImage
        editedImage = aDecoder.decodeObjectForKey("editedImage") as? UIImage
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(topText, forKey: "topText")
        aCoder.encodeObject(bottomText, forKey: "bottomText")
        aCoder.encodeObject(originalImage, forKey: "originalImage")
        aCoder.encodeObject(editedImage, forKey: "editedImage")
    }

}
