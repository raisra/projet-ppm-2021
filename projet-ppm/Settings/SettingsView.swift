//
//  LevelView.swift
//  projet-ppm
//
//  Created by jihane on 29/01/2021.
//

import Foundation
import UIKit

class SettingsView : UIView, UIPickerViewDelegate, UIPickerViewDataSource {
     
    @IBOutlet private var picker : UIPickerView!
    private var pickerData =  ["Beginner", "Medium", "Hard", "Extreme"]
    @IBOutlet private var textField : UITextField!
    @IBOutlet private var soundOnOff : UISwitch!
    @IBOutlet private var sound : UILabel!
    @IBOutlet private var done  : UIButton!
    var value : String = ""
    let h = UIScreen.main.bounds.height
    let w = UIScreen.main.bounds.width
    @IBOutlet private var nameControllerLabel : UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()

        // picker.delegate = self as UIPickerViewDelegate
        //picker.datasourcer = self as UIPickerViewDataSource
        self.picker.delegate = self
        self.picker.dataSource = self
        
        
        sound.text = "Sound :  "
        sound.font = UIFont.boldSystemFont(ofSize: 18.0)
        sound.textColor = .black
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
        let level = pickerData[row] as String
        choiceLevel(level : level)
        print (level)
    }
        
    func getValue (index: Int) -> String {
        return pickerData[index]
    }
    
    func choiceLevel(level : String){
        value = level
        print("choiceLevel a " + value )
    }
    

    
    override func draw(_ rect: CGRect) {
        picker.frame = CGRect(x: w/2-150, y: h/2-150,
                              width: 300, height: 300)
        
        done.frame = CGRect(x: rect.maxX - 20 - 50 ,y: 20,
                            width: 50, height: 50)
        
        soundOnOff.frame = CGRect(x: w/2 + 20, y: h/2-115,
                                  width: 100, height: 100)
        
        sound.frame = CGRect(x: w/2 - 50, y: h/2-150,
                             width: 100, height: 100)

    }
        
}

