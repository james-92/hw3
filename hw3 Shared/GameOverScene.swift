//
//  GameOverScene.swift
//  hw3 iOS
//
//  Created by James.Lai on 20/11/2024.
//

import SpriteKit


class GameOverScene: SKScene{
    
    let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size//讓背景大小等於當前銀幕大小
        background.position = CGPoint(x: self.size.width/2,y: self.size.height/2)//讓背景至中
        background.zPosition = 0//背景在最下面
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 70
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()//UserDefaults能在本地端儲存用戶資料直到刪除遊戲
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")//存目前玩過最高的分數
        
        if gameScore > highScoreNumber{
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")//存入本地端
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLabel.text = "Highest Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 40
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.45)
        self.addChild(highScoreLabel)
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 50
        restartLabel.fontColor = SKColor.white
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.3)
        self.addChild(restartLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {//若觸碰到restartLabel範圍就執行頁面變換並restart
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if restartLabel.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)//確保新場景與當前場景的大小一致
                sceneToMoveTo.scaleMode = self.scaleMode//確保新場景與當前場景的顯示方式一致
                let myTransition = SKTransition.fade(withDuration: 0.5)//切換頁面的時候會變暗
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)//切換場景
            }
        }
    }
}
