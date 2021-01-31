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
    fileprivate var collisionSound : AVAudioPlayer?
    fileprivate var endSound : AVAudioPlayer?
    fileprivate var edgeSound : AVAudioPlayer?
    fileprivate var gameOverSound : AVAudioPlayer?
    
    override init () {
        super.init()
        self.initialisation()
    }
    
    func initialisation () {
        var path = Bundle.main.path(forResource: "son-etoile", ofType: "mp3")
        var url = URL (fileURLWithPath: path!)
        do {
            endSound = try AVAudioPlayer (contentsOf: url)
            endSound!.delegate = self
            endSound!.prepareToPlay()
            print ("initialisation du son \"\(endSound!.url!.lastPathComponent)\"")
        }catch let erreur {
            print ("***** ERROR : \(erreur.localizedDescription)")
        }
       
        path = Bundle.main.path(forResource: "son", ofType: "mp3")
        url = URL (fileURLWithPath: path!)
        do {
            edgeSound = try AVAudioPlayer (contentsOf: url)
            edgeSound!.delegate = self
            edgeSound!.prepareToPlay()
        }catch let erreur {
            print ("***** ERROR : \(erreur.localizedDescription)")
        }

        path = Bundle.main.path(forResource: "squeeze-toy-1", ofType: "mp3")
        url = URL (fileURLWithPath: path!)
        do {
            collisionSound = try AVAudioPlayer (contentsOf: url)
            collisionSound!.delegate = self
            collisionSound!.prepareToPlay()
        }catch let erreur {
            print ("***** ERROR : \(erreur.localizedDescription)")
        }

        path = Bundle.main.path(forResource: "midnight-ride-01a", ofType: "mp3")
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
    
        path = Bundle.main.path(forResource: "gameover", ofType: "wav")
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
        gameSound!.play()
        gameSound!.volume = 0.3
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
    func playEndSound () {
        endSound!.play()
    }
    func playCollisionSound () {
        if collisionSound!.isPlaying {
            collisionSound!.stop()
            collisionSound!.currentTime = 0.0
        }
        
        collisionSound!.play()
    }
    func playEdgeSound () {
        edgeSound!.play()
    }
    
    func playGameOverSound () {
        if gameOverSound!.isPlaying {
            gameOverSound!.stop()
            gameOverSound!.currentTime = 0.0
        }
        gameOverSound!.play()
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
