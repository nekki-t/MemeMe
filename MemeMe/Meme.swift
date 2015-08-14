//
//  Meme.swift
//  MemeMe
//
//  Created by nekki t on 2015/08/12.
//  Copyright (c) 2015年 next3. All rights reserved.
//

import Foundation
import UIKit
class Meme {
    var topText: String!
    var bottomText: String!
    var originalImage: UIImage!
    var memedImage: UIImage!
    
    init(topText: String!, bottomText: String!, originalImage: UIImage!, memedImage: UIImage!) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}

