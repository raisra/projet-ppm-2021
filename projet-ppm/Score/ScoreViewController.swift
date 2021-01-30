//
//  ScoreViewController.swift
//  projet-ppm
//
//  Created by ramzi on 21/01/2021.
//

import Foundation
import UIKit

class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let scoreModel = ScoreModel(scoreArray: PreferenceManager.sharedInstance.loadScorePreference(for: PreferenceKeys.score))
    let scoreView  = ScoreView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.scoreView
        
        self.scoreView.tableView?.delegate = self
        self.scoreView.tableView?.dataSource = self
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scoreModel.getScoreArray()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseID = "scoreTableViewCellReuse"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseID)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: reuseID)
        }
        
        if !self.scoreModel.getScoreArray()!.isEmpty {
            let row = indexPath.row
            let scoreDateObject: ScoreDataObject = self.scoreModel.getScoreArray()![row]
            cell?.textLabel?.text = scoreDateObject.name
            cell?.detailTextLabel?.text = String(scoreDateObject.score)
        }
        
        return cell!
    }
    
    
    
    @objc func backAction() {
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
