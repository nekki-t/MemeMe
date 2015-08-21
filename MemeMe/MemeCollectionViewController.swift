//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by nekki t on 2015/08/15.
//  Copyright (c) 2015年 next3. All rights reserved.
//
import UIKit

class MemeCollectionViewController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Variables
    var memes:[Meme]!
    
    // MARK: - IBOutlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = false
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        memeCollectionView.reloadData()
    }
    
    // MARK: - CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        cell.memedImage?.image = memes[indexPath.row].memedImage
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailVC = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        detailVC.memeIndex = indexPath.row
        detailVC.meme = memes[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func addMeme(sender: UIBarButtonItem) {
        let editMemeVC = storyboard?.instantiateViewControllerWithIdentifier("EditMemeViewController") as! EditMemeViewController
        
        presentViewController(editMemeVC, animated: true, completion: nil)
    }
}
