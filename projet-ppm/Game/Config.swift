//
//  Config.swift
//  projet-ppm
//
//  Created by ramzi on 06/02/2021.
//

import Foundation
import UIKit







let DISTANCE_OF_MAGNET = 5
let TTL_POWER : TimeInterval = 5.0
let COINS_ARE_ANIMATED = false
let INITIAL_CHAR_POSITION : CGFloat = 1
let BACK_GROUND_IMAGE = "aboveTheSky"

let NB_ROWS : CGFloat = 10
let NB_COLUMNS : CGFloat = 5

let DURATION : TimeInterval = 0.5
//the size of the uiview representing the character
let sizeChar  = CGSize(width: 200, height: 450)

//let names : [TypeOfElem: String] = [.straight:"straight", .bridge:"bridge", .empty: "empty", .passage: "passage", .tree: "tree"]
let NAMES : [TypeOfObject: String] = [STRAIGHT:"pave", BRIDGE:"bridge", _EMPTY_: "pave", PASSAGE: "pave", TREE: "tree", TURN_RIGHT:"turnRight", TURNLEFT : "turnLeft"]


var sizeIm = CGSize(width: 400, height: 100)
let alpha : CGFloat = 75.96
let factor : CGFloat = 309.96/398.52




let JUMP_DURATION : TimeInterval = 1.0
let BLINK_DURATION : TimeInterval = 0.5
let MOVE_DURATION : TimeInterval = 1.0
let TRANSPARENCY_DURATION : TimeInterval = 3.0


