//
//  GameUtils.swift
//  Rain
//
//  Created by RaghuKV on 2/24/15.
//  Copyright (c) 2015 RaghuKV. All rights reserved.
//


import Foundation
import spritekit


class GameUtils {
    
//  let redColor = SKColor(red: 134/255, green: 61/255, blue: 61/255, alpha: 1.0)
    let darkColor = SKColor(red: 63/255, green: 55/255, blue: 43/255, alpha: 1.0)
    
    let blueColor = SKColor(red: 60/255, green: 96/255, blue: 127/255, alpha: 1.0)
    
    class func getDarkColor () -> SKColor {
        return SKColor(red: 63/255, green: 55/255, blue: 43/255, alpha: 1.0)
    }
    
    class func getBlueColor () -> SKColor {
        return SKColor(red: 60/255, green: 96/255, blue: 127/255, alpha: 1.0)
    }
    
    func createDrop() -> SKSpriteNode{
        var min = 9
        var max = 16
        var rand = UInt32(max - min)
        var radius : CGFloat = CGFloat(arc4random_uniform(rand))
        radius += CGFloat(min)
        var drop = SKSpriteNode()
        drop.color = UIColor.clearColor()
        drop.size = CGSizeMake(radius * 2, radius * 2)
        var dropBody = SKPhysicsBody(circleOfRadius: radius)
        drop.physicsBody = dropBody
        var dropPath = CGPathCreateWithEllipseInRect(CGRectMake((-drop.size.width/2), -drop.size.height/2, drop.size.width, drop.size.width),
            nil)
        var dropShape = SKShapeNode()
        dropShape.fillColor = darkColor
        dropShape.lineWidth = 0
        drop.name = "dropMask"
        dropShape.path = dropPath
        drop.addChild(dropShape)
        drop.alpha = 0.0
        return drop
    }
    
    func createCross(size: CGFloat) -> SKSpriteNode {
        var min = size/38008
        var max = size/16928
        var rand = UInt32(max - min)
        var length : CGFloat = CGFloat(arc4random_uniform(rand))
        length += CGFloat(min)
        length = length * 2.5
        
        var cross = SKSpriteNode()
        
        var lineOne = SKShapeNode(rectOfSize: CGSizeMake(length, 4))
        lineOne.fillColor = self.darkColor
        lineOne.strokeColor = self.darkColor
        lineOne.lineWidth = 0
        
        
        var lineTwo = SKShapeNode(rectOfSize: CGSizeMake(4, length))
        lineTwo.fillColor = self.darkColor
        lineTwo.strokeColor = self.darkColor
        lineTwo.lineWidth = 0
        
        cross.addChild(lineOne)
        cross.addChild(lineTwo)
        return cross
    }
    
    func createDropWithRadius(radius: CGFloat) -> SKSpriteNode{
        var drop = SKSpriteNode()
        drop.color = UIColor.clearColor()
        drop.size = CGSizeMake(radius * 2, radius * 2)
        var dropBody = SKPhysicsBody(circleOfRadius: radius)
        dropBody.dynamic = true
        dropBody.usesPreciseCollisionDetection = false
        drop.physicsBody = dropBody
        var dropPath = CGPathCreateWithEllipseInRect(CGRectMake((-drop.size.width/2), -drop.size.height/2, drop.size.width, drop.size.width),
            nil)
        var dropShape = SKShapeNode()
        dropShape.fillColor = SKColor(red: 80, green: 0, blue: 0, alpha: 0)
        dropShape.lineWidth = 0
        drop.name = "dropMask"
        dropShape.path = dropPath
        drop.addChild(dropShape)
        drop.alpha = 0.0
        return drop
    }
    
    func drawTryAgain() -> SKSpriteNode{
        
        var tryAgain = SKSpriteNode()
        var tryText = SKLabelNode(fontNamed: "Heiti TC Light")
        tryAgain.name = "tryAgain"
        tryText.text = "try Again"
        tryText.name = "tryAgain"
        tryText.fontColor = self.darkColor
        tryText.fontSize = 30
        tryAgain.addChild(tryText)
        
        tryAgain.alpha = 0.0
        
        return tryAgain
    }
    
