//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Denys Medina Aguilar on 20/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting item size and edit button
        navigationItem.leftBarButtonItem = editButtonItem()
        let layout = collectionView.collectionViewLayout as UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: self.view.frame.width * 0.33, height: self.view.frame.width * 0.33)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Redirecting to meme editor when there aren't sent memes
        if MemeAPI.sharedInstance().memes.isEmpty {
            presentViewController(storyboard?.instantiateViewControllerWithIdentifier("editor") as UIViewController, animated: true, completion: nil)
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return MemeAPI.sharedInstance().memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("memeCell", forIndexPath: indexPath) as MemeCollectionViewCell
        let meme = MemeAPI.sharedInstance().memes[indexPath.item] as Meme
        
        //Configuring custom cell
        if let memeImage = meme.editedImage {
            cell.memedImage.image = meme.editedImage
        }
        
        cell.deleteButton.hidden = !editing
        cell.deleteButton.tag = indexPath.item
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //Getting meme object and sending it to detail screen
        let meme = MemeAPI.sharedInstance().memes[indexPath.item] as Meme
        performSegueWithIdentifier("showDetail", sender: meme)
        
    }
    
    @IBAction func deleteItem(sender: UIButton) {
        
        //Deleting a meme and validating if meme's array is empty after update to redirect to meme Editor screen
        
        MemeAPI.sharedInstance().memes.removeAtIndex(sender.tag)
        collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: sender.tag, inSection: 0)])
        if MemeAPI.sharedInstance().memes.isEmpty {
            editing = false
            performSegueWithIdentifier("addMeme", sender: nil)
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        
        //When collection is in editing mode reload collection to show a delete button option
        super.setEditing(editing, animated: animated)
        collectionView.performBatchUpdates({Void in self.collectionView.reloadSections(NSIndexSet(index: 0))}, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if editing {
            setEditing(false, animated: false)
        }
        
        //Setting meme object to detail screen
        if let identifier = segue.identifier {
            
            if identifier == "showDetail" {
                
                var detailVC = segue.destinationViewController as DetailViewController
                detailVC.meme = sender as Meme
            }
        }
        
    }
}
