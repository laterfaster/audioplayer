//
//  MealTableViewCell.swift
//  AudioDemo
//
//  Created by iOS_Club-11 on 2019/8/20.
//  Copyright © 2019 iOS_Club-11. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {

    //MARK: Properties

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var musicImageView: UIImageView!
    
    @IBOutlet weak var artistAndAlbum: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
