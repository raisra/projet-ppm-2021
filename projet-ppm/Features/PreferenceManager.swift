
//
//  PreferenceManager.swift
//  projet-ppm
//
//  Created by ramzi on 29/01/2021.
//
// ---------- sources ------------
// https://www.hackingwithswift.com/example-code/system/how-to-save-and-load-objects-with-nskeyedarchiver-and-nskeyedunarchiver

import UIKit

class PreferenceManager: NSObject {
    
    static let sharedInstance = PreferenceManager()
    
    let standartDefault = UserDefaults.standard
    
    private override init() {
        super.init()
        self.initialisePreferenceData()
    }

    
    fileprivate func initialisePreferenceData (){
        self.savePreferenceDefault()
        let i = self.loadIntPreference(for: "numberOfLaunchApp") + 1
        self.savePreference(int: i, for: "numberOfLaunchApp")
        let _ = self.getUserDefaultPath()
    }

    
    func loadIntPreference(for key: String) -> Int {
        return standartDefault.integer(forKey: key)
    }
    
    func loadStringPreference (for key: String) -> String? {
        return standartDefault.string(forKey: key)
    }
    
    func loadBoolPreference (for key: String) -> Bool? {
        return standartDefault.bool(forKey: key)
    }
    
    func loadDataPreference (for key: String) -> Data? {
        return standartDefault.data(forKey: key)
    }
    
    func loadScorePreference(for key: String) -> [ScoreObject] {
        var scores = [ScoreObject]()
        do {
            for scoreData in (standartDefault.array(forKey: key) as! [NSData]) {
                let score =  try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(scoreData as Data)
                if score != nil {
                    scores.append(score! as! ScoreObject)
                }
                
            }
        }catch {
            print ("EXCEPTION CATCH : line " + String(#line), terminator: " from ")
        }
        
        return scores
    }
    

    func savePreference(string: String, for key:String) {
        standartDefault.set(string, forKey: key)
        standartDefault.synchronize()
    }
    
    func savePreference(bool: Bool, for key:String) {
        standartDefault.set(bool, forKey: key)
        standartDefault.synchronize()
    }
    
    func savePreference(int: Int, for key:String) {
        standartDefault.set(int, forKey: key)
        standartDefault.synchronize()
    }
    func savePreference(scores: [NSData], for key: String) {
        standartDefault.set(scores, forKey: key)
        standartDefault.synchronize()
    }
    func savePreference(score: ScoreObject, for key: String){
        do {
            let dataScore = try NSKeyedArchiver.archivedData(withRootObject: score, requiringSecureCoding: false)
            // load score data array
            var scores = standartDefault.array(forKey: PreferenceKeys.score) as! [NSData]
            
            scores.append(dataScore as NSData)
            let scoresSorted = self.sortScore(scores: scores)
            self.savePreference(scores: scoresSorted, for: key)
        }catch {
            print ("EXCEPTION CATCH : line " + String(#line), terminator: " from ")
        }
    }
    

    fileprivate func sortData(data_1:NSData, data_2:NSData) -> Bool {
        // decharchive data_1 en scoreDataObject
        let score_1 = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data_1 as Data) as! ScoreObject
        let score_2 = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data_2 as Data) as! ScoreObject
        return score_1.score > score_2.score
    }

    fileprivate func sortScore(scores: [NSData]) -> [NSData]{
        return scores.sorted(by: sortData)
    }

    
    // n'enregistre par default, mais si userDefault load une value/key qui n'exite pas
    // alors il va chercher cette value/key dans le dictionnaire par default
    func savePreferenceDefault() {
        var defaultPref = [String:Any]()
            defaultPref.updateValue(0, forKey: PreferenceKeys.launche)
            defaultPref.updateValue(true, forKey: PreferenceKeys.sound)
            defaultPref.updateValue(true, forKey: PreferenceKeys.gyroscope)
            defaultPref.updateValue("unknown", forKey: PreferenceKeys.name)
//            let score = ScoreObject(score: 50, date: Date(), name: "ramzi")
//            let dataScore = try! NSKeyedArchiver.archivedData(withRootObject: score, requiringSecureCoding: false)
//            var scores = [Data]()
//            scores.append(dataScore)
//            defaultPref.updateValue(scores, forKey: PreferenceKeys.score)
        defaultPref.updateValue([ScoreObject](), forKey: PreferenceKeys.score)
            
            standartDefault.register(defaults: defaultPref)
            standartDefault.synchronize()
    }
    

    
    func getUserDefaultPath () -> String {
        let path: [AnyObject] = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as [AnyObject]
        let folder: String = path[0] as! String
        NSLog("Your UserDefaults are stored in this folder: %@/Preferences", folder)
        return folder
    }

}


struct PreferenceKeys {
    static let score        = "scores"
    static let name         = "name"
    static let launche      = "numberOfLaunchApp"
    static let sound        = "sound"
    static let gyroscope    = "gyroscope"
}
