//
//  ScoreModel.swift
//  projet-ppm
//
//  Created by ramzi on 29/01/2021.
//

import UIKit

class ScoreModel: NSObject {

    fileprivate var scoreArray: [ScoreDataObject]?
    
    
    init (scoreArray: [ScoreDataObject]) {
        super.init()
        self.scoreArray = scoreArray
    }
    
    func getScoreArray () -> [ScoreDataObject]?{
        return self.scoreArray
    }
}
