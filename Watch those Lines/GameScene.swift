//
//  GameScene.swift
//  Rain
//
//  Created by RaghuKV on 2/24/15.
//  Copyright (c) 2015 RaghuKV. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreManager = ScoreManager()
    
    // less value higher frequency
    var dropGenerationInterval : Double = 1.0
    
    var horizontalDropInterval: Double = 5.0
    
    var diamondLifeSpan : Double = 1.5
    
    // less value higher frequency
    var dropSpeed : Double = 6.0
    
    var totalElapsedTime : CFTimeInterval = 0
    
    var gameEnded : Bool = false;
    
    var gameBegan : Bool = false;
    
    var disableTryAgain : Bool = false;
    
    var waterLevelDangerous : Bool = false;
    
    var instructionsDone : Bool = false;
    
    var mainCategory : UInt32 = 0x1 << 0
    var dropCategory: UInt32 = 0x1 << 1
    var boundaryCategory: UInt32 = 0x1 << 2
    var collectibleCategory: UInt32 = 0x1 << 3
    var waterCategory: UInt32 = 0x1 << 4
    
    var controlCircle = SKSpriteNode();
    
    var instructionText = SKSpriteNode();
    
    var finger = SKSpriteNode();
    
    var water = SKShapeNode()
    
    var gameUtils = GameUtils()

    var lastUpdateTimeInterval: CFTimeInterval = 0;
    var lastSpawnTimeInterval: CFTimeInterval = 0;

    var gameLoop : SKAction = SKAction()
    
    var scoreLabel: SKLabelNode = SKLabelNode(text: "0")
    
    var countDown : SKLabelNode = SKLabelNode()
    
    var score = 0
    
    var menuButton = SKSpriteNode()
    
    var tryAgainLabel = SKSpriteNode()
    
    var dropFadeIn = SKAction.fadeAlphaTo(0.9, duration: 0.7)

    override func didMoveToView(view: SKView) {

        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0.0)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.categoryBitMask = boundaryCategory
        
        showInstructions()
    }
    
    func tryAgain() -> Void {
        
        setUpControlObject()
        
        resetAndBeginGame()
    }
    
    func resetAndBeginGame(){
        
        self.disableTryAgain = true;
        
        self.score = 0
        
        self.totalElapsedTime = CFTimeInterval(0)
        
        dropGenerationInterval = 1.0
        
        diamondLifeSpan = 1.5
        
        dropSpeed = 4.0
        
        gameEnded = false;
        
        setUpWater()
        
        initiateRain()
        
        setUpLabel()
        
    }
    
    func setUpLabel() -> Void {

        var x = CGRectGetMidX(self.frame)
        var y = self.frame.height - 25
        
        var list = self.children
        var labelFound = false
        for item in list {
            if(item.name? == "scoreLabel"){
                labelFound = true
                var theItem = item as SKLabelNode
                theItem.runAction(SKAction.fadeAlphaTo(0.2, duration: 1))
                theItem.runAction(SKAction.moveTo(CGPointMake(x, y), duration: 1))
                theItem.text = "0"
            }
        }
        if !labelFound {
            self.scoreLabel = SKLabelNode(fontNamed: "Heiti TC Light")
            
            scoreLabel.text = String(format: "%d", self.score)
            scoreLabel.name = "scoreLabel"
            scoreLabel.fontColor = UIColor(red: 60/255, green: 96/255, blue: 127/255, alpha: 1.0)
            scoreLabel.fontSize = 26
            scoreLabel.alpha = 0.2
            
            
            scoreLabel.position = CGPointMake(x, y)
            self.addChild(scoreLabel)
        }
    }
    
    func initiateRain() -> Void {
        if(!instructionsDone){
            instructionsDone = true
            showAvoidInstruction()
        }
        var wait = SKAction.waitForDuration(2)
        var start = SKAction.runBlock({
            self.mainLoop(self.dropGenerationInterval)
            self.gameBegan = true
        })
        var waitAndStart = SKAction.sequence([wait, start])
        self.runAction(waitAndStart)
    }
    
    func showAvoidInstruction() -> Void {
        var avoid = SKSpriteNode(imageNamed: "avoidInstruction")
        avoid.name = "avoid"
        avoid.position = CGPointMake(CGRectGetMidX(self.scene!.frame), CGRectGetMidY(self.scene!.frame) + 150)
        avoid.alpha = 0.0
        self.addChild(avoid)
        var fadeIn = SKAction.fadeInWithDuration(0.5)
        var wait = SKAction.waitForDuration(2)
        var fadeOut = SKAction.runBlock({
            self.gameUtils.fadeOutAndKill(avoid)
        })
        avoid.runAction(SKAction.sequence([fadeIn, wait, fadeOut]))
    }
    
    func setUpControlObject() -> Void {

        self.controlCircle = gameUtils.drawControlObject()
        controlCircle.position = CGPointMake(CGRectGetMidX(self.scene!.frame), CGRectGetMidY(self.scene!.frame
            ))
        self.addChild(controlCircle)
        
        gameUtils.fadeIn(controlCircle, duration: 0.7)
        controlCircle.physicsBody?.allowsRotation = false
        controlCircle.physicsBody?.dynamic = true
        controlCircle.physicsBody?.affectedByGravity = false
        controlCircle.physicsBody?.categoryBitMask = mainCategory
        controlCircle.physicsBody?.contactTestBitMask = dropCategory | waterCategory
        controlCircle.physicsBody?.collisionBitMask = dropCategory | waterCategory
        
        controlCircle.name = "controlObj"

    }
    
    func showInstructions() -> Void {
        self.instructionText = gameUtils.drawInstructions()
        self.instructionText.name = "instructions"
        self.instructionText.position = CGPointMake(self.frame.midX, self.frame.midY + 150)
        self.addChild(instructionText)
        var fadeIn = SKAction.fadeInWithDuration(0.7)
        instructionText.runAction(fadeIn)
        
        setUpControlObject()
        
        self.finger = gameUtils.drawFinger()
        self.finger.name = "finger"
        self.finger.position = CGPointMake(CGRectGetMidX(self.scene!.frame), CGRectGetMidY(self.scene!.frame) - 150)
        self.addChild(finger)

        var left = SKAction.moveByX(-100, y: 0, duration: 0.5)
        var right = SKAction.moveByX(+200, y: 0, duration: 1)
        self.finger.runAction(fadeIn)
        self.finger.runAction(SKAction.repeatActionForever(SKAction.sequence([left,right,left])))
        
    }
    
    func removeInstructions() -> Void {
        gameUtils.fadeOutAndKillWithDuration(self.instructionText, duration: 0.2)
        gameUtils.fadeOutAndKillWithDuration(self.finger, duration: 0.2)
        resetAndBeginGame()
    }
    
    func spawnDiamond(lifeSpan: Double) -> Void {
        var diamond = gameUtils.createDiamond()
        
        diamond.physicsBody?.categoryBitMask = collectibleCategory
        diamond.physicsBody?.contactTestBitMask = mainCategory
        diamond.physicsBody?.collisionBitMask = mainCategory
        
        var minX = self.frame.origin.x + 20
        var maxX = self.frame.width - 20
        var xValue = CGFloat(arc4random_uniform(UInt32(maxX - minX + 1)))
        
        var waterUpperPosition = water.position.y + (water.frame.height/2)
        
        var maxY = Int(self.frame.height - 100)
        var minY = Int(waterUpperPosition + 200)

        var yValue : CGFloat!
        if maxY > minY{
            yValue = CGFloat(gameUtils.randRange(minY, upper: maxY))
        } else if minY > maxY{
            yValue = CGFloat(gameUtils.randRange(maxY, upper: minY))
        }
        
        diamond.position = CGPointMake(xValue, yValue)
        
        self.addChild(diamond)

        var fadeIn = SKAction.fadeInWithDuration(0.25)
        var wait = SKAction.waitForDuration(lifeSpan)
        var fadeOut = SKAction.fadeOutWithDuration(0.25)
        var kill = SKAction.runBlock({
            diamond.removeFromParent()
        })
        
        var seq = SKAction.sequence([fadeIn, wait, fadeOut, kill])
        
        diamond.runAction(seq)

    }
    
    func setUpWater()-> Void {
        var size: CGSize = CGSizeMake(self.frame.size.width + 10, self.frame.size.height)
        self.water = gameUtils.drawWaterLevel(size)
        self.water.position = CGPointMake(self.frame.midX, self.frame.midY - self.frame.height)
        self.addChild(water)
        var waterBody = SKPhysicsBody(rectangleOfSize: size)
        waterBody.dynamic = false
        water.physicsBody = waterBody
        water.physicsBody?.categoryBitMask = waterCategory
        water.physicsBody?.contactTestBitMask = dropCategory | mainCategory
        water.physicsBody?.collisionBitMask = dropCategory | mainCategory
        water.name = "Water"
    }
    
    func moveWaterUp() -> Void {
        var wait2 = SKAction.waitForDuration(2)
        var moveWaterLevelUp = SKAction.moveTo(CGPointMake(CGRectGetMidX(self.frame), self.frame.height/2), duration: 20)
        
        var waitAndMoveUp = SKAction.sequence([wait2, moveWaterLevelUp])
        self.water.runAction(waitAndMoveUp, withKey: "moveWaterUp");

    }
    
    func horizontalRainDrops(direction: Int) -> Void{
        
        var waterUpperPosition = water.position.y + (water.frame.height/2)
        
        var maxY = Int(self.frame.height - 100)
        var minY = Int(waterUpperPosition + 200)
        
        var yValue : CGFloat!
        if maxY > minY{
            yValue = CGFloat(gameUtils.randRange(minY, upper: maxY))
        } else if minY > maxY{
            yValue = CGFloat(gameUtils.randRange(maxY, upper: minY))
        }
        
        var drop = gameUtils.createDrop()
        drop.alpha = 0.0
        
        var fromX : CGFloat = 0.0
        var toX : CGFloat = 0.0
        
        if(direction == 1){
            fromX = CGRectGetMidX(self.frame) + ((self.frame.width / 2) + 10)
            toX = CGRectGetMidX(self.frame) - ((self.frame.width / 2))
        }else if(direction == 2){
            fromX = CGRectGetMidX(self.frame) - ((self.frame.width / 2) - 10)
            toX = CGRectGetMidX(self.frame) + ((self.frame.width / 2))
        }
        
        drop.position = CGPointMake(fromX, yValue)
        self.addChild(drop)
        drop.physicsBody?.affectedByGravity = false
        drop.physicsBody?.categoryBitMask = dropCategory
        drop.physicsBody?.contactTestBitMask = mainCategory | waterCategory
        drop.physicsBody?.collisionBitMask = mainCategory | waterCategory
        drop.name = "Drop"
        
        var passThrough = SKAction.moveTo(CGPointMake(toX, yValue), duration: dropSpeed - 1.0)
        var dropFadeIN = SKAction.fadeAlphaTo(0.7, duration: (dropSpeed-1)/2)
        var dropFadeOut = SKAction.fadeAlphaTo(0.0, duration: (dropSpeed-1)/2)
        var fadeInFadeOut = SKAction.sequence([dropFadeIN, dropFadeOut])
        var passWithFadeInFadeOut = SKAction.group([passThrough, fadeInFadeOut])

        var kill = SKAction.runBlock({
            drop.removeFromParent()
        })
        
        var hintLine = gameUtils.drawHorizontalHintLine(self.frame.width)
        hintLine.position = CGPointMake(CGRectGetMidX(self.frame), yValue)
        self.addChild(hintLine)
        var inHint = SKAction.fadeAlphaTo(0.3, duration: 0.5)
        var outHint = SKAction.fadeOutWithDuration(0.5)
        var killHint = SKAction.runBlock({
            hintLine.removeFromParent()
        })
        var wait = SKAction.waitForDuration(0.5)
        var hintAction = SKAction.runBlock({
            hintLine.runAction(SKAction.sequence([inHint, outHint, killHint]), withKey: "hintFlash")
        })
        
        var animation = SKAction.sequence([passWithFadeInFadeOut, kill])
        var dropAction = SKAction.runBlock({drop.runAction(animation, withKey: "dropFall")})
        
        self.runAction(hintAction, completion: { () -> Void in
            self.runAction(dropAction)
        })
    }
    
    func randomRainDrops() -> Void{
        
        var min = self.frame.minX + 30
        var max = self.frame.maxX - 20
        var xValue = Int(arc4random_uniform(UInt32(max - min + 1)))
        
        /* Set up Drop and assign actions */
        var drop = gameUtils.createDrop()
        drop.position = CGPointMake(CGFloat(xValue), self.frame.maxY)
        self.addChild(drop)
        drop.physicsBody?.categoryBitMask = dropCategory
        drop.physicsBody?.contactTestBitMask = mainCategory | waterCategory
        drop.physicsBody?.collisionBitMask = mainCategory | waterCategory
        drop.name = "Drop"
        var fall = SKAction.moveTo(CGPointMake(drop.position.x, -self.frame.height), duration: dropSpeed)
        var fallWithFade = SKAction.group([dropFadeIn, fall])
        var kill = SKAction.runBlock({
            drop.removeFromParent()
        })
        
        /** Set up Hint Line and assign actions */
        var hintLine = gameUtils.drawHintLine(self.frame.height)
        hintLine.position = CGPointMake(drop.position.x, CGRectGetMidY(self.frame))
        self.addChild(hintLine)
        var inHint = SKAction.fadeAlphaTo(0.3, duration: 0.25)
        var outHint = SKAction.fadeOutWithDuration(0.25)
        var killHint = SKAction.runBlock({
            hintLine.removeFromParent()
        })
        var wait = SKAction.waitForDuration(0.25)
        var hintAction = SKAction.runBlock({
            hintLine.runAction(SKAction.sequence([inHint, outHint, killHint]), withKey: "hintFlash")
        })
        
        /* Run Hint Line Flash. On completion run Drop action*/
        var animation = SKAction.sequence([wait, fallWithFade, kill])
        var dropAction = SKAction.runBlock({drop.runAction(animation, withKey: "dropFall")})
        
        self.runAction(hintAction, completion: { () -> Void in
            self.runAction(dropAction)
        })
    }
    
    /*  This method is called with updated difficulty parameters.
        Waiting period between drops is an action. Generating Drops is another action.
        Both are put in a sequence and run forever until game ends.
    */
    func mainLoop(interval: Double) -> Void{
        
        // Remove previous action
        self.removeActionForKey("gameLoop")
        
        // Waiting period between each drop
        var wait = SKAction.waitForDuration(self.dropGenerationInterval)
        
        
        var drop = SKAction.runBlock({
            self.randomRainDrops()
        })
        gameLoop = SKAction.repeatActionForever(SKAction.sequence([wait, drop]))
        
        //run with action identifier key. This key is used to cancel the action and 
        // re-run with updated difficulty parameters
        self.runAction(gameLoop, withKey: "gameLoop")
    }

    func didBeginContact(contact: SKPhysicsContact) -> Void{

        var firstBody : SKNode = contact.bodyA.node!
        var secondBody : SKNode = contact.bodyB.node!
        
        // wait for a slight second and then run the end game methods
        // the 0.5 lag is introduced to ensure smooth collision
        if(endGameCondition(firstBody, secondBody: secondBody))
        {
            gameEnded = true
            firstBody.removeAllActions()
            secondBody.removeAllActions()
            self.removeActionForKey("gameLoop")
            self.removeActionForKey("moveWaterUp")
            self.flashWithDuration(0.1, node: firstBody)
            self.flashWithDuration(0.1, node: secondBody)
            var wait = SKAction.waitForDuration(0.5)
            self.runAction(wait, completion: {Void in
                    self.endTheGame()
            })
        }
        
        else if (collectibleCondition(firstBody, secondBody: secondBody))
        {
            if(firstBody.physicsBody?.categoryBitMask == collectibleCategory){
                firstBody.removeFromParent()
            }else if (secondBody.physicsBody?.categoryBitMask == collectibleCategory){
                secondBody.removeFromParent()
            }
            
            //remove water movement action
            //push back the water a bit
            //re-run the water movement action
            
            gameUtils.flash(self.water)
            water.removeActionForKey("moveWaterUp")
            var moveWaterDown = SKAction.moveByX(0, y: -60, duration: 2)
            water.runAction(moveWaterDown, withKey: "moveDown")
            moveWaterUp()
        }
        else if(sinkCondition(firstBody, secondBody: secondBody)){
            
            if(firstBody.physicsBody?.categoryBitMask == dropCategory){
                firstBody.removeFromParent()
            }else if (secondBody.physicsBody?.categoryBitMask == dropCategory){
                secondBody.removeFromParent()
            }
        }
    }
    
    func flashWithDuration(duration: NSTimeInterval, node: SKNode){
        var fadeOut = SKAction.fadeOutWithDuration(duration)
        var fadeIn = SKAction.fadeInWithDuration(duration)
        node.runAction(SKAction.sequence([fadeOut, fadeIn, fadeOut, fadeIn]))
    }
    
    /*
    This method is called when the end game condition is met.
    Removes all nodes except the score label.
    Score label is moved down and buttons are generated.
    Score is saved.
*/
    func endTheGame(){
        self.gameEnded = true
        self.gameBegan = false
        self.removeActionForKey("gameLoop");
        self.removeActionForKey("moveWaterUp");
        
        var childList = self.children
        var length = childList.count
        for(var i = 0; i < length; i++){
            var child : SKNode = childList[i] as SKNode
            
            if(child.name == "scoreLabel"){
               continue
            }
            child.removeAllActions()
            gameUtils.fadeOutAndKill(child)
        }
        
        self.scoreLabel.runAction(SKAction.fadeAlphaTo(1, duration: 1.0))
        self.scoreLabel.runAction(SKAction.moveToY(CGRectGetMidY(self.frame)-100, duration: 1.0))

        tryAgainLabel = gameUtils.drawTryAgain()
        tryAgainLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-200)
        self.addChild(tryAgainLabel)
        var fadeInLabel = SKAction.fadeInWithDuration(1.0)
        tryAgainLabel.runAction(fadeInLabel, completion: { () -> Void in
                  self.disableTryAgain = false;
        })
        self.menuButton = gameUtils.drawMenuButton()
        menuButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-250)
        self.addChild(menuButton)
        menuButton.runAction(fadeInLabel)
        
        scoreManager.addNewScore(self.score)
        scoreManager.save()
    }

    func fadeAndKillNode(drop: SKNode) -> Void {
         gameUtils.fadeOutAndKill(drop)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
    {
        if gameEnded {
         return
        }
        
        //Get touch coordinates in location view
        var touch : UITouch = touches.anyObject() as UITouch
        var currentTouch : CGPoint = touch.locationInNode(self)
        var previousTouch : CGPoint = touch.previousLocationInNode(self)
        var circlePosition = controlCircle.position
        var difference = CGPointMake(currentTouch.x - previousTouch.x, currentTouch.y - previousTouch.y)
        var newX = circlePosition.x + difference.x;
        var newY = circlePosition.y + difference.y;
        var newPos = CGPointMake(newX, newY);
        var checkPos = CGPointMake(newX - controlCircle.frame.width/2, newY)
        var checkPosTwo = CGPointMake(newX + controlCircle.frame.width/2, newY)
        
        if(self.frame.contains(checkPos) && self.frame.contains(checkPosTwo)){
//        if(self.frame.contains(newPos)){
            controlCircle.position = newPos
        }else{
            controlCircle.position.y = newPos.y
        }
        
        if(!instructionsDone){
            removeInstructions()
        }
    }
    
    override func touchesBegan (touches: NSSet, withEvent event: UIEvent)
    {
        //Get touch coordinates in location view
        var touch : UITouch = touches.anyObject() as UITouch
        var touchPoint : CGPoint = touch.locationInNode(self)
        var node = self.nodeAtPoint(touchPoint) as SKNode
        var nodeName = node.name
        var tryAgain = "tryAgain"
        var menu = "menu"
        if(nodeName == tryAgain && !disableTryAgain){
            
            gameUtils.fadeOutAndKill(node)
            gameUtils.fadeOutAndKill(self.menuButton)
            self.tryAgain()
        }
        else if (nodeName == menu){
            
            var scene = MenuScene()
            var trans = SKTransition.doorsCloseVerticalWithDuration(0.5)
            var skView = self.view as SKView!
            scene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
            scene.size = skView.bounds.size
            scene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view!.presentScene(scene, transition: trans)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        /* Called before each frame is rendered */
        // If we drop below 60fps, we still want everything to move the same distance.
        
        if gameEnded {
            return
        }
        
        var timeSinceLast : CFTimeInterval = currentTime - self.lastUpdateTimeInterval;
        
        self.lastUpdateTimeInterval = currentTime;
        
        // more than a second since last update
        if (timeSinceLast > 1) {
            timeSinceLast = 1.0 / 60.0;
            self.lastUpdateTimeInterval = currentTime;
        }
        self.updateWithTimeSinceLastUpdate(timeSinceLast)
    }
    
    /*
    Game is updated every second.
    Updates score.
    Contains the whole difficulty logic and game simulation code.
    
    dropGenerationInterval - the time between each drop
    
    dropSpeed              - the speed with which the drop falls (really the duration of fall)
    
    waterLevelDangerous    - if water climbs more than 2/3rds of the screen, this becomes true
                             We spawn diamonds more frequently to help the player recoupe.
    
    */
    func updateWithTimeSinceLastUpdate(timeSinceLast: CFTimeInterval) -> Void{
        self.lastSpawnTimeInterval = self.lastSpawnTimeInterval + timeSinceLast;
        self.scoreLabel.text = String(format:"%d", self.score)
        
        if (self.lastSpawnTimeInterval > 1) {
            if(!instructionsDone || !gameBegan || gameEnded){
                return
            }
            
            self.lastSpawnTimeInterval = 0;
            self.totalElapsedTime += 1
            self.score += 1
            
            if((water.position.y + (water.frame.height/1.3)) > CGRectGetMidY(self.frame)){
                waterLevelDangerous = true;
            }else{
                waterLevelDangerous = false;
            }
            
            /*
            Until 140 seconds, the frequency of drops increases every 7 seconds
            */
            if(self.score > 1 && self.score <= 140 && self.score % 7 == 0){
                // every 7 seconds for 20 times
                self.dropGenerationInterval -= 0.030
                //action called with new frequency value
                mainLoop(self.dropGenerationInterval)
            }
            
            /*
            After 20 seconds, horizontal drops are generated every 3 and 5 seconds
            After 120 seconds, they are generated every 1 and 2 seconds.
            The method parameter for horizontalRainDrops is the direction (from left or right)
            */
            if(self.score > 20 && self.score < 120 && self.score % 3 == 0){
                horizontalRainDrops(1)
            }
            if(self.score > 21 && self.score < 120 && self.score % 5 == 0){
                horizontalRainDrops(2)
            }
            
            if(self.score > 120 && self.score % 1 == 0){
                horizontalRainDrops(1)
            }
            
            if(self.score > 120 && self.score % 2 == 0){
                horizontalRainDrops(2)
            }
            
            if(self.score > 1 && self.score <= 64 && self.score % 8 == 0){
                self.dropSpeed -= 0.150
            }
            
            
            /*
            After 60 seconds, the lifespan of the diamond decreases.
            Further decreases after 120 seconds.
            */
            if(score == 60){
                self.diamondLifeSpan -= 0.3
            }
            if(score == 120){
                self.diamondLifeSpan -= 0.3
            }
            
            /*
            Begin movement of water after 14 seconds
            */
            if(self.score == 14){
                moveWaterUp()
            }
            
            
            /*
            If waterLevelDangerous, spawn more diamonds, else remain same
*/
            if(waterLevelDangerous && self.score > 14 && self.score % 2 == 0){
                spawnDiamond(self.diamondLifeSpan)
            }
            
            if(self.score > 14 && self.score % 5 == 0 && !waterLevelDangerous){
                spawnDiamond(self.diamondLifeSpan)
            }
        }
    }
    
    func endGameCondition(firstBody: SKNode, secondBody: SKNode) -> Bool{
        if(firstBody.physicsBody!.categoryBitMask == mainCategory && secondBody.physicsBody?.categoryBitMask == dropCategory ||
            firstBody.physicsBody?.categoryBitMask == dropCategory && secondBody.physicsBody?.categoryBitMask == mainCategory){
                return true;
        }
        
        if(firstBody.physicsBody!.categoryBitMask == mainCategory && secondBody.physicsBody?.categoryBitMask == waterCategory ||
            firstBody.physicsBody?.categoryBitMask == waterCategory && secondBody.physicsBody?.categoryBitMask == mainCategory){
                return true;
        }
        return false
    }
    
    func collectibleCondition(firstBody: SKNode, secondBody: SKNode) -> Bool{
        if(firstBody.physicsBody!.categoryBitMask == mainCategory && secondBody.physicsBody?.categoryBitMask == collectibleCategory ||
            firstBody.physicsBody?.categoryBitMask == collectibleCategory && secondBody.physicsBody?.categoryBitMask == mainCategory){
                return true
        }
        return false
    }
    
    func sinkCondition(firstBody:SKNode, secondBody: SKNode) -> Bool{
        if(firstBody.physicsBody!.categoryBitMask == dropCategory && secondBody.physicsBody?.categoryBitMask == waterCategory ||
            firstBody.physicsBody?.categoryBitMask == waterCategory && secondBody.physicsBody?.categoryBitMask == dropCategory){
                return true;
        }
        
        return false;
    }
}
