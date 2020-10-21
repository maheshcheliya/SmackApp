//
//  SocketService.swift
//  Smack
//
//  Created by Mahesh on 21/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    static let instance = SocketService()
    var manager : SocketManager!
    var socket : SocketIOClient!
    
    override init() {
        super.init()
        self.manager = SocketManager(socketURL: URL(string: BASE_URL)!)
        self.socket = manager.defaultSocket
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(channelName : String, channelDesc : String, completion : @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDesc)
        completion(true)
    }
    
    func getChannel(completion : @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1] as? String else { return }
            guard let channelID = dataArray[2] as? String else { return }
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelID)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
}
