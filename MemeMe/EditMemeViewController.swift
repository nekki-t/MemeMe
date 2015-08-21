//
//  ViewController.swift
//  MemeMe
//
//  Created by nekki t on 2015/08/11.
//  Copyright (c) 2015年 next3. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Constants
    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    
    // MARK: - Variables
    var originalY:CGFloat = 0.0
    var editMeme: Meme?
    var memeIndex: Int?
    
    // MARK: - IBOutlets
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var targetImage: UIImageView!
    @IBOutlet weak var itemBtnCamera: UIBarButtonItem!
    @IBOutlet weak var itemBtnCancel: UIBarButtonItem!
    @IBOutlet weak var itemBtnShare: UIBarButtonItem!    
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Top and Bottom textFields
        setTextFields()
        
        if let target = editMeme {
            textTop.text = target.topText
            textBottom.text = target.bottomText
            targetImage.image = target.originalImage
            view.sendSubviewToBack(targetImage)
        } else {
            itemBtnShare.enabled = false
        }
        
        originalY = view.frame.origin.y
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        itemBtnCamera.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotification()
    }

    // MARK: - IBActions
    // from Camera when available
    @IBAction func btnCameraTapped(sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .Camera
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    // from Album
    @IBAction func btnAlbumTapped(sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    // Share
    @IBAction func btnShareTapped(sender: UIBarButtonItem) {
        
        var memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(
            activityItems: [memedImage],
            applicationActivities: nil
        )
        
        activityViewController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItem: Array!, error: NSError!) in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func editCanceled(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)        
    }
    
    
    // MARK: - Functions
    
    // Set Text Properties and default texts
    func setTextFields () {
        
        //default attributes
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        textTop.defaultTextAttributes = memeTextAttributes
        textBottom.defaultTextAttributes = memeTextAttributes
        
        // alignment
        textTop.textAlignment = .Center
        textBottom.textAlignment = .Center
        
        // borderstyle
        textTop.borderStyle = .None
        textBottom.borderStyle = .None
        
        // delegate
        textTop.delegate = self
        textBottom.delegate = self
        
        // set default texts -> values might be changed
        textTop.text = defaultTopText
        textBottom.text = defaultBottomText
        
    }
    
    // to move up the imageView, only for the bottom textfield
    func keyboardWillShow(notification: NSNotification) {
        if textBottom.editing{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // to move down the imageView to the original position
    func keyboardWillHide(notification: NSNotification) {
        // always to the original position y
        view.frame.origin.y = originalY
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    // for moving the position of the bottom textfield, in order to edit
    func subscribeToKeyboardNotification () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // to clear notifications
    func unsubscribeFromKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    // MARK: - imagePicker delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            targetImage.image = image
            view.sendSubviewToBack(targetImage)
            itemBtnShare.enabled = true
        }
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - textField delegates
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == textTop && textField.text == defaultTopText {
            textTop.text = ""
        } else if textField == textBottom && textField.text == defaultBottomText {
            textBottom.text = ""
        }
    }
    
    
    // memedImage for sharing
    func generateMemedImage() -> UIImage {
        
        // to avoid editing view
        view.endEditing(true)
        
        //hide navbar & toolbar
        navBar.hidden = true
        toolBar.hidden = true
        
        //generate image
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //show navbar & toolbar
        navBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
    func save() {
        if var targetMeme = editMeme {
            // update after edited
            targetMeme.topText = textTop.text
            targetMeme.bottomText = textBottom.text
            targetMeme.originalImage = targetImage.image
            targetMeme.memedImage = generateMemedImage()
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes[memeIndex!] = targetMeme
        } else {
            // create
            var meme = Meme(topText: self.textTop.text, bottomText: self.textBottom.text, originalImage: self.targetImage.image, memedImage: generateMemedImage())
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        }
    }
}

