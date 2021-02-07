//
//  SettingsViewController.swift
//  projet-ppm
//
//  Created by maher on 07/02/2021.
//

import UIKit




enum Level: Int {
    case Beginner=0
    case Medium=1
    case Hard=2
    case Extreme=3
}




class SettingsViewController: UIViewController
, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {

  
    
    static let sharedInstance = SettingsViewController(nibName: "SettingsView", bundle: nil)
    
   
    var level : Level = Level.Beginner
    
    
    @IBOutlet private var picker : UIPickerView!
    private var pickerData =  ["Beginner", "Medium", "Hard", "Extreme"]
    @IBOutlet private var textField : UITextField!
    @IBOutlet private var soundOnOff : UISwitch!
    @IBOutlet private var sound : UILabel!
    @IBOutlet private var done  : UIButton!
 
    let h = UIScreen.main.bounds.height
    let w = UIScreen.main.bounds.width
    @IBOutlet private var nameControllerLabel : UILabel!
    
    
    override  func awakeFromNib() {
        print ("----")
    }
 
    
    
    override func viewDidLoad() {
        let currentName = PreferenceManager.sharedInstance.loadStringPreference(for: PreferenceKeys.name)
        textField.text = currentName == "unknown" ? "" : currentName
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        super.viewDidLoad()
    }
    


    
    @IBAction func backToMenu (_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchSound (_ sender: UISwitch) {
        let soundSwitch = sender as UISwitch
        PreferenceManager.sharedInstance.savePreference(bool: soundSwitch.isOn , for: PreferenceKeys.sound)
    }
    
    func soundOn() ->Bool {
        return soundOnOff.isOn
    }

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let levelStr = pickerData[row] as String
        
        
        switch levelStr {
        case "Beginner" :
            level = .Beginner
        case "Medium" :
            level = .Medium
        case "Hard" :
            level = .Hard
        case "Extreme" :
            level = .Extreme
        default :
            level = .Beginner
        }
    }
        
    func getValue (index: Int) -> String {
        return pickerData[index]
    }
    
 
    
    
    func getLevel() -> Level {
        return level
    }

    
    
    
    func getLevelDuration() -> TimeInterval{
        let levell : Level = SettingsViewController.sharedInstance.getLevel()
        var duration : TimeInterval
        
       
        switch  levell {
        case .Beginner :
            duration = 0.6
        case .Medium :
            duration = 0.4
        case .Hard :
            duration = 0.3
        case .Extreme :
            duration = 0.2
        default :
            duration = 0.6
        }
        
        return duration

     }

    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            return false
        }else {
            textField.resignFirstResponder()
            PreferenceManager.sharedInstance.savePreference(string: textField.text!, for: PreferenceKeys.name)
            return true
        }
    }
    

    
}
