//
//  Message.swift
//  projet-ppm
//
//  Created by Nathan on 30/01/2021.
//

import Foundation
import UIKit
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}
struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

extension Sender {
    var toJSON: Any {
        return [
          "senderId": senderId,
          "displayName": displayName
        ]
    }

    init?(fromJSON json: Any) {
        guard
            let data = json as? [String: Any],
            let senderId = data["senderId"] as? String,
            let displayName = data["displayName"] as? String
        else {
            print("Couldn't parse Member")
            return nil
        }

        self.displayName = displayName
        self.senderId = senderId
    }
    
}
