//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Denys Medina Aguilar on 18/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configuring edit button and
        navigationItem.leftBarButtonItem = editButtonItem()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Redirecting to meme editor when there aren't sent memes
        if MemeAPI.sharedInstance().memes.isEmpty {
            presentViewController(storyboard?.instantiateViewControllerWithIdentifier("editor") as! UIViewController, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MemeAPI.sharedInstance().memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("memeCell", forIndexPath: indexPath) as! MemeTableViewCell
        let meme = MemeAPI.sharedInstance().memes[indexPath.row] as Meme
        
        //Configuring custom table view cell
        if let memeImage = meme.editedImage {
            cell.memedImage.image = meme.editedImage
        }
        if let topText = meme.topText {
            cell.topLabel.text = topText
        }
        if let bottomText = meme.bottomText {
            cell.bottomLabel.text = bottomText
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //Setting dynamic size according to the screen size width
        return self.view.frame.width * 0.4
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Getting meme object according to user selection and pushing to detail screen
        let meme = MemeAPI.sharedInstance().memes[indexPath.row] as Meme
        performSegueWithIdentifier("showDetail", sender: meme)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //When table is in edit mode, deletes row selected and updates model
        if editingStyle == UITableViewCellEditingStyle.Delete {
            MemeAPI.sharedInstance().memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            if MemeAPI.sharedInstance().memes.isEmpty {
                editing = false
                performSegueWithIdentifier("addMeme", sender: nil)
            }
        }
        
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        editing = false
        
        //Setting meme object to detail screen
        if let identifier = segue.identifier {
            if identifier == "showDetail" {
                
                var detailVC = segue.destinationViewController as! DetailViewController
                detailVC.meme = sender as! Meme
            }
        }
        
    }
    

}