    func drawMenuButton() -> SKSpriteNode{
        
        var menu = SKSpriteNode()
        var menuText = SKLabelNode(fontNamed: "Heiti TC Light")
        menu.name = "menu"
        menuText.text = "menu"
        menuText.name = "menu"
        menuText.fontColor = self.darkColor
        menuText.fontSize = 30
        menu.addChild(menuText)
        
        menu.alpha = 0.0
        return menu
    }
    
    func drawOkay() -> SKLabelNode{
        

        var tryText = SKLabelNode(fontNamed: "Heiti TC Light")
        tryText.text = "okay!"
        tryText.name = "okay"
        tryText.fontColor = self.darkColor
        tryText.fontSize = 30
        tryText.alpha = 0.0
        
        return tryText

    }
    
    class func getLabelNodeWithText(text: String, name: String) -> SKLabelNode{
        var label = SKLabelNode(fontNamed: "Heiti TC Light")
        label.name = name
        label.text = text
        label.fontColor = getBlueColor()
        label.fontSize = 40
        
        label.alpha = 0.0
        
        return label

    }
    
    func drawThisIsYouText() -> SKSpriteNode{
        var thisIsYouNode = SKSpriteNode()
        var thisIsYouText = SKLabelNode(fontNamed: "Heiti TC Light")
        thisIsYouNode.name = "thisIsYou"
        thisIsYouText.text = "this is you"
        thisIsYouText.name = "thisIsYou"
        thisIsYouText.fontColor = self.darkColor
        thisIsYouText.fontSize = 30
        thisIsYouNode.addChild(thisIsYouText)
        
        thisIsYouNode.alpha = 0.0
        
        return thisIsYouNode

    }
    
    func drawHintLine(height: CGFloat) -> SKShapeNode{
        var line = SKShapeNode(rectOfSize: CGSizeMake(2, height))
        line.fillColor = self.darkColor
        line.strokeColor = self.darkColor
        line.lineWidth = 0
        line.alpha = 0.1
        return line
    }
    
    func drawHorizontalHintLine(width: CGFloat) -> SKShapeNode{
        var line = SKShapeNode(rectOfSize: CGSizeMake(width, 2))
        line.fillColor = self.darkColor
        line.strokeColor = self.darkColor
        line.lineWidth = 0
        line.alpha = 0.1
        return line
    }
    
    func drawWaterLevel(size: CGSize) -> SKShapeNode{
        var waterShape = SKShapeNode(rectOfSize: size)
        waterShape.fillColor = darkColor
        return waterShape
        
    }
    
    func drawInstructions() -> SKSpriteNode{
        var instructions = SKSpriteNode(imageNamed: "instructions")
        instructions.alpha = 0.0
        return instructions
    }
    
    func drawFinger() -> SKSpriteNode{
        var finger = SKSpriteNode(imageNamed: "finger")
        finger.alpha = 0.0
        return finger
    }
    
