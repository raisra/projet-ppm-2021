//
//  LevelView.swift
//  projet-ppm
//
//  Created by jihane on 29/01/2021.
//

import Foundation
import UIKit

class SettingsView : UIView, UIPickerViewDelegate, UIPickerViewDataSource {
     
    private var picker =  UIPickerView()
    private var pickerData =  ["Beginner", "Medium", "Hard", "Extreme"]
    private let textField = UITextField()
    private let soundOnOff = UISwitch()
    private let sound = UILabel()
    private let done  = UIButton()
    var value : String = ""
    let h = UIScreen.main.bounds.height
    let w = UIScreen.main.bounds.width
    

    override init (frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white

        // picker.delegate = self as UIPickerViewDelegate
        //picker.datasourcer = self as UIPickerViewDataSource
        self.picker.delegate = self
        self.picker.dataSource = self
        self.textField.inputView = picker
        picker.center = self.center
        self.addSubview(picker)
        
        done.setTitle("done", for: [])
        done.setTitleColor(UIColor.black, for: [])
        done.addTarget(self.superview, action: #selector(buttondisplay), for: .touchUpInside )
        
        
        sound.text = "Sound :  "
        sound.font = UIFont.boldSystemFont(ofSize: 18.0)
        sound.textColor = .black
        
        self.addSubview(sound)
        self.addSubview(soundOnOff)
        self.addSubview(done)
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
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func getValue (index: Int) -> String {
        return pickerData[index]
    }
    
    func choiceLevel(level : String){
        value = level
        print("choiceLevel a " + value )
    }
    

    
    override func draw(_ rect: CGRect) {
        picker.frame = CGRect(x: w/2-150, y: h/2-150, width: 300, height: 300)
        done.frame = CGRect(x: w/2+50, y: h/2-250, width: 100, height: 100)
        soundOnOff.frame = CGRect(x: w/2 + 20, y: h/2-115, width: 100, height: 100)
        sound.frame = CGRect(x: w/2 - 50, y: h/2-150, width: 100, height: 100)

    }
    
    @objc func soundON() -> Bool{
        return soundOnOff.isOn
    }
    
    @objc func buttondisplay(){
        sView.isHidden = true
        wView.isHidden = false
    }
        
}
