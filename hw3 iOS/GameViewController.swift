//
//  GameViewController.swift
//  hw3 iOS
//
//  Created by James.Lai on 18/11/2024.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    var backingAudio = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let filePath = Bundle.main.path(forResource: "backingtrack", ofType: "mp3") {//設置背景音樂
            let audioURL = URL(fileURLWithPath: filePath)
            
            do {
                backingAudio = try AVAudioPlayer(contentsOf: audioURL)
                backingAudio.play() // 開始播放音樂
            } catch {
                print("Cannot Find The Audio: \(error.localizedDescription)")
            }
        } else {
            print("File not found.")
        }
        
        backingAudio.numberOfLoops = -1
        backingAudio.volume = 1
        
        
        // 確保視圖是 SKView 類型
        let skView = SKView(frame: self.view.frame)
        self.view = skView // 用 SKView 替換掉原本的 view
        
        // 嘗試建立並展示遊戲場景
        let scene = GameScene.newGameScene() // 確保這個方法返回有效的 SKScene

        // 顯示場景
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = false
        skView.showsNodeCount = false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

