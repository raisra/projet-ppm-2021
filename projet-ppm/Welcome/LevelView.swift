//
//  LevelView.swift
//  projet-ppm
//
//  Created by jihane on 29/01/2021.
//

import Foundation
import UIKit

class LevelView : UIView, UIPickerViewDelegate, UIPickerViewDataSource {
     
    private var picker =  UIPickerView()
    private var pickerData =  ["Beginner", "Medium", "Hard", "Extreme"]
    private let textField = UITextField()
    private let done  = UIButton()
    private var value = ""

    override init (frame: CGRect){
        super.init(frame: frame)
        // picker.delegate = self as UIPickerViewDelegate
        //picker.datasourcer = self as UIPickerViewDataSource
        self.picker.delegate = self
        self.picker.dataSource = self
        self.textField.inputView = picker
        picker.center = self.center
        self.addSubview(picker)
        
        done.setTitle("done", for: [])
        done.setTitleColor(UIColor.white, for: [])
        done.addTarget(self.superview, action: #selector(buttondisplay), for: .touchUpInside )
        self.addSubview(done)
         self.display_constraint()

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        choiceLevel(level : pickerData[row])
        return pickerData[row]
    }
        
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func getValue (index: Int) -> String {
        return pickerData[index]
    }
    
    func choiceLevel(level : String){
        value = level
    }
    
    func getLevel() -> String! {
        return value
    }
    
    func display_constraint(){
        done.translatesAutoresizingMaskIntoConstraints = false
        let dico = ["D": self.done, "P": self.picker]
        var constraints: [NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[D(50)]", metrics: nil, views:dico)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[D(50)]", metrics: nil, views:dico)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[D]", metrics: nil, views:dico)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-500-[D]", metrics: nil, views:dico)
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[P(200)]", metrics: nil, views:dico)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[P(200)]", metrics: nil, views:dico)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-130-[P]", metrics: nil, views:dico)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-260-[P]", metrics: nil, views:dico)
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func buttondisplay(){
        levelView.isHidden = true
    }
        
}
