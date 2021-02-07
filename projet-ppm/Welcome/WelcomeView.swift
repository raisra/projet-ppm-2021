//
//  WelcomeView.swift
//  projet-ppm
//
// Desccription : Image d'acceuil : choix niveaux et boutton play.
//

import Foundation


import UIKit



class WelcomeView : UIView{

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var scoreButton: UIButton!
    
    var view : WelcomeView?
    
        
    let nibName = "WelcomeView"
    
   
       
    required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    

    override init(frame: CGRect) {
    
        view  = WelcomeView.loadFromXib(withOwner: WelcomeViewController.self)
        super.init(frame: frame)
        view?.frame = self.bounds

        playButton = view!.playButton
        settingsButton = view!.settingsButton
        chatButton = view!.chatButton
        scoreButton = view!.scoreButton
        
      
        addSubview(view!)
    }
    
  
    
   
    
}




