//
//  GameScene.swift
//  hw3 Shared
//
//  Created by James.Lai on 18/11/2024.
//

import SpriteKit
import SwiftUI

var gameScore = 0//定義到GameScene以外讓GameOverScene也能存取

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    static func newGameScene() -> GameScene {
        // 取得螢幕尺寸
        let screenSize = UIScreen.main.bounds.size
        // 建立 GameScene 並設置為螢幕大小
        let scene = GameScene(size: screenSize)
        return scene
    }
    
        
    //******************************************全域變數************************************//
    
    
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")//用來顯示分數文字區塊
    
    var livesNumber = 3
    let livesLabel = SKLabelNode(fontNamed: "The Bold Font")//用來顯示生命值文字區塊
    
    var levelNumber = 0
    
    let player = SKSpriteNode(imageNamed: "playerShip")
    let bulletSound = SKAction.playSoundFileNamed("bulletsound.wav", waitForCompletion: false)//定義子彈射出聲音的動作，false可以讓子彈射出聲音不用跑完就繼續做下一動作 > move
    let explosionSound = SKAction.playSoundFileNamed("explosionsound.wav", waitForCompletion: false)
    
    enum gameState{//定義一種型別叫gameState，裡面有三種狀態
        case preGame//遊戲開始前的狀態
        case inGame//遊戲中的狀態
        case afterGame//遊戲結束後的狀態
    }
    
    var currentGameState = gameState.inGame//一開始就是遊戲中狀態
    
    struct PhysicsCatagories{//物理實體的分類
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1  //1
        static let Bullet : UInt32 = 0b10 //2
        static let Enemy : UInt32 = 0b100 //4
    }
    
    func random() -> CGFloat{//生成0~1之間的亂數
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    func random(min min:CGFloat, max: CGFloat) -> CGFloat{//生成隨機x軸位置
        return random()*(max-min) + min
    }
    
    
    //******************************************全域變數************************************//
    
    
    var gameArea: CGRect
    override init(size:CGSize){
        let maxAspectRatio: CGFloat = 16.0/9.0//定義可接受的長寬比等於手機
        let playableWidth = size.height / maxAspectRatio//計算出當前裝置可玩的寬
        let margin = (size.width - playableWidth)*0.1//size指當前銀幕的尺寸。計算出左右邊緣
        gameArea = CGRect(x:margin, y: 0, width: size.width-margin*2, height:size.height)//定義gameArea的尺寸**width應該要是playablewidth但先暫定為size.width-margin*2不然右邊跑不到
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {//init(size:)初始化要用
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {//一開始就會呼叫的函數
        gameScore = 0//每一次進來遊戲都要讓分數歸零因為gameScore現在定義在GameScene外，只會定義一次
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size//讓背景大小等於當前銀幕大小
        background.position = CGPoint(x: self.size.width/2,y: self.size.height/2)//讓背景至中
        background.zPosition = 0//背景在最下面
        self.addChild(background)
        player.setScale(0.3)//設定飛船大小
        player.position = CGPoint(x: self.size.width/2,y: self.size.height/5)//讓玩家一開始在下方至中
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)//定義玩家的物理實體
        player.physicsBody!.affectedByGravity = false//取消重力
        player.physicsBody!.categoryBitMask = PhysicsCatagories.Player//將物理實體加入category
        player.physicsBody!.collisionBitMask = PhysicsCatagories.None//collision(物理碰撞)會彈開
        player.physicsBody!.contactTestBitMask = PhysicsCatagories.Enemy
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left//使label靠左並向右拓展
        scoreLabel.position = CGPoint(x: self.size.width*0.07, y: self.size.height*0.85)//label座標
        scoreLabel.zPosition = 100//確保在最上面
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 30
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right//使label靠右並向左拓展
        livesLabel.position = CGPoint(x: self.size.width*0.93, y: self.size.height*0.85)//label座標
        livesLabel.zPosition = 100//確保在最上面
        self.addChild(livesLabel)

        
        startNewLevel()//讓一開始遊戲就執行
        
    }
    
    
    func loseALife(){
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"//更新live
        let scaleUP = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUP,scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber == 0{//若生命值＝0就gameover
            runGameOver()
        }
    }
    
    func addScore(){
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"//更新score
        
        if gameScore == 3 || gameScore == 5 || gameScore == 7{//四種level設置3種門檻值
            startNewLevel()
        }
    }
    
    func runGameOver(){
        currentGameState = gameState.afterGame
        self.removeAllActions()//取消亂數生成，讓敵人不再生成
        self.enumerateChildNodes(withName: "Bullet"){ (bullet, stop)in//先前有讓bullet有另一別名"Bullet"，這邊透過enumerate的方式遍歷場景中的所有叫做"Bullet"的節點，並讓他們停止動作
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy"){ (enemy, stop)in//先前有讓enemy有另一別名"Enemy"，這邊透過enumerate的方式遍歷場景中的所有叫做"Enemy"的節點，並讓他們停止動作
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene,changeSceneAction])//所有物件都靜止後等一秒後開始切換場景
        self.run(changeSceneSequence)
    }
    
    func changeScene(){
        let sceneToMoveTo = GameOverScene(size: self.size)//確保新場景與當前場景的大小一致
        sceneToMoveTo.scaleMode = self.scaleMode//確保新場景與當前場景的顯示方式一致
        let myTransition = SKTransition.fade(withDuration: 0.5)//切換頁面的時候會變暗
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)//切換場景
    }
    
    func didBegin(_ contact: SKPhysicsContact) {//當兩物件接觸就會觸發，兩物件在contact中會被設為bodyA,bodyB
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{//確保body1永遠是子彈或玩家，body2永遠是敵人
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCatagories.Player && body2.categoryBitMask == PhysicsCatagories.Enemy{//玩家和敵人接觸
            if body1.node != nil{//確保真的有node
                spawnExplosion(spawnPosition: body1.node!.position)//player位置產生爆炸
            }
            if body2.node != nil{
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            
            body1.node?.removeFromParent()//“？”若有找到body1的實體>刪除==刪除player
            body2.node?.removeFromParent()//“？”若有找到body2的實體>刪除==刪除enemy
            
            runGameOver()//若玩家和敵人接觸到就gameover
        }
        
        if body1.categoryBitMask == PhysicsCatagories.Bullet && body2.categoryBitMask == PhysicsCatagories.Enemy && body2.node?.position.y ?? self.size.height + 1 < self.size.height{//子彈和敵人接觸(確保敵人在畫面中)
            addScore()//射到敵人就加一分
            if body2.node != nil{
                spawnExplosion(spawnPosition: body2.node!.position)//enemy位置產生爆炸
            }
            
            
            body1.node?.removeFromParent()//“？”若有找到body1的實體>刪除==刪除bullet
            body2.node?.removeFromParent()//“？”若有找到body2的實體>刪除==刪除enemy
        }
    }
    
    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3//在最上方
        explosion.setScale(0)//圖片一開始超小
        self.addChild(explosion)
        let scaleIn = SKAction.scale(to: 0.5, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([explosionSound,scaleIn,fadeOut,delete])
        
        explosion.run(explosionSequence)
    }
    
    func startNewLevel(){
        
        levelNumber += 1
        if self.action(forKey: "spawningEnemies") != nil{//確認spawingEnemies動作正在執行
            self.removeAction(forKey: "spawingEnemies")//刪除key以達到暫停生成敵人
        }
        
        var levelDuration = TimeInterval()
        switch levelNumber{//設定每個關卡敵人的生成間隔速度，越小敵人生成越快
        case 1: levelDuration = 3
        case 2: levelDuration = 2
        case 3: levelDuration = 1
        case 4: levelDuration = 0.5
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
        
        let spawn = SKAction.run(spawnEnemy)//執行敵人生成
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)//生成間隔時間
        let spawnSequence = SKAction.sequence([waitToSpawn,spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)//循環生成、等待
        self.run(spawnForever,withKey: "spawningEnemies")
    }
    
    
    func fireBullet(){
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(0.3)
        bullet.position = player.position
        bullet.zPosition = 1//子彈射出在背景上方且在玩家下方
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)//定義子彈的物理實體
        bullet.physicsBody!.affectedByGravity = false//取消重力
        bullet.physicsBody!.categoryBitMask = PhysicsCatagories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCatagories.None//collision(物理碰撞)會彈開
        bullet.physicsBody!.contactTestBitMask = PhysicsCatagories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height , duration:1)//定義子彈射出的動作：射出時間和在最上面消失
        let deleteBullet = SKAction.removeFromParent()//定義刪除子彈動作，Parent指的是目前的場景：GameScene
        let bulletSequence = SKAction.sequence([bulletSound,moveBullet,deleteBullet])//將2動作串聯
        bullet.run(bulletSequence)//執行動作
    }
    
    
    func spawnEnemy(){
        let randomXStart = random(min: CGRectGetMinX(gameArea),max: CGRectGetMaxX(gameArea))//使用上面的random函數生成敵人起始x
        let randomXEnd = random(min: CGRectGetMinX(gameArea),max: CGRectGetMaxX(gameArea))//使用上面的random函數生成敵人終止x
        let startPoint = CGPoint(x: randomXStart, y:self.size.height*1.2)//敵人起始座標(從螢幕外進來)
        let endPoint = CGPoint(x: randomXEnd, y:-self.size.height*0.2)//敵人終止座標(-self.size.height*0.2避免敵人完全消失)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.name = "Enemy"
        enemy.setScale(0.2)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)//定義敵人的物理實體
        enemy.physicsBody!.affectedByGravity = false//取消重力
        enemy.physicsBody!.categoryBitMask = PhysicsCatagories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCatagories.None//敵人與其他物體不發生物理碰撞
        enemy.physicsBody!.contactTestBitMask = PhysicsCatagories.Player | PhysicsCatagories.Bullet//敵人和子彈、玩家接觸到的時候會觸發檢測
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 4)//duration可以控制敵人飛行時間
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence  = SKAction.sequence([moveEnemy,deleteEnemy,loseALifeAction])//若沒有成功打到敵人，敵人跑出下方也會扣生命值
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence)
        }
        let dx = endPoint.x-startPoint.x
        let dy = endPoint.y-startPoint.y
        let amountToRotote = atan2(dy,dx)
        enemy.zRotation = amountToRotote//讓敵人在移動時，能夠面向移動的方向
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {//執行fireBullet
        if currentGameState == gameState.inGame{
            fireBullet()
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){//當觸摸時就會產生一筆資料存入UITouch並透過for依序處理
        for touch: AnyObject in touches{
            let  pointOfTouch = touch.location(in: self)//求出目前觸摸到的x座標
            let  previousPointOfTouch = touch.previousLocation(in: self)//求出先前觸摸到的x座標
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x//計算偏移量
            if currentGameState == gameState.inGame{//若遊戲狀態是遊玩中
                player.position.x += amountDragged//更新玩家位置(移動)
            }
            if player.position.x > CGRectGetMaxX(gameArea){//若手指移動的量超出右邊界
                player.position.x = CGRectGetMaxX(gameArea)//擋住
            }
            if player.position.x < CGRectGetMinX(gameArea){//若手指移動的量超出左邊界
                player.position.x = CGRectGetMinX(gameArea)//擋住
            }
        }
    }
}
