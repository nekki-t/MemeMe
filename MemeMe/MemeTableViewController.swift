//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by nekki t on 2015/08/16.
//  Copyright (c) 2015年 next3. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants
    let rowHeight:CGFloat = 100
    
    // MARK: - Variables
    var memes:[Meme]!
    
    // MARK: - IBOutlets
    @IBOutlet weak var memeTableView: UITableView!
    
    
    // MARK: - Life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        memeTableView.reloadData()
    }
    
    
    //MARK: TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell") as! MemeTableViewCell
        
        cell.meme = memes[indexPath.row]
        
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }
    
    // Row Selected -> Detail View
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        detailVC.memeIndex = indexPath.row
        detailVC.meme = memes[indexPath.row]        
        
        navigationController?.pushViewController(detailVC, animated: true)        
    }
    
    // MARK: - IBActions
    @IBAction func addMeme(sender: UIBarButtonItem) {
        let editMemeVC = storyboard?.instantiateViewControllerWithIdentifier("EditMemeViewController") as! EditMemeViewController
        
        //presentViewController(editMemeVC, animated: true, completion: nil)
        navigationController?.pushViewController(editMemeVC, animated: true)
    }
    
}
