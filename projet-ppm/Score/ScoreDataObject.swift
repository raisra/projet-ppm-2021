//
//  ScoreDataObject.swift
//  projet-ppm
//
//  Created by ramzi on 29/01/2021.
//

import UIKit

class ScoreDataObject: NSObject, NSCoding {

    var score : Int     = 0
    var date  : Date  = Date()
    var name  : String  = ""

    init(score: Int, date: Date, name: String) {
        self.score = score
        self.name  = name
        self.date  = date
    }
    

    
    func encode(with coder: NSCoder) {
        coder.encode(self.score, forKey: "score")
        coder.encode(self.date, forKey: "date")
        coder.encode(self.name, forKey: "name")
    }
    
    required init?(coder: NSCoder) {
        super.init()
        self.score = coder.decodeInteger(forKey: "score")
        self.name  = coder.decodeObject(forKey: "name") as! String
        self.date  = coder.decodeObject(forKey: "date") as! Date
    }

    
}
