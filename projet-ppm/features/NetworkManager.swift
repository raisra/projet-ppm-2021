//
//  ConnectionTCPManager.swift
//  projet-ppm
//
//  Created by ramzi on 30/01/2021.
//

import UIKit
import Network




class NetworkManager {
    
    var available = false
    let monitor = NWPathMonitor()
    
    let serveurEndPoint: NWEndpoint = NWEndpoint.hostPort(host:NWEndpoint.Host(_SERVER.adresse),
                                                          port: NWEndpoint.Port(String(_SERVER.port))!)
    
    private var connection: NWConnection?
    private var queue = DispatchQueue(label: "Ramzi_dispathQueue", qos: .utility)
    var host: NWEndpoint.Host
    var port: NWEndpoint.Port
    
    var msg : String = ""
  
    
    init(host:String = _SERVER.adresse , port:String = _SERVER.port) {
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(port)!
    }
    
    
    
    func checkConnection (){
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                self.available = true
                self.connectTCP()
            } else {
                print("No connection.")
            }
            
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    
    
    
    
    func connectTCP()
    {
        connection = NWConnection(host: host, port: port, using: .tcp)
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
        receiveTCP()
        connection?.start(queue: queue)
    }
    
    
    func close() {
        connection?.cancel()
        connection?.stateUpdateHandler = nil
        connection = nil
    }
    
    
    
    func sendPaket(_ packet:String) {
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
    

    
    
    
    func receiveTCP() {
        
        let completionWhenReceiveTCP = {
            (data: Data?, isComplete : NWConnection.ContentContext?, _ : Bool , error: NWError?) in
            print("Got it ... is Complete: " + isComplete.debugDescription)
            if let err = error {
                print("Recieve error: \(err)")
                return
            }
            
            if data == nil {
                self.msg = String(data:data!, encoding: .utf8)!
            }
        }
        
        connection?.receive(minimumIncompleteLength: 1, maximumLength: 128, completion: completionWhenReceiveTCP)
    }
    
    
    
    
    
}
