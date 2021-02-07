//
//  GyroscopeManager.swift
//  projet-ppm
//
//  Created by ramzi on 25/01/2021.
//

import UIKit
import CoreMotion

protocol MotionManagerProtocol {
    
    func gyroscopeUnvailable ()
}

class MotionManager: NSObject {
    
    var delegate : MotionManagerProtocol?
    
    fileprivate var motionManager:CMMotionManager? = CMMotionManager()
    
    // MARK: -
    
    override init() {
        if motionManager?.isGyroAvailable ?? false {
            motionManager?.gyroUpdateInterval = 0.5
        }
    }
    

    
 
    
    func isGyroscopeDeviceAvailable () -> Bool {
        if self.motionManager?.isGyroAvailable ?? false {
            return true
        }else{
            delegate?.gyroscopeUnvailable()
            return false
        }
    }
    
    func startGyro () {
//      motionManager?.startDeviceMotionUpdates()
//      motionManager?.startAccelerometerUpdates()
        motionManager?.startGyroUpdates()
    }
    
    func stop() {
        motionManager?.stopDeviceMotionUpdates()
        motionManager?.stopAccelerometerUpdates()
        motionManager?.stopGyroUpdates()
    }
    
    func getAcceralationCoordinate () -> (x:Double, y:Double, z:Double) {
        if motionManager?.isAccelerometerAvailable ?? false {
            return (motionManager?.deviceMotion?.gravity.x ?? 0,
                    motionManager?.deviceMotion?.gravity.y ?? 0,
                    motionManager?.deviceMotion?.gravity.z ?? 0)
        }
    
        
        return (0,0,0)
    }
    
    func getGyroCoordinate () -> (x:Double, y:Double, z:Double){
        if motionManager?.isGyroAvailable ?? false {
            return (motionManager?.gyroData?.rotationRate.x ?? 0,
                    motionManager?.gyroData?.rotationRate.y ?? 0,
                    motionManager?.gyroData?.rotationRate.z ?? 0)
            
        }
    
        return (0,0,0)
    }

}
