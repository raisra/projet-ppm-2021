//
//  ChatModel.swift
//  projet-ppm
//
//  Created by ramzi on 30/01/2021.
//

import UIKit

struct Message {
    var _isItMe: Bool   = false
    var _name:String    = ""
    var _message:String = ""
}

class MessageModel {
    
  
    
    var data : [Message]
    var chatStatus = "loading" // 2 connected , loading,
    var networkManager: NetworkManager
    
   
    init(){
        networkManager = NetworkManager()
        networkManager.checkConnection()
        
        data =[Message]()
    }
    
    
    func nbOfMessages() -> Int {
        return data.count
    }
    
    
}
