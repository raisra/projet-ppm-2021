//
//  GyroscopeManager.swift
//  projet-ppm
//
//  Created by ramzi on 25/01/2021.
//

import UIKit
import CoreMotion

protocol MotionManagerProtocol {
    func moveLeft()
    
    func moveRight()
}


class MotionManager: CMMotionManager {

    var delegate : MotionManagerProtocol?

    
    override init() {
        super.init()
        self.gyroUpdateInterval = 0.5
    }
    
    
    func start () {
        startDeviceMotionUpdates()
        startAccelerometerUpdates()
        self.startGyroUpdates()
    }
    
    
    func stop() {
        stopDeviceMotionUpdates()
        stopAccelerometerUpdates()
    }
    

    internal override func startGyroUpdates() {
        super.startGyroUpdates(to: .main ) { (data, error) in
            if let myData = data {
               // print("data from gyrscope")
//                let s = String(format: "%.2f",myData.rotationRate.z)
//                print(s)
                
                if myData.rotationRate.z > 0.1 {
                    self.delegate?.moveLeft()
                }
                
                else if myData.rotationRate.z < -0.1 {
                    self.delegate?.moveRight()
                }
            }
        }
    }

}
