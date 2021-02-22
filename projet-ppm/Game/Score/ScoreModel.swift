//
//  ScoreModel.swift
//  projet-ppm
//
//  Created by ramzi on 29/01/2021.
//

import UIKit

class ScoreModel: NSObject {

    fileprivate var scoreArray: [ScoreObject]?
    
    
    init (scoreArray: [ScoreObject]) {
        super.init()
        self.scoreArray = scoreArray
    }
    
    func getScoreArray () -> [ScoreObject]?{
        return self.scoreArray
    }
    
    func addScore(score: ScoreObject){
        scoreArray?.append(score)
    }
}

