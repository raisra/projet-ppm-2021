//
//  ConnectionTCPManager.swift
//  projet-ppm
//
//  Created by ramzi on 30/01/2021.
//

import UIKit
import Network


protocol receiveTCP {
    func receiveTCP(data : String)
}


class NetworkManager {

    private var connection: NWConnection?
    private var host: NWEndpoint.Host
    private var port: NWEndpoint.Port
    
    
    //private var queue : DispatchQueue
    
  
    
    var delegate : receiveTCP?
    
    init(host:String , port:String ) {
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(port)!
        
        
        connectTCP()
    }
    
    
//
//     func checkAndConnect (){
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                print("We're connected!")
//                self.connectTCP()
//            } else {
//                print("No connection.")
//            }
//
//            print(path.isExpensive)
//        }
//        let queue = DispatchQueue(label: "Monitor")
//
//        monitor.start(queue: queue)
//    }
    
    
    private
    func connectTCP()
    {
        connection = NWConnection(host: host, port: port, using: .tcp)
        connection?.receive(minimumIncompleteLength: 1, maximumLength: 128, completion: completionWhenReceiveTCP)
        let queueTCP = DispatchQueue(label: "TCP_queue", qos: .utility)
        connection?.start(queue: queueTCP)
        connection?.stateUpdateHandler =
            {
                (newState) in switch (newState)
                {
                case .ready:
                    //The connection is established and ready to send and recieve data.
                    print("ready")

                case .setup:
                    //The connection has been initialized but not started
                    print("setup")
                case .cancelled:
                    //The connection has been cancelled
                    print("cancelled")
                case .preparing:
                    //The connection in the process of being established
                    print("Preparing")
                default:
                    //The connection has disconnected or encountered an error
                    print("waiting or failed")
                    print(self.connection?.debugDescription)
                }
            }
        
    }
    
    
    private func completionWhenReceiveTCP(data: Data?, isComplete : NWConnection.ContentContext?, _ : Bool , error: NWError?) {
        
        print("Got it ... is Complete: " + isComplete.debugDescription)
        if let err = error {
            print("Recieve error: \(err)")
            return
        }
        
        if data != nil {
            delegate?.receiveTCP(data: String(data:data!, encoding: .utf8)!)
        }
    }
    
    
   
        
        
    
    
    
    
    
    
    func close() {
        connection?.cancel()
        connection?.stateUpdateHandler = nil
        connection = nil
    }
    
    
    
    func sendMsg(_ packet:String) {
        let packetData = packet.data(using: .utf8)
        let completionHandler = { (error: NWError?) in
            if let err = error {
                print("Sending error \(err)")
            } else {
                print("Sent successfully")
                
            }
        }
        
        connection?.send(content: packetData, completion: NWConnection.SendCompletion.contentProcessed(completionHandler))
    }
    

    
    
    
    
    
    
    
    
    
}
