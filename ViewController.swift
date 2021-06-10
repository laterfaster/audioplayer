//
//  ViewController.swift
//  swiftUI
//
//  Created by iOS_Club-11 on 2019/8/14.
//  Copyright © 2019 iOS_Club-11. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

var currentOrder = 0
//状态：play pause stop
var currentState="stop"
var audioPlayer1:AVAudioPlayer = AVAudioPlayer()

class ViewController: UIViewController {
    
  
    var musicTable:MusicTableViewController?
    //    初始化音频播放对像，做为视图控制器类的属性

    

    var minDuration:TimeInterval?
    
    //music list
    var musicList = names
    
    
    @IBOutlet weak var musicSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.musicSlider.addObserver(self, forKeyPath: "value", options: .new, context: nil)
        
        
        // Do any additional setup after loading the view, typically from a nib.
        //        获得音频会话对像，该对像属于单例模式，也就是说不用开发者而自行实例化，这个类在各种音频环境中起着非常重要的作用
        let session = AVAudioSession.sharedInstance()
        //        创建一个异常捕捉语句
        
        do{
            //            启动音频会话的管理，此时会阻断后台音乐的播放
            try session.setActive(true)
            //            设置音频操作类别，标示该应用仅支持音频的播放
            try session.setCategory(AVAudioSession.Category.playback)
            //            设置应用程序支持接受远程控制事件
            UIApplication.shared.beginReceivingRemoteControlEvents()
            
            MRGCDTimer.share.scheduledDispatchTimer(withName: "name", timeInterval: 0.1, queue: .main, repeats: true) {
                //code
                if currentState == "play"
                {
                    self.musicSlider.value += 0.1
                    
                }
            }
            
            setPlayer()
            
            musicSlider.value = Float(musicTable!.currentTime)

            
        } catch{
            print(error)
        }
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "value" {
            if let newTime = change?[NSKeyValueChangeKey.newKey] as? Float
            {
                if newTime == musicSlider.maximumValue && currentState == "play"
                {
                    stop()
                }
                if abs(newTime-Float(audioPlayer1.currentTime))>2
                {
                audioPlayer1.currentTime=TimeInterval(newTime)

                }
            }
        }

    }
    
    //button

    @IBOutlet weak var playButton: UIButton!
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch currentState {
        case "play":
            //pause code
            pause()
            
        case "pause":
            //play code
            play()

        case "stop":
            musicSlider.value=0
            play()
        default:
            print("wrong input")
        }
    }
    
    

    
    
    

    
    func pause()
    {
        audioPlayer1.pause()
        
        currentState="pause"
        playButton.setTitle("play", for: .normal)
        
    }
    
    func play()
    {
        audioPlayer1.play()

        currentState="play"
        playButton.setTitle("pause", for: .normal)
    }
    
    func stop()
    {
        audioPlayer1.stop()

        currentState="stop"
        playButton.setTitle("play", for: .normal)
    }
    
    //歌曲信息
    //歌曲名
    var musicName:String?
    
    @IBOutlet weak var musicNameLabel: UILabel!
    
    //封面图片
    var musicImg:UIImage?
    
    @IBOutlet weak var musicImgView: UIImageView!
    
    //专辑名
    var albumName:String?
    
    
    //歌手
    var artist:String?
    
    @IBOutlet weak var artistLabel: UILabel!
    
    
    
    
    func process(metaItem item: AVMetadataItem) {
        
        guard let commonKey = item.commonKey else { return }
        switch commonKey
        {
        case .commonKeyTitle :
            musicName = item.value as? String
        case .commonKeyAlbumName :
            albumName = item.value as? String
        case .commonKeyArtist :
            artist = item.value as? String
        case .commonKeyArtwork :
            if let data = item.dataValue,
                let image = UIImage(data: data) {
                musicImg = image
            }
            
        default :
            break
        }
    }
    
    func setPlayer()
    {
        
    do{
        //            定义一个字符常量，描述声音文件的路经
        let path_1 = "/Users/ios_club-11/Desktop/music/"+musicList[currentOrder]
        
        //            将字符串路径，转换为网址路径
        if path_1 != nil
        {
            let soudUrl_1 = URL(fileURLWithPath: path_1)
            //            对音频播放对象进行初始化，并加载指定的音频文件
            try audioPlayer1 = AVAudioPlayer(contentsOf: soudUrl_1)
            
            audioPlayer1.prepareToPlay()
            //            设置音频播放对象的音量大小/
            audioPlayer1.volume = 1.0
            //            设置音频的播放次数，-1为无限循环
            audioPlayer1.numberOfLoops = 1
            
            let avURLAsset = AVURLAsset(url: soudUrl_1)
            musicImg = UIImage(named: "defaultPhoto.png")
            
            for i in avURLAsset.availableMetadataFormats {
                
                
                for j in avURLAsset.metadata(forFormat: i) {
                    process(metaItem: j)
                }
                
            }
            
            musicNameLabel.text = musicName
            artistLabel.text = artist
            musicImgView.image = musicImg
            
            musicSlider.maximumValue=Float(audioPlayer1.duration)
            
            play()
            

            
        }
        else {print("file no found")}
        
    } catch{
        print(error)
        }
        
        
}
    
  
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        currentOrder = (currentOrder+1) % musicList.count
        setPlayer()
        musicSlider.value = 0
        play()
    }
    
    @IBAction func lastButton(_ sender: UIButton) {
        currentOrder = (currentOrder-1+musicList.count) % musicList.count
        setPlayer()
        musicSlider.value = 0
        play()
    }
    
    
    
    
    
    
}


