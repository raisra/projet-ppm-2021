//
//  SoundManager.swift
//  semaine 9.1
//
//  Created by ramzi on 11/12/2017.
//  Copyright © 2017 ramzi. All rights reserved.
//

import UIKit
import AVFoundation

// son-etoile.mp3, son.mp3, squeeze-toy-1.mp3, midnight-ride-01a.mp3

class SoundManager: NSObject, AVAudioPlayerDelegate {
    
    fileprivate var gameSound : AVAudioPlayer?
    fileprivate var coinSound : AVAudioPlayer?
    fileprivate var powerSound : AVAudioPlayer?
    fileprivate var jumpSound : AVAudioPlayer?
    fileprivate var gameOverSound : AVAudioPlayer?
    
    override init () {
        super.init()
        self.initialisation()
    }
    
    func initialisation () {
        var path = Bundle.main.path(forResource: "powerSound", ofType: "mp3")
        var url = URL (fileURLWithPath: path!)
        do {
            powerSound = try AVAudioPlayer (contentsOf: url)
            powerSound!.delegate = self
            powerSound!.prepareToPlay()
            print ("initialisation du son \"\(powerSound!.url!.lastPathComponent)\"")
        }catch let erreur {
            print ("***** ERROR : \(erreur.localizedDescription)")
        }
       
        path = Bundle.main.path(forResource: "jumpSound", ofType: "mp3")
        url = URL (fileURLWithPath: path!)
        do {
            jumpSound = try AVAudioPlayer (contentsOf: url)
            jumpSound!.delegate = self
            jumpSound!.prepareToPlay()
        }catch let erreur {
            print ("***** ERROR : \(erreur.localizedDescription)")
        }

        path = Bundle.main.path(forResource: "coinSound", ofType: "mp3")
        url = URL (fileURLWithPath: path!)
        do {
            coinSound = try AVAudioPlayer (contentsOf: url)
            coinSound!.delegate = self
            coinSound!.prepareToPlay()
        }catch let erreur {
            print ("***** ERROR : \(erreur.localizedDescription)")
        }

        path = Bundle.main.path(forResource: "gameSound", ofType: "mp3")
        url = URL (fileURLWithPath: path!)
        do {
            gameSound = try AVAudioPlayer (contentsOf: url)
            gameSound!.delegate = self
            gameSound!.numberOfLoops = -1
            gameSound!.volume = 0
            gameSound!.prepareToPlay()
        }catch let erreur {
            print ("***** ERROR : \(erreur.localizedDescription)")
        }
    
        path = Bundle.main.path(forResource: "gameOverSound", ofType: "wav")
        url = URL (fileURLWithPath: path!)
        do {
            gameOverSound = try AVAudioPlayer (contentsOf: url)
            gameOverSound!.delegate = self
            gameOverSound!.numberOfLoops = -1
            gameOverSound!.volume = 0
            gameOverSound!.prepareToPlay()
        }catch let erreur {
            print ("***** ERROR : \(erreur.localizedDescription)")
        }
    }
    
    func playGameSound () {
        let soundOnOff = PreferenceManager.sharedInstance.loadBoolPreference(for: PreferenceKeys.sound)!
        if soundOnOff {
            gameSound!.play()
            gameSound!.volume = 0.3
        }
        
    }
    @objc func stopGameSound() {
        print(#function)
        if (gameSound!.volume > 0) {
            gameSound!.setVolume(0, fadeDuration: 1)
            Timer.scheduledTimer(timeInterval: 1.1, target: self, selector: #selector(stopGameSound), userInfo: nil, repeats: false)
            return
        }
        
        
        gameSound!.stop()
        gameSound!.currentTime = 0
    }
    func playPowerSound () {
        let soundOnOff = PreferenceManager.sharedInstance.loadBoolPreference(for: PreferenceKeys.sound)!
        if soundOnOff {
            powerSound!.play()
        }
       
        
    }
    func playCollisionSound () {
        
        let soundOnOff = PreferenceManager.sharedInstance.loadBoolPreference(for: PreferenceKeys.sound)!
        if soundOnOff {
            coinSound!.play()
        }
    }
    
    
    func playCoinSound () {
        
        let soundOnOff = PreferenceManager.sharedInstance.loadBoolPreference(for: PreferenceKeys.sound)!
        if soundOnOff {
            coinSound!.play()
        }
    }
    
    func playJumpSound () {
        let soundOnOff = PreferenceManager.sharedInstance.loadBoolPreference(for: PreferenceKeys.sound)!
        if soundOnOff {
            jumpSound!.play()
        }
    }
    
    func playGameOverSound () {
        let soundOnOff = PreferenceManager.sharedInstance.loadBoolPreference(for: PreferenceKeys.sound)!
        if soundOnOff {
            gameOverSound!.play()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print ("Lecture terminée: " + (player.url?.lastPathComponent ?? ""))
        }else {
            print ("Interruption impromptue")
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print ("Erreur de lecture \(error?.localizedDescription)")
    }

}