    func createFingerPath() -> UIBezierPath{
        var bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(168.5, 39.5))
        bezierPath.addCurveToPoint(CGPointMake(91.5, 82.5), controlPoint1: CGPointMake(89.5, 82.5), controlPoint2: CGPointMake(91.5, 82.5))
        bezierPath.addLineToPoint(CGPointMake(91.5, 39.5))
        bezierPath.addLineToPoint(CGPointMake(168.5, 82.5))
        bezierPath.addLineToPoint(CGPointMake(168.5, 39.5))
        bezierPath.closePath()
        bezierPath.lineWidth = 1
        bezierPath.stroke()
        return bezierPath
    }
    
    func drawControlObject() -> SKSpriteNode{
        var controlObject = SKSpriteNode(imageNamed: "Main.png")
        
        var body = SKPhysicsBody(texture: controlObject.texture, alphaThreshold: 0.1, size: controlObject.texture!.size())
        
        body.dynamic = false
        
        controlObject.physicsBody = body
        
        return controlObject
    }
    
    func drawHexControlObject() -> SKSpriteNode{
        var controlObject = SKSpriteNode(imageNamed: "polygon.png")
        
        var body = SKPhysicsBody(texture: controlObject.texture, alphaThreshold: 0.1, size: controlObject.texture!.size())
        
        body.dynamic = false
        
        controlObject.physicsBody = body
        
        return controlObject
    }
    
    func createDiamond() -> SKSpriteNode{
        
        var diamond = SKSpriteNode(imageNamed: "Diamond.png")
        
        var body = SKPhysicsBody(texture: diamond.texture, size: diamond.texture!.size())
        
        body.dynamic = false
        
        diamond.physicsBody = body
        
        diamond.alpha = 0.0
        
        return diamond
    }

    
    func drawControlCircle(radius: CGFloat) -> SKSpriteNode{
        var mainCircle = SKSpriteNode()
        mainCircle.size = CGSizeMake(radius * 2, radius * 2);
        var circleBody = SKPhysicsBody(circleOfRadius: radius)
        circleBody.dynamic = true
        circleBody.usesPreciseCollisionDetection = false
        mainCircle.physicsBody = circleBody
        var bodyPath : CGPathRef = CGPathCreateWithEllipseInRect(CGRectMake((-mainCircle.size.width/2), -mainCircle.size.height/2, mainCircle.size.width, mainCircle.size.width),nil)
        var circleShape = SKShapeNode()
        circleShape.fillColor = UIColor.brownColor()
//        circleShape.lineWidth = 0.5

//        circleShape.antialiased = true
        circleShape.path = bodyPath
        mainCircle.addChild(circleShape)
        mainCircle.alpha = 0.0
        
        return mainCircle
    }
    
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    func fadeOutAndKill(node: SKNode){
        var fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.7)
        var kill = SKAction.runBlock({
            node.removeFromParent()
        })
        
        var fadeAndKill = SKAction.sequence([fadeOut, kill])
        node.runAction(fadeAndKill)
    }
    
    func fadeOutAndKillWithDuration(node: SKNode, duration: NSTimeInterval){
        var fadeOut = SKAction.fadeAlphaTo(0.0, duration: duration)
        var kill = SKAction.runBlock({
            node.removeFromParent()
        })
        
        var fadeAndKill = SKAction.sequence([fadeOut, kill])
        node.runAction(fadeAndKill)
    }
    
    func fadeIn(node: SKNode, duration: Double){
        var fadeIn = SKAction.fadeInWithDuration(duration)
        node.runAction(fadeIn)
    }
    
    func drawTriangle() -> SKShapeNode{
        var triangle : SKShapeNode = SKShapeNode()
        var path = UIBezierPath()
        path.moveToPoint(CGPointMake(0.0, 0.0))
        path.addLineToPoint(CGPointMake(0.0, 22.0))
        path.addLineToPoint(CGPointMake(22.0, 0.0))
        path.addLineToPoint(CGPointMake(22.0, 22.0))
        path.closePath()
        triangle.path = path.CGPath
        triangle.fillColor = SKColor.redColor()
        triangle.antialiased = true;
        return triangle
    }
    
    func straightenControl(node: SKSpriteNode) -> Void {
        var straighten = SKAction.rotateToAngle(0, duration: 0.5)
        node.runAction(straighten)
    }

    func flash(node: SKShapeNode) -> Void {
        var out = SKAction.fadeAlphaTo(0.5, duration: 0.5)
        var fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.5)
        node.runAction(SKAction.sequence([out, fadeIn]))
    }
    
    
//    func reviseDifficulty(elapsedTime: CFTimeInterval, dropGenInterval: Double,
//        dropSpeed: Double, diamondLifeSpan: Double) -> (dropGenInterval: Double, dropSpeed: Double, diamondLifeSpan: Double ){
//            
//    }
    
    
 /**   func showHint() -> Int {
        
        var min = self.frame.origin.x + 20
        var max = self.frame.width - 20
        var xValue = Int(arc4random_uniform(UInt32(max - min + 1)))
        
        
        var hintLine = gameUtils.drawHintLine(self.frame.height)
        hintLine.position = CGPointMake(CGFloat(xValue), CGRectGetMidY(self.frame))
        var fadeIn = SKAction.fadeAlphaTo(0.3, duration: 0.25)
        var fadeOut = SKAction.fadeOutWithDuration(0.5)
        var kill = SKAction.runBlock({
            hintLine.removeFromParent()
        })
        hintLine.runAction(SKAction.sequence([fadeIn, fadeOut, kill]), withKey: "hintFlash")
        return xValue
    }*/
    
}
