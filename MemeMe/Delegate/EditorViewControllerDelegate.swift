//
//  EditorViewControllerDelegate.swift
//  MemeMe
//
//  Created by Denys Medina Aguilar on 20/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import Foundation

protocol EditorViewControllerDelegate {
    
    // method called from EditorVC to notify a delegate when a meme has been shared and saved
    func didSaveMeme(newMeme: Meme)
}
