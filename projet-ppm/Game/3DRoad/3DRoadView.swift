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
        super.init(frame: elem.frame)
        
        self.image = im
        self.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
