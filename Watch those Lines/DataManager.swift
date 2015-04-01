//
//  ScoreManager.swift
//  Rain
//
//  Created by RaghuKV on 3/22/15.
//  Copyright (c) 2015 RaghuKV. All rights reserved.
//

import Foundation

class DataManager {
    
    var scores:Array<BestScore> = [];
    
    
    /* Initialize with default values first time*/
    var userPrefs : UserPreferences = UserPreferences(userTookInstr: false)
    
    init() {
        // load existing high scores or set up an empty array
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as String
        
        
        let highScorePath = documentsDirectory.stringByAppendingPathComponent("HighScores.plist")
        let userPrefPath = documentsDirectory.stringByAppendingPathComponent("UserPrefs.plist")
        
        
        let fileManager = NSFileManager.defaultManager()
        
        loadScores(highScorePath, fileManager: fileManager)
        loadUserPrefs(userPrefPath, fileManager: fileManager)
        
    }
    
    func loadScores(highScorePath : String, fileManager: NSFileManager) {
        // check if file exists
        if !fileManager.fileExistsAtPath(highScorePath) {
            // create an empty file if it doesn't exist
            if let bundle = NSBundle.mainBundle().pathForResource("DefaultFile", ofType: "plist") {
                fileManager.copyItemAtPath(bundle, toPath: highScorePath, error:nil)
            }
        }
        
        if let rawData = NSData(contentsOfFile: highScorePath) {
            // do we get serialized data back from the attempted path?
            // if so, unarchive it into an AnyObject, and then convert to an array of HighScores, if possible
            var scoreArray: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData);
            self.scores = scoreArray as? [BestScore] ?? [];
        }
    }
    
    func loadUserPrefs(userPrefPath: String, fileManager : NSFileManager){
        if !fileManager.fileExistsAtPath(userPrefPath){
            if let bundle = NSBundle.mainBundle().pathForResource("DefaultFile", ofType: "plist"){
                fileManager.copyItemAtPath(bundle, toPath: userPrefPath, error: nil)
            }
        }
        
        if let prefRawData = NSData(contentsOfFile: userPrefPath){
            var preferences: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(prefRawData);
            self.userPrefs = preferences as UserPreferences
        }
    }
    
    func saveUserPrefs() {
        let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.userPrefs);
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray;
        let documentsDirectory = paths.objectAtIndex(0) as NSString;
        let path = documentsDirectory.stringByAppendingPathComponent("UserPrefs.plist");
        saveData.writeToFile(path, atomically: true);
    }

    
    func saveScore() {
        // find the save directory our app has permission to use, and save the serialized version of self.scores - the HighScores array.
        let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.scores);
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray;
        let documentsDirectory = paths.objectAtIndex(0) as NSString;
        let path = documentsDirectory.stringByAppendingPathComponent("HighScores.plist");
        saveData.writeToFile(path, atomically: true);
    }
    
    // a simple function to add a new high score, to be called from your game logic
    // note that this doesn't sort or filter the scores in any way
    func addNewScoreAndSave(newScore:Int, checkPoint: Int) {
        let newHighScore = BestScore(score: newScore, checkPoint: checkPoint);
        self.scores.append(newHighScore);
        self.saveScore();
    }
}