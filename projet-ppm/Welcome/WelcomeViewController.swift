//
//  ViewController.swift
//  projet-ppm
//
//  Description : lancement du jeu et choix du niveau (vitesse du jeu)
//

import UIKit

class WelcomeViewController: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.isModalInPresentation = true
        self.view = WelcomeView(frame: UIScreen.main.bounds)
    }
    
    
    
    @objc func startGame() {
        print("Start Game")

        let gvc = GameViewController()

        gvc.modalTransitionStyle = .flipHorizontal
        gvc.modalPresentationStyle = .fullScreen

        self.present(gvc , animated: true, completion: nil)
    }
    
    
    
    @objc func levelChoices() {
       print( "trying" )
    }
    
    
    
    
//
//    let names : [TypeOfElem: String] = [.straight:"straight", .bridge:"bridge", .empty: "empty", .passage: "passage", .tree: "tree"]
//    let duration : TimeInterval = 2
//    let factor = 0.455
//    let deltaY: CGFloat = 1
//    let param : ModelRoad.Param = ModelRoad.Param(nRows: 100,
//                                                  nColumns: 3,
//                                                  W: UIScreen.main.bounds.width,
//                                                  H: UIScreen.main.bounds.height*0.7,
//                                                  i0: 320.0*UIScreen.main.bounds.width/1024.0,
//                                                  i3: 480.0*UIScreen.main.bounds.width/1024.0 ,
//                                                  bSize: 10.0, fSize: 50.0,
//                                                  useData: false)
//    //init du model
//    let modelRoad = ModelRoad(param)
//
//
//    let threeDRoadVC = ThreeDRoadViewController(names: names, duration: duration, model: modelRoad, factor: 0.455, size0: <#CGSize#>)
//        threeDRoadVC.modalTransitionStyle = .flipHorizontal
//            threeDRoadVC.modalPresentationStyle = .fullScreen
//    self.present(threeDRoadVC , animated: true, completion: nil)
    
    
}

