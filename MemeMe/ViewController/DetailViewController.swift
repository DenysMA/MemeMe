//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Denys Medina Aguilar on 20/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, EditorViewControllerDelegate {

    @IBOutlet weak var memedImage: UIImageView!
    internal var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Validating and setting meme imaged to imageview
        if let image = meme.editedImage {
            memedImage.image = image
        }
    }
    
    //delegate method to copy an edited meme object to the internal meme variable
    func didSaveMeme(newMeme: Meme) {
    
        meme = newMeme
        memedImage.image = meme.editedImage
        
    }

    // method to delete a meme object and to come back to sent memes screen
    @IBAction func deleteMeme(sender: UIBarButtonItem) {
        
        if let index = find(MemeAPI.sharedInstance().memes, meme) {
            MemeAPI.sharedInstance().memes.removeAtIndex(index)
            navigationController?.popViewControllerAnimated(!MemeAPI.sharedInstance().memes.isEmpty)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            
            // Passing meme object to be edited and setting the delegate for EditorVC
            if identifier == "editMeme" {
                
                let editorVC = segue.destinationViewController as EditorViewController
                editorVC.delegate = self
                editorVC.meme = meme
            }
        }
    }

}
