//
//  EditorViewController.swift
//  MemeMe
//
//  Created by Denys Medina Aguilar on 16/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    internal var delegate: EditorViewControllerDelegate?
    internal var meme: Meme?
    
    // Initial meme text atributes for textfields TOP and BOTTOM
    private let memeTextAttributes = [
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 46)!,
        NSStrokeWidthAttributeName : -2.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting text attributes and delegates to textfields
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        topTextField.delegate = self
        bottomTextField.delegate = self
        prefersStatusBarHidden()
        
        // Configuring meme properties to the view when a meme is being edited
        if let meme = self.meme {
            imageView.image = meme.originalImage
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
            shareButton.enabled = true
            topTextField.enabled = true
            bottomTextField.enabled = true
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Validating if camera is supported by the device
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            cameraButton.enabled = false
        }
        
        //Disabling cancel button when there aren't any memes saved
        if MemeAPI.sharedInstance().memes.count == 0 {
            cancelButton.enabled = false
        }
        
        //Adding observers for keyboard notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Removing observers for keyboard notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }

    @IBAction func pickPhoto(sender: UIBarButtonItem) {
        
        //Configuring and presenting image picker according to the option selected Camera or Album
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    
        if sender == cameraButton {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        }
        else {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        if let selectedImage = imageView.image {
        
            //Creating an snapshot of the memedImage
            let memeImage = generateMemedImage()
            
            let activity = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
            
            //Property required to present activityVC on ipad
            activity.popoverPresentationController?.barButtonItem = shareButton
            
            //When sharing is completed successfully, it saves the meme and dismiss activityVC
            activity.completionWithItemsHandler = { (activityType, completed, returnItems, activityError ) in
                if completed && activityError == nil {
                    self.saveMeme(selectedImage, editedImage: memeImage)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            presentViewController(activity, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        //Setting the image selected by the user and configuring controls to edit the meme
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
            shareButton.enabled = true
            topTextField.enabled = true
            bottomTextField.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func generateMemedImage() -> UIImage {
        
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImage
    }
    
    private func saveMeme(originalImage:UIImage, editedImage: UIImage) {
        
        var savedMeme:Meme!
        
        //Updating meme object when a meme is being edited
        if let meme = self.meme {
            meme.originalImage = originalImage
            meme.editedImage = editedImage
            meme.topText = topTextField.text
            meme.bottomText = bottomTextField.text
            savedMeme = meme
        }
        else {
            //Creating a new meme object and it is added to the array
            let newMeme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: originalImage, editedImage: editedImage)
            MemeAPI.sharedInstance().memes.append(newMeme)
            savedMeme = newMeme
        }
        
        // Notify delegates that a meme has been saved
        if let delegate = self.delegate {
            delegate.didSaveMeme(savedMeme)
        }
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //Validate text in textfields to replace them for user input
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    func keyboardWillShow (notification: NSNotification) {
        
        //Moving up view when bottom textfield is being editing
        if self.bottomTextField.editing {
            
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
            self.view.frame.origin.y -= keyboardSize.CGRectValue().height
        
        }
    }
    
    func keyboardWillHide (notification: NSNotification) {
        
        //Moving down view when bottom textfield has being edited
        if self.bottomTextField.editing {
            
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
            self.view.frame.origin.y += keyboardSize.CGRectValue().height

        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
