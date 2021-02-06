//
//  ScoreViewController.swift
//  projet-ppm
//
//  Created by ramzi on 21/01/2021.
//

import UIKit

class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GestureManagerProtocol {

    
    
    let scoreModel = ScoreModel(scoreArray: PreferenceManager.sharedInstance.loadScorePreference(for: PreferenceKeys.score))
    let scoreView  = ScoreView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.scoreView
        // Do any additional setup after loading the view.
        self.scoreView.tableView?.delegate = self
        self.scoreView.tableView?.dataSource = self
        
        
        // gestion du geste vers le bas pour quiter
        let gesture = GestureManager(forView: self.view)
        gesture.delegate = self
        
        //self.scoreView.tableView?.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.presentingViewController != nil {
            self.scoreView.topSubView.backgroundColor = self.presentingViewController?.view.backgroundColor
            self.scoreView.bottomSubView.backgroundColor = self.presentingViewController?.view.backgroundColor
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.view.setNeedsDisplay()
    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scoreModel.getScoreArray()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseID = "ScoreTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseID) as? ScoreTableViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed(reuseID, owner: self, options: nil)?.first as? ScoreTableViewCell
            cell?.backgroundColor = .white
            cell?.nameLabel?.textColor = .black
            cell?.dateLabel?.textColor = .black
            cell?.scoreLabel?.textColor = .black
        }
        
        let row = indexPath.row
        self.updateCell(cell: cell, with: self.scoreModel.getScoreArray()![row])
        cell?.setNeedsDisplay()
        
        return cell!
    }
    
    func updateCell(cell: ScoreTableViewCell?,  with scoreDateObject:ScoreObject) {
        if !self.scoreModel.getScoreArray()!.isEmpty {
            cell?.nameLabel?.text = scoreDateObject.name.isEmpty ? "unknown" : scoreDateObject.name
            cell?.scoreLabel?.text = String(scoreDateObject.score)
            let date = scoreDateObject.date
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss - dd/MM/yyyy "
            cell?.dateLabel?.text = formatter.string(from: date)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    func moveUp() {
        self.dismiss(animated: true, completion: nil)
    }
}
