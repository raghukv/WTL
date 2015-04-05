//
//  GameViewController.swift
//  Rain
//
//  Created by RaghuKV on 2/24/15.
//  Copyright (c) 2015 RaghuKV. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation

extension SKNode {
    class func unarchive(file : NSString) -> SKNode? {
        if var path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            var scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as MenuScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    
//    required init(coder aDecoder: NSCoder)
//    {
//        super.init(coder: aDecoder)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

            }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        if var scene = MenuScene.unarchive("MenuScene") as? MenuScene {
            
            
            // Configure the view.
            let skView = self.view as SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//            skView.showsPhysics = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            scene.size = skView.bounds.size
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            scene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
        
            skView.presentScene(scene)
        }

    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {

            return Int(UIInterfaceOrientationMask.All.rawValue)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
