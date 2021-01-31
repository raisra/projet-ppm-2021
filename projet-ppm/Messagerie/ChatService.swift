//
//  ChatService.swift
//  projet-ppm
//  Created by Nathan on 30/01/2021.
//

import Foundation
import Scaledrone

class ChatService: ScaledroneDelegate {
    
    private let scaledrone: Scaledrone
    private let messageCallback: (Message)-> Void

    private var room: ScaledroneRoom?

    init(member: Sender, onRecievedMessage: @escaping (Message)-> Void) {
        self.messageCallback = onRecievedMessage
        self.scaledrone = Scaledrone(
          channelID: "OIreIrOtFSiBFmNN",
          data: member.toJSON)
        scaledrone.delegate = self
    }

    func connect() {
        scaledrone.connect()
    }
    
    func sendMessage(_ message: String) {
        room?.publish(message: message)
    }
    
    func scaledroneDidConnect(scaledrone: Scaledrone, error: Error?) {
        print("Connected to Scaledrone")
        room = scaledrone.subscribe(roomName: "observable-room")
        room?.delegate = self
    }
    
    func scaledroneDidReceiveError(scaledrone: Scaledrone, error: Error?) {
        print("Scaledrone error", error ?? "")
    }
    
    func scaledroneDidDisconnect(scaledrone: Scaledrone, error: Error?) {
        print("Scaledrone disconnected", error ?? "")
    }
}

extension ChatService: ScaledroneRoomDelegate {
    func scaledroneRoomDidConnect(room: ScaledroneRoom, error: Error?) {
        print("Connected to room!")
    }
    
    func scaledroneRoomDidReceiveMessage(room: ScaledroneRoom, message: Any, member: ScaledroneMember?) {
        guard
            let text = message as? String,
            let memberData = member?.clientData,
            let member = Sender(fromJSON: memberData)
        else {
            print("Could not parse data.")
            return
        }
        
        let message = Message(
            sender: member,
            messageId: UUID().uuidString,
            sentDate: Date(),
            kind: .text(text)
        )
        messageCallback(message)
    }
    
}
