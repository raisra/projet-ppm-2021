//
//  3DRoad.swift
//  projet-ppm
//
//  Created by ramzi on 21/01/2021.
//

import Foundation
import UIKit





class ThreeDRoadView : UIImageView {    
    var elem : ThreeDElem

    init(elem: ThreeDElem, im: UIImage) {
        self.elem = elem
        super.init(image: im)
        
        //self.center = elem.center
        self.frame = elem.frame
        self.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
