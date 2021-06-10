//
//  Music.swift
//  AudioDemo
//
//  Created by iOS_Club-11 on 2019/8/22.
//  Copyright © 2019 iOS_Club-11. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class Music
{
    //MARK: Properties
    var name:String?
    var artist:String?
    var album:String?
    var musicImage:UIImage?
    
    init?(name:String? ,artist:String? ,album:String? ,musicImage:UIImage?) {
        if name == nil{return nil}
        self.name=name
        self.artist=artist
        self.album=album
        self.musicImage=musicImage
    }
    
    
    
}
