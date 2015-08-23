//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by nekki t on 2015/08/16.
//  Copyright (c) 2015年 next3. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: - Constants
    let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    // MARK: - Variables
    var memeIndex: Int!
    var meme: Meme!
    
    // MARK: - IBOutlets
    @IBOutlet weak var memedImage: UIImageView!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        // for returning from the edit view
        meme = applicationDelegate.memes[memeIndex]
        memedImage.image = meme.memedImage
        
        navigationController?.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.tabBarController?.tabBar.hidden = false
    }
    
    // MARK: - IBActions    
    @IBAction func editMeme(sender: UIButton) {
        let editMemeVC = storyboard?.instantiateViewControllerWithIdentifier("EditMemeViewController") as! EditMemeViewController
        editMemeVC.memeIndex = memeIndex
        editMemeVC.editMeme = meme
        
        navigationController?.pushViewController(editMemeVC, animated: true)
    }
    
    @IBAction func deleteMeme(sender: UIButton) {
        let alert = UIAlertController(title: "Delete this meme",
            message: "Are you sure?",
            preferredStyle: .ActionSheet)
        
        // delete
        alert.addAction(
            UIAlertAction(title: "OK",
            style: .Default,
                handler: {
                    action in
                    self.applicationDelegate.memes.removeAtIndex(self.memeIndex)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            )
        )
        
        // cancel
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        )
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
