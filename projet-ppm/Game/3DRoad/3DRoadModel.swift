//
//  3DRoadController.swift
//  projet-ppm
//
//  Created by ramzi on 21/01/2021.
//

import Foundation

enum TypeOf3DRoadElement: Int {
    case straight = 0
    case turnLeft = 1
    case turnRight = 2
    case tree = 3
    case bridge = 4
    case passage = 5
    case empty = 6
}


class ThreeDRoadModel {
    
    var elementsToDisplay : [TypeOf3DRoadElement]
    let nbElements : Int = 4
    
    
    init() {
        elementsToDisplay = [TypeOf3DRoadElement].init(repeating: TypeOf3DRoadElement.straight, count: nbElements)
    }
    
    
    //usefull when we want to turn the camera
    func generateElementStraight()->TypeOf3DRoadElement?{
        elementsToDisplay.remove(at: 0)
        elementsToDisplay.append(TypeOf3DRoadElement.straight)
        return TypeOf3DRoadElement.straight
    }
    
    func generateElement(level : Level)->TypeOf3DRoadElement?{
        if(elementsToDisplay.count != nbElements) {
            print("erreur dans elements: il devrait y avoir toujours 4 elements")
            return nil
        }
        
        let lastElement = elementsToDisplay[nbElements-1]
        elementsToDisplay.remove(at: 0)
       
        
        var nextPossibleElements : [TypeOf3DRoadElement]
        
        switch lastElement {
        case .straight:
            //straight turn tree bridge passage
            nextPossibleElements = [.straight, .turnLeft, .turnRight, .bridge, .passage, .tree]
            break
    
            
        case .turnLeft, .turnRight, .passage, .bridge, .tree, .empty :
            nextPossibleElements = [.straight]
            break

        default:
            nextPossibleElements = [.straight]
            break
        }
        
        
        var nextElement : TypeOf3DRoadElement
        var probability : Int = 100
        
        switch level {
        case .easy:
           probability = 80
            break
        case .average:
          probability = 50
            break
            
        case .hard:
            probability = 30
            break
            
        default:
            probability = 50
            break
        }
        
        let p = Int.random(in: 1...100)
        if p < probability {
            nextElement = .straight
        }
        else{
            let r = Int.random(in : 0..<nextPossibleElements.count)
            nextElement = nextPossibleElements[r]
        }
        
        elementsToDisplay.append(nextElement)
     
        return lastElement
    }
    
    
    func getElements() -> [TypeOf3DRoadElement] {
        return elementsToDisplay
    }
    
}
