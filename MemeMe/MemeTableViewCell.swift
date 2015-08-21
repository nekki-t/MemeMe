//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by nekki t on 2015/08/16.
//  Copyright (c) 2015年 next3. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var memedImage: UIImageView!
    @IBOutlet weak var memedText: UILabel!
    
    // MARK: - Properties
    var meme = Meme() {
        didSet {
            memedImage.image = meme.memedImage
            memedText.text = "\(meme.topText)...\(meme.bottomText)"
        }
    }
}
