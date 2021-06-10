//
//  MusicTableViewController.swift
//  AudioDemo
//
//  Created by iOS_Club-11 on 2019/8/22.
//  Copyright © 2019 iOS_Club-11. All rights reserved.
//

import UIKit
import os.log
import AVFoundation
import MediaPlayer


let names = try! FileManager.default.contentsOfDirectory(atPath: "/Users/ios_club-11/Desktop/music")


class MusicTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var musicList = [Music]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setList()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return musicList.count
    }
    
    func setList()
    {
        
        
        for name in names
        {
            
            var music:Music?
            var musicName:String?
            var artist:String?
            var album:String?
            var musicImage:UIImage?
            
            //            定义一个字符常量，描述声音文件的路经
            let path_1 = "/Users/ios_club-11/Desktop/music/"
            
            //            将字符串路径，转换为网址路径

                let soudUrl_1 = URL(fileURLWithPath: path_1+name)
                //            对音频播放对象进行初始化，并加载指定的音频文件
                
                
                let avURLAsset = AVURLAsset(url: soudUrl_1)
                musicImage = UIImage(named: "defaultPhoto.png")
                
                for i in avURLAsset.availableMetadataFormats {
                    
                    
                    for j in avURLAsset.metadata(forFormat: i) {
                        
                        
                        if let commonKey = j.commonKey
                        {
                            switch commonKey
                            {
                            case .commonKeyTitle :
                                musicName = j.value as? String
                            case .commonKeyAlbumName :
                                album = j.value as? String
                            case .commonKeyArtist :
                                artist = j.value as? String
                            case .commonKeyArtwork :
                                if let data = j.dataValue,
                                    let image = UIImage(data: data) {
                                    musicImage = image
                                }
                                
                            default :
                                break
                            }
                            
                        }
                    }
                }
                music = Music(name: musicName, artist: artist, album: album, musicImage: musicImage)
                if music != nil
                {musicList.append(music!)}else{print("music is nil")}
            
            
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MusicTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MusicTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        // Fetches the appropriate meal for the data source layout.
        let music = musicList[indexPath.row]
        
        cell.nameLabel.text = music.name
        cell.artistAndAlbum.text = music.artist!
        if music.album != nil
        {
            cell.artistAndAlbum.text = cell.artistAndAlbum.text! + "-" + music.album!
        }
        cell.musicImageView.image = music.musicImage!

        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    var currentTime = TimeInterval()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier) {
        case "PlayingDetail":

            guard let playingDetailViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedCell = sender as? MusicTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
    
            
            playingDetailViewController.musicTable = self
            currentTime = 0
            if currentOrder == indexPath.row && currentState != "stop"
            {
                currentTime = audioPlayer1.currentTime
                return
            }
            currentOrder = indexPath.row

            

        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    
}

