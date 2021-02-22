//
//  ScoreViewController.swift
//  projet-ppm
//
//  Created by ramzi on 21/01/2021.
//

import UIKit

class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    static let sharedInstance = ScoreViewController()
    
    var gesture: GestureManager?
    var scoreModel = ScoreModel(scoreArray: PreferenceManager.sharedInstance.loadScorePreference(for: PreferenceKeys.score))
    let scoreView  = ScoreView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.scoreView
        // Do any additional setup after loading the view.
        self.scoreView.tableView?.delegate = self
        self.scoreView.tableView?.dataSource = self
        self.scoreView.backButton.addTarget(self,
                                            action: #selector(backMenu),
                                            for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideCloseButton()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.view.setNeedsDisplay()
    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let size = self.scoreModel.getScoreArray()?.count ?? 0
        self.scoreView.footerViewLabel.isHidden = size > 0 ? true : false
        return size
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
    
    
    @objc func backMenu() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func hideCloseButton() {
        scoreView.backButton.isHidden = true
    }
    
    func showCloseButton() {
        scoreView.backButton.isHidden = false
    }
    
    func addScore(score : ScoreObject) {
        PreferenceManager.sharedInstance.savePreference(score: score, for: PreferenceKeys.score)
        scoreModel.addScore(score: score)
    }
}
