//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Denys Medina Aguilar on 19/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memedImage: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
}

class MemeCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var memedImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
}
